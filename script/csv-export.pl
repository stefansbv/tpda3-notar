#!/home/stefan/perl5/perlbrew/perls/current/bin/perl
#
# Export data from database tables into CSV files, using the
# Text::CSV_XS module.
#
# Copyright 2011 Ștefan Suciu
#

use strict;
use warnings;
use Carp;

use DBI;
use Text::CSV_XS;
use Try::Tiny;
use Term::ReadKey;

use Getopt::Long;
use Pod::Usage;

# Parse options and print usage if there is a syntax error,
# or if usage was explicitly requested.
my ($help, $man);
my ($dbname, $table, $file, $batch);
my ($module, $user, $pass, $port);
my $server = 'localhost';

# Process options.
if ( @ARGV > 0 ) {
    GetOptions(
        'help|?'   => \$help,
        'man'      => \$man,
        'server=s' => \$server,
        'port=s'   => \$port,
        'module=s' => \$module,
        'dbname=s' => \$dbname,
        'table=s'  => \$table,
        'file=s'   => \$file,
        'user=s'   => \$user,
        'pass=s'   => \$pass,
        'batch'    => \$batch,
      ),
      or pod2usage(2);
}
if ( $man or $help or $#ARGV >= 0 ) {

    # Load Pod::Usage only if needed.
    pod2usage(1) if $help;
    pod2usage( VERBOSE => 2 ) if $man;
    if ( $#ARGV >= 0 ) {
        Pod::Usage::pod2usage("$0: Too many arguments");
    }
}

unless ($dbname) {
    pod2usage("\n$0: The database name is required\n");
}
unless ($table) {
    pod2usage("\n$0: The table name is required\n");
}
unless ($module) {
    pod2usage("\n$0: Module name is required\n");
}

# Check if output file is provided
if ( !$file ) {

    # if not, use database and table name
    $file = "$dbname-$table.dat";
}


if ( !$batch ) {
    print "\n";
    print "Server    = $server\n";
    print "Database  = $dbname\n";
    print "Module    = $module\n";
    print "Table     = $table\n";
    print "Data file = $file\n\n";
}

my $dbh;
if ( $module =~ /fb|firebird/i ) {

    # Firebird
    $port ||= '3050';

    unless ( $user or $pass ) {
        if ($batch) {
            pod2usage("\n$0: User and pass are required\n");
        }
        else {
            $user = read_username() if !$user;
            $pass = read_password() if !$pass;
        }
    }

    try {
        $dbh = DBI->connect(
              "dbi:Firebird:"
            . "dbname=$dbname"
            . ";ib_dialect=3"
            . ";host=$server"
            . ";port=$port"
            , $user
            , $pass
            , { RaiseError => 1, FetchHashKeyName => 'NAME_lc' }
        );
    }
    catch {
        croak "caught error: $_";
    };
}
elsif ( $module =~ /pg|pgsql|postgresql/i ) {

    # PostgreSQL
    $port ||= '5432';

    unless ( $user or $pass ) {
        if ($batch) {
            pod2usage("\n$0: User and pass are required\n");
        }
        else {
            $user = read_username() if !$user;
            $pass = read_password() if !$pass;
        }
    }

    try {
        $dbh = DBI->connect(
              "dbi:Pg:"
            . "dbname=$dbname"
            . ";host=$server"
            . ";port=$port"
            , $user
            , $pass
            , { RaiseError => 1, FetchHashKeyName => 'NAME_lc' }
        );
        $dbh->{pg_enable_utf8} = 1;
    }
    catch {
        croak "caught error: $_";
    };

}
elsif ( $module =~ /my|mysql/i ) {

    # MySQL
    $port ||= '3306';

    unless ( $user or $pass ) {
        if ($batch) {
            pod2usage("\n$0: User and pass are required\n");
        }
        else {
            $user = read_username() if !$user;
            $pass = read_password() if !$pass;
        }
    }

    unless ( $user && $pass ) {
        pod2usage("\n$0: User and pass are required\n") if ! $batch;
    }

    try {
        $dbh = DBI->connect(
              "dbi:mysql:"
            . "database=$dbname"
            . ";host=$server"
            . ";port=$port"
            , $user
            , $pass
            , { RaiseError => 1, FetchHashKeyName => 'NAME_lc' }
        );
    }
    catch {
        croak "caught error: $_";
    };
}
elsif ( $module =~ /si|sqlite/i ) {

    # SQLite
    try {
        $dbh = DBI->connect( "dbi:SQLite:$dbname", q{}, q{} );
    }
    catch {
        croak "caught error: $_";
    };

}
else {
    print "db = $module?\n";
    exit;
}

