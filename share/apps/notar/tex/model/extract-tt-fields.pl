#!/usr/bin/perl
# +--------------------------------------------------------------------------+
# | Description   : Extract fields from TT template files                    |
# | Author        : Stefan Suciu                                             |
# | Version       : 0.31                                                     |
# +--------------------------------------------------------------------------+

use strict;
use warnings;

use Carp;
use Getopt::Long;
use Pod::Usage;

#--- Options

my $help   = 0;
my $man    = 0;
my $sorted = 0;
my $uniq   = 0;
my $summ   = 0;

# Process options.
if ( @ARGV > 0 ) {
    GetOptions(
        'help|?'  => \$help,
        'man'     => \$man,
        'sorted'  => \$sorted,
        'unique'  => \$uniq,
        'summary' => \$summ,
        ),
        or pod2usage(2);
}
if ( $man or $help or $#ARGV >= 0 ) {
    pod2usage(1) if $help;
    pod2usage( VERBOSE => 2 ) if $man;
    if ( $#ARGV != 0 ) {
        pod2usage(
            {   -message => "Too many arguments.\n",
                -verbose => 1,
            }
        );
    }
}

my $tt_file = shift;

pod2usage( -verbose => 1 ) unless ( defined $tt_file );

pod2usage( {
    -message => "File $tt_file is not a regular file!\n",
    -verbose => 1,
} ) unless ( -f $tt_file );

my ( $fields, $unique ) = extract_tt_fields($tt_file);

if ($sorted) {
    $fields = sort_fields($fields);
    $unique = sort_fields($unique);
}

if ($uniq) {
    list_fields($unique);
}
else {
    list_fields($fields);
}

if ($summ) {
    print_summary( $fields, $unique );
}

#--- Subs

sub extract_tt_fields {
    my $nume_fisier = shift;

    open my $file_fh, '<', $nume_fisier
        or croak "Can't open file ", $nume_fisier, ": $!";

    my @fields = ();
    my @unique = ();
    my %seen   = ();

    while ( my $line = <$file_fh> ) {

        my ($field) = $line =~ m{\[%(.*?)%\]}xmg;

        next unless $field;

        # Trim spaces
        $field =~ s/^\s+//;
        $field =~ s/\s+$//;

        # Store field name
        push @fields, $field;

        # Store uniq name
        next if $seen{$field}++;
        push @unique, $field;
    }

    close $file_fh;

    return ( \@fields, \@unique );
}

sub list_fields {
    my $list = shift;

    print "\nFields list:\n---\n";
    print join "\n", @{$list};
    print "\n---\n";

    return;
}

sub sort_fields {
    my $list = shift;

    my @sorted = sort @{$list};

    return \@sorted;
}

sub print_summary {
    my ( $fields, $unique ) = @_;

    my $count_vars = scalar @{$fields};
    my $count_uniq = scalar @{$unique};

    print "\nSummary:\n";
    print " $count_vars variables found\n";
    print " $count_uniq unique variables\n";

    return;
}

__END__

=head1 NAME

extract-tt-fields.pl - Extract field names from TT template files

=head1 VERSION

This documentation refers to extract-tt-fields version 0.30

=head1 SYNOPSIS

extract-tt-fields.pl <template-TT-filename.tt>

=head1 REQUIRED ARGUMENTS

TT file name.  Extension can be .tt or .tt<anything>

=head1 OPTIONS

=over

=item B<-sort>

Sort variables by name alphabetically.

=item B<-unique>

List variable names only once.

=item B<-summary>

Add a summary, about the number of fields, to the output.

=item B<-man>

Prints the manual page and exit.

=item B<-help>

Print options help and exit.

=back

=head1 DESCRIPTION

The application lists to STDOUT all TT field names it can found in the
TT template file passed as argument.  The fields are in the form [%
fieldname %].  There are options for listing only unique field names
and for sorting them.  Another option is to print a summary with the
number of the fields found.

=head1 DEPENDENCIES

Only core modules

=head1 INCOMPATIBILITIES

None known

=head1 BUGS AND LIMITATIONS

None known

=head1 AUTHOR

Stefan Suciu (C) 2010

=head1 LICENCE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
