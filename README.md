Tpda3 Notar
===========
Ștefan Suciu <stefan 'la' s2i2.ro>
2012-12-19

Tpda3 (Tiny Perl Database Application 3)
Copyright (C) 2010-2012  Stefan Suciu
GNU General Public License v3

This is a Tpda3 application.

Version:  0.16
Language: Romanian

Description:


Requirements
------------

- Perl v5.8.9 or newer.
- PostgreSQL version 8.2 or greater
- Tpda3

Installation
------------

Create a PostgreSQL database for the application.  As a convenience,
the dbrecreate.sh bash script can be used to create a test database on
localhost, but must be edited first.  Set at least the user and
password.

Set DBI_USER and DBI_PASS environment vars before test.

Install Tpda3 if not installed yet.

Install Tpda3-Notar with:

<pre>
% tar xaf Tpda3-Notar-0.XX.tar.gz
% cd Tpda3-Notar-0.XX
% perl Makefile.PL
% make
% make test
% make install
</pre>

Run for the first time to populate the configuration directory.

<pre>
% tpda3 notar
</pre>

### Alternative installation

#### GNU/Linux

[Using the custom Citrus Perl distribution](http://sourceforge.net/projects/tpda/files/CitrusPerl-Tpda3/tpda3perl-standard-51402-20903-linux-x86-061.tar.gz/download)

Open a terminal and load the Citrus Perl environment:

<pre>
% source ~/path/to/Tpda3Perl/bin/citrusvars.sh
% tar xaf Tpda3-Notar-0.XX.tar.gz
% cd Tpda3-Notar-0.XX
% perl Makefile.PL
% make
% make test
% make install
</pre>

Finally we start the app with:

<pre>
% tpda3 notar
</pre>

#### Windows

[Using the custom Citrus Perl distribution](http://sourceforge.net/projects/tpda/files/CitrusPerl-Tpda3/tpda3perl-standard-51402-20903-msw-x86-062.zip/download)

Unzip the distribution to a folder, for example C:\dev\

Run: C:\dev\Tpda3Perl\bin\citrusterm.bat to open a terminal, unzip
Tpda3-Notar-0.XX.zip

<pre>
% cd Tpda3-Notar-0.XX
% perl Makefile.PL
% make
% make test
% make install
</pre>

License And Copyright
---------------------

Copyright (C) 2010-2012 Stefan Suciu

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2 dated June, 1991 or at your option
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

A copy of the GNU General Public License is available in the source tree;
if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