my $sql = qq{ SELECT * FROM $table };

my $csv_o = Text::CSV_XS->new(
    {
        'sep_char'     => ';',
        'always_quote' => 0,
        'binary'       => 1
    }
);

open my $out_fh, '>:encoding(utf8)', $file
    or die "Can't open file ",$file, ": $!";

$dbh->{AutoCommit} = 0;    # enable transactions, if possible
$dbh->{RaiseError} = 1;
$dbh->{LongReadLen} = 512 * 1024;

try {
    my $st = $dbh->prepare($sql);

    $st->execute;

    $csv_o->eol ("\n");
    # First line is the table name
    print { $out_fh } $table, "\n";

    # Header
    my @fld_name = @{ $st->{NAME} };
    my $status = $csv_o->print( $out_fh, \@fld_name );
    if ( !$status ) {
        my $bad_argument = $csv_o->error_input();
        print "Error: $bad_argument\n";
    }

    my $recno = 0;

    while ( my @rezultat = $st->fetchrow_array() ) {

        # Data
        my $status2 = $csv_o->print( $out_fh, \@rezultat );
        if ( !$status2 ) {
            my $bad_argument = $csv_o->error_input();
            print "Error: $bad_argument\n";
        }

        $recno++;
    }
    print "\n $recno records exported to $file\n";
}
catch {
    warn "caught error: $_";
};

close($out_fh) or die "Can't close file: $!\n";

$dbh->disconnect();

print "\nDone!\n";

exit 0;

sub read_username {
    my $self = shift;

    print ' Enter your username: ';

    my $user = ReadLine(0);
    chomp $user;

    return $user;
}

sub read_password {
    my $self = shift;

    print ' Enter your password: ';

    ReadMode('noecho');
    my $pass = ReadLine(0);
    print "\n";
    chomp $pass;
    ReadMode('normal');

    return $pass;
}

__END__

=head1 NAME

export-csv.pl - Export records from database tables into custom CSV files.

=head1 USAGE

export-csv.pl [-help | -man]

export-csv.pl -module <module> -dbname <dbname> [-table <table>]

=head1 OPTIONS

=over

=item B<module> Database driver name

The module options are:
    fb | firebird           for Firebird
    pg | pgsql | postgresql for Postgresql
    my | mysql              for MySQL
    si | sqlite             for SQLite

=item B<server>

Server name, default is I<localhost>.

=item B<dbname>

Database name or path for Firebird.

=item B<table>

The name of the table to export data from.

=item B<file>

Output file name, defaults to C<< <dbname>-<table>.dat >>.

=item B<user>

User name, if required by the module and not supplied, prompt for it.

=item B<pass>

Password,  if required by the module and not supplied, prompt for it.

=item B<batch>

Batch mode, suppresses prompting and help messages.

=back

=head1 DESCRIPTION

Export data as custom CSV from database tables.  The delimiter is the
semicolon and the first line in the files contains the table name.
The second line is the list of the table columns and the rest is
column data.  The format is also used by the C<import-csv.pl> script.

=head1 BUGS AND LIMITATIONS

Using passwords on the command line is not always a good idea.

=head1 AUTHOR

Stefan Suciu

=head1 LICENCE AND COPYRIGHT

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
