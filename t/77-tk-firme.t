#
# Tpda3 Tk GUI test script
#

use strict;
use warnings;

use lib qw( lib ../lib t/lib );

use Tpda3::Tk::ScreenTest q{test_screen};

my $args = {
    cfname => 'notar',
    user   => undef,
    pass   => undef,
};

$args->{user} = $ENV{DBI_USER} unless defined $args->{user};
$args->{pass} = $ENV{DBI_PASS} unless defined $args->{pass};

test_screen($args, 'Tpda3::Tk::App::Notar::Firme');

# done
