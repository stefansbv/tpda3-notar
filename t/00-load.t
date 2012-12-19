#
# Tpda3 use test script
#

use Test::More tests => 2;

diag( "Testing with Perl $], $^X" );

#-- Tpda3 framework

use_ok('Tpda3');

#-- Tpda3-Notar application

use_ok('Tpda3::Tk::App::Notar');

#-- done
