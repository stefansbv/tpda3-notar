#
# Makefile.PL for Tpda3-Notar
#
# Copyright (C) 2010-2011  Stefan Suciu
# GNU General Public License v3
#

#use 5.010;
use strict;
use warnings;

use inc::Module::Install;

name     'Tpda3-Notar';
version  '0.16';
license  'gpl';
abstract ' ... - Application for the Tpda3 framework';
author   'Stefan Suciu, <stefansbv at users.sourceforge.net>';

requires 'perl'                     => '5.010001';

#- Tk
requires 'Tk'                       => '804.028';
requires 'Tk::ToolBar'              => '0.09';
requires 'Tk::StatusBar'            => '0.04';
requires 'Tk::MListbox'             => '1.11';
requires 'Tk::JComboBox'            => '1.14';
requires 'Tk::DateEntry'            => '1.39';
requires 'Tk::TableMatrix'          => '1.23';
requires 'Tk::RadiobuttonGroup'     => '0.2.2';

#- Database
requires 'DBD::Pg'                  => '1.32';

#- Other
# requires 'Email::Valid'             => '0';

install_share  'share';

WriteAll;
