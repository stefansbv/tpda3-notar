package Tpda3::Tk::App::Notar::Personal;

use strict;
use warnings;
use utf8;

use Tk::widgets qw(); # JComboBox

use base q{Tpda3::Tk::Screen};

use POSIX qw (strftime);

use Tpda3::Utils;

=head1 NAME

Tpda3::Tk::App::Notar::Personal screen.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    require Tpda3::App::Notar::Personal;

    my $scr = Tpda3::App::Notar::Personal->new;

    $scr->run_screen($args);

=head1 METHODS

=head2 run_screen

The screen layout

=cut

sub run_screen {
    my ( $self, $nb ) = @_;

    my $rec_page  = $nb->page_widget('rec');
    my $det_page  = $nb->page_widget('det');
    $self->{view} = $nb->toplevel;
    $self->{bg}   = $self->{view}->cget('-background');

    my $validation
        = Tpda3::Tk::Validation->new( $self->{scrcfg}, $self->{view} );

    my $date_format = $self->{scrcfg}->app_dateformat();

    #- For day names
    my @daynames = ();
    foreach ( 0 .. 6 ) {
        push @daynames, strftime( "%a", 0, 0, 0, 1, 1, 1, $_ );
    }

    #- Frame - top

    my $frm_top = $rec_page->LabFrame(
        -foreground => 'blue',
        -label      => 'Personal',
        -labelside  => 'acrosstop',
    );
    $frm_top->grid(
        $frm_top,
        -row    => 0, -column => 0,
        -ipadx  => 3, -ipady  => 3,
        -sticky => 'nsew',
    );

    my $f1d = 110;              # distance from left

    #- id_pers (id_pers)

    my $lid_pers = $frm_top->Label( -text => 'Identificator', );
    $lid_pers->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );

    my $eid_pers = $frm_top->MEntry(
        -width              => 10,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eid_pers->form(
        -top  => [ '&', $lid_pers, 0 ],
        -left => [ %0,  $f1d ],
    );

    #- nume (nume)

    my $lnume = $frm_top->Label( -text => 'Nume', );
    $lnume->form(
        -top     => [ $lid_pers, 8 ],
        -left    => [ %0,        0 ],
        -padleft => 5,
    );

    my $enume = $frm_top->MEntry(
        -width => 25,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'nume', @_ );
        },
    );
    $enume->form(
        -top  => [ '&', $lnume, 0 ],
        -left => [ %0,  $f1d ],
    );

    #- prenume (prenume)

    my $lprenume = $frm_top->Label( -text => 'Prenume', );
    $lprenume->form(
        -top     => [ $lnume, 8 ],
        -left    => [ %0,     0 ],
        -padleft => 5,
    );

    my $eprenume = $frm_top->MEntry(
        -width => 30,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'prenume', @_ );
        },
    );
    $eprenume->form(
        -top  => [ '&', $lprenume, 0 ],
        -left => [ %0,  $f1d ],
    );

    #- functia (functia)

    my $lfunctia = $frm_top->Label( -text => 'Functia', );
    $lfunctia->form(
        -top     => [ $lprenume, 8 ],
        -left    => [ %0,        0 ],
        -padleft => 5,
    );

    my $efunctia = $frm_top->MEntry(
        -width              => 30,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $efunctia->form(
        -top  => [ '&', $lfunctia, 0 ],
        -left => [ %0,  $f1d ],
    );

    #- data_ang (data_ang)

    my $vdata_ang;
    my $ldata_ang = $frm_top->Label( -text => 'Dată angajare', );
    $ldata_ang->form(
        -top     => [ $lfunctia, 8 ],
        -left    => [ %0,        0 ],
        -padleft => 5,
    );

    my $ddata_ang = $frm_top->DateEntry(
        -daynames        => \@daynames,
        -variable        => \$vdata_ang,
        -arrowimage      => 'calmonth16',
        -todaybackground => 'lightblue',
        -weekstart       => 1,
        -parsecmd        => sub {
            Tpda3::Utils->dateentry_parse_date( $date_format, @_ );
        },
        -formatcmd => sub {
            Tpda3::Utils->dateentry_format_date( $date_format, @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ddata_ang->form(
        -top  => [ '&', $ldata_ang, 0 ],
        -left => [ %0, $f1d ],
    );

    #- data_plec (data_plec)

    my $vdata_plec;
    my $ldata_plec = $frm_top->Label( -text => 'Dată plecare', );
    $ldata_plec->form(
        -top     => [ $ldata_ang, 8 ],
        -left    => [ %0,         0 ],
        -padleft => 5,
    );

    my $ddata_plec = $frm_top->DateEntry(
        -daynames        => \@daynames,
        -variable        => \$vdata_plec,
        -arrowimage      => 'calmonth16',
        -todaybackground => 'lightblue',
        -weekstart       => 1,
        -parsecmd        => sub {
            Tpda3::Utils->dateentry_parse_date( $date_format, @_ );
        },
        -formatcmd => sub {
            Tpda3::Utils->dateentry_format_date( $date_format, @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ddata_plec->form(
        -top  => [ '&', $ldata_plec, 0 ],
        -left => [ %0, $f1d ],
    );

    # Entry objects: var_asoc, var_obiect
    # Other configurations in '.conf'
    $self->{controls} = {
        id_pers   => [ undef,        $eid_pers ],
        nume      => [ undef,        $enume ],
        prenume   => [ undef,        $eprenume ],
        functia   => [ undef,        $efunctia ],
        data_ang  => [ \$vdata_ang,  $ddata_ang ],
        data_plec => [ \$vdata_plec, $ddata_plec ],
    };

    return;
}


=head1 AUTHOR

Ștefan Suciu, C<< <stefbv70 la gmail punct com> >>

=head1 BUGS

None known.

Please report any bugs or feature requests to the author.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Ștefan Suciu

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation.

=cut

1; # End of Tpda3::App::Notar::Personal
