#!/usr/bin/perl
#
# +--------------------------------------------------------------------------+
# | Description   : Test merge TT document                                   |
# | Author        : Stefan Suciu                                             |
# | Version       : 0.20                                                     |
# | Last modified : duminică, 16 octombrie 2011                              |
# +--------------------------------------------------------------------------+

use strict;
use warnings;

use Data::Dumper;
use utf8;

use File::Basename;
use Config::General;
use Template;

use Getopt::Long;
use Pod::Usage;

#--- Options                          |

my $help   = 0;
my $man    = 0;

# Process options.
if ( @ARGV > 0 ) {
    GetOptions(
        'help|?'  => \$help,
        'man'     => \$man,
      ),
      or pod2usage(2);
}
if ( $man or $help or $#ARGV >= 0 ) {
    pod2usage(1) if $help;
    pod2usage( VERBOSE => 2 ) if $man;
    if ( $#ARGV != 0 ) {
        pod2usage(
            {
                -message => "Too many arguments.\n",
                -verbose => 1,
            }
        );
    }
}

my $tt_file = shift;

pod2usage(
    -verbose  => 1
) unless ( defined $tt_file );

pod2usage(
    { -message => "File $tt_file is not a regular file!\n",
      -verbose => 1, }
) unless ( -f $tt_file );

my ($day, $month, $year) = (localtime)[3,4,5];
my $today = sprintf("%02d.%02d.%04d", $day, $month+1, $year+1900);

print "\n";
print "Today : $today\n";

my ($name) = fileparse( $tt_file, qr/\Q.tt\E/ );
my $tex_file = "$name.tex";
my $cfg_file = "$name.conf";

print "Input : $tt_file\n";
print "Output: $tex_file\n";
print "Data  : $cfg_file\n";

my $tt = Template->new(
    {
        ENCODING     => 'utf8',
        INCLUDE_PATH => './',
        OUTPUT_PATH  => './',
        PLUGIN_BASE  => 'Tpda3::Template::Plugin',
    }
);

my $r_data = load_conf($cfg_file);

my $recno = scalar keys %{$r_data->{r}};

print "Vars  : $recno\n";

$tt->process( $tt_file, $r_data, $tex_file, binmode => ':utf8' ) => '',
    or die $tt->error(), "\n";

print "Done.\n";

#---

sub load_conf {
    my $config_file = shift;

    my $conf = Config::General->new(
        -UTF8       => 1,
        -ForceArray => 1,
        -ConfigFile => $config_file,
    );

    my %config = $conf->getall;

    return \%config;
}

__END__

=head1 NAME

merge-tt-document - Test merge TT document

=head1 VERSION

This documentation refers to merge-tt-document version 0.20

=head1 SYNOPSIS

merge-tt-document.pl <template-TT-filename.tt>

=head1 REQUIRED ARGUMENTS

TT file name.  Extension can be .tt or .tt<anything>

=head1 OPTIONS

=over

=item B<-man>

Prints the manual page and exits.

=item B<-help>

Prints options help and exits.

=back

=head1 DESCRIPTION

A full description of the application and its features.
May include numerous subsections (i.e. =head2, =head3, etc.)

=head1 DEPENDENCIES

Only core modules

=head1 INCOMPATIBILITIES

None known

=head1 BUGS AND LIMITATIONS

None known

=head1 AUTHOR

Stefan Suciu (C) 2010-2011

=head1 LICENCE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
