package Tpda3::Tk::App::Notar::Persoane;

use strict;
use warnings;
use utf8;

use Tk::widgets qw(DateEntry JComboBox RadiobuttonGroup);

use base q{Tpda3::Tk::Screen};

use POSIX qw (strftime);
use Date::Calc qw(check_date);

use Tpda3::Utils;
use Tpda3::Config;
use Tpda3::Tk::TM;

=head1 NAME

Tpda3::App::Notar::Persoane screen

=head1 VERSION

Version 0.17

=cut

our $VERSION = '0.17';

=head1 SYNOPSIS

    require Tpda3::App::Notar::Persoane;

    my $scr = Tpda3::App::Notar::Persoane->new;

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

    # For DateEntry day names
    my @daynames = ();
    foreach ( 0 .. 6 ) {
        push @daynames, strftime( "%a", 0, 0, 0, 1, 1, 1, $_ );
    }

    #- Top Frame

    my $frame_top = $rec_page->LabFrame(
        -foreground => 'blue',
        -label      => 'Date personale',
        -labelside  => 'acrosstop'
    )->pack(
        -expand => 0,
        -fill   => 'x'
    );

    #--

    my $f1d = 110;              # distance from left

    # id_pers (id_pers)
    my $lid_pers = $frame_top->Label( -text => 'Identificator' );
    $lid_pers->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );

    my $eid_pers = $frame_top->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eid_pers->form(
        -top  => [ '&', $lid_pers, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ cnp

    my $ecnp = $frame_top->MEntry(
        -width => 13,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'cnp', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ecnp->form(
        -top   => [ '&', $lid_pers, 0 ],
        -right => [ %100, -5 ],
    );
    my $lcnp = $frame_top->Label( -text => 'CNP', );
    $lcnp->form(
        -top     => [ '&',   $lid_pers, 0 ],
        -right   => [ $ecnp, -10 ],
        -padleft => 5,
    );

    $ecnp->bind( '<KeyPress-Return>' => sub { $self->cnp_ok($date_format); } );

    #-- Nume (nume)

    my $lnume = $frame_top->Label( -text => 'Nume' );
    $lnume->form(
        -top  => [ $lid_pers, 8 ],
        -left => [ %0,       0 ],
        -padleft => 5,
    );
    my $enume = $frame_top->MEntry(
        -width    => 18,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'nume', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $enume->form(
        -top  => [ '&', $lnume, 0 ],
        -left => [ %0,  $f1d ],
    );

    #-+ prenume

    my $eprenume = $frame_top->MEntry(
        -width    => 25,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'prenume', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eprenume->form(
        -top   => [ '&',  $lnume, 0 ],
        -right => [ %100, -5 ],
    );
    my $lprenume = $frame_top->Label( -text => 'Prenume', );
    $lprenume->form(
        -top     => [ '&',       $lnume, 0 ],
        -right   => [ $eprenume, -10 ],
        -padleft => 5,
    );

    #-- data_nast

    my $vdata_nast;
    my $ldata_nast = $frame_top->Label(
        -text => 'Data nașterii',
    );
    $ldata_nast->form(
        -top  => [ $lnume, 8 ],
        -left => [ %0, 0 ],
        -padleft => 5,
    );

    my $ddata_nast = $frame_top->DateEntry(
        -daynames        => \@daynames,
        -variable        => \$vdata_nast,
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
    $ddata_nast->form(
        -top  => [ '&', $ldata_nast, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ prenume_p

    my $eprenume_p = $frame_top->MEntry(
        -width    => 25,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'prenume_p', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eprenume_p->form(
        -top   => [ '&',  $ldata_nast, 0 ],
        -right => [ %100, -5 ],
    );
    my $lprenume_p = $frame_top->Label( -text => 'Prenume părinte', );
    $lprenume_p->form(
        -top     => [ '&',         $eprenume_p, 0 ],
        -right   => [ $eprenume_p, -10 ],
        -padleft => 5,
    );

    #-- nation - Nationalitate

    my $lnation = $frame_top->Label(
        -text => 'Naționalitate',
    );
    $lnation->form(
        -top  => [ $ldata_nast, 8 ],
        -left => [ %0, 0 ],
        -padleft => 5,
    );
    my $enation = $frame_top->MEntry(
        -width => 30,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'nation', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $enation->form(
        -top  => [ '&', $lnation, -2 ],
        -left => [ %0, $f1d ],
        -pady => 5,
    );

    #-+ Gen biologic (gen)

    my $genuri = [ qw{Masculin Feminin} ];
    my $vgen;
    my $rgen = $frame_top->RadiobuttonGroup(
        -list        => $genuri,
        -orientation => 'horizontal',
        -variable    => \$vgen,
    );
    $rgen->form(
        -top   => [ '&', $lnation, 0 ],
        -right => [ %100, -5 ],
    );

    my $lgen = $frame_top->Label( -text => 'Gen', );
    $lgen->form(
        -top     => [ '&',   $lnation, 0 ],
        -right   => [ $rgen, -10 ],
        -padleft => 5,
    );

    my $my_font = $enume->cget('-font');    # font

    #- Middle top frame

    my $frame_mdl_b = $rec_page->LabFrame(
        -foreground => 'blue',
        -label      => 'Adresa',
        -labelside  => 'acrosstop'
    )->pack(
        -expand => 0,
        -fill   => 'x'
    );

    #- tara_ds - Țară

    my $ltara_ds = $frame_mdl_b->Label(
        -text => 'Țara',
    );
    $ltara_ds->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );

    my $etara_ds = $frame_mdl_b->MEntry(
        -width              => 30,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $etara_ds->form(
        -top  => [ '&', $ltara_ds, 0 ],
        -left => [ %0,  $f1d ],
    );

    #-+ tara_cod_ds - Cod țară

    my $etara_cod_ds = $frame_mdl_b->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $etara_cod_ds->form(
        -top  => [ '&',      $ltara_ds, 0 ],
        -left => [ $etara_ds, 5 ],
    );

    #-- loc_strain_ds

    my $lloc = $frame_mdl_b->Label( -text => 'Localitate', );
    $lloc->form(
        -top     => [ $ltara_ds, 8 ],
        -left    => [ %0,        0 ],
        -padleft => 10,
    );

    my $lloc_strain_ds = $frame_mdl_b->Label( -text => '* Străinatate', );
    $lloc_strain_ds->form(
        -top     => [ $lloc, 8 ],
        -left    => [ %0,    0 ],
        -padleft => 10,
    );
    my $eloc_strain_ds = $frame_mdl_b->MEntry(
        -width              => 60,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eloc_strain_ds->form(
        -top  => [ '&', $lloc_strain_ds, 0 ],
        -left => [ %0, $f1d ],
    );

    #-- loc_ds - Localitate domiciliu stabil

    my $lloc_ds = $frame_mdl_b->Label( -text => '* România' );
    $lloc_ds->form(
        -top     => [ $lloc_strain_ds, 8 ],
        -left    => [ %0,         0 ],
        -padleft => 10,
    );

    my $eloc_ds = $frame_mdl_b->MEntry(
        -width              => 30,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    my ($ejud_ds, $ecodp_ds);
    $eloc_ds->form(
        -top  => [ '&', $lloc_ds, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ jud_ds

    $ejud_ds = $frame_mdl_b->MEntry(
        -width              => 3,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ejud_ds->form(
        -top  => [ '&',      $lloc_ds, 0 ],
        -left => [ $eloc_ds, 6 ]
    );

    #-+ codp_ds (Cod postal localitate domiciliu stabil)

    $ecodp_ds = $frame_mdl_b->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $ecodp_ds->form(
        -top  => [ '&',         $lloc_ds, 0 ],
        -left => [ $ejud_ds, 5 ]
    );

    #-+ siruta_ds

    my $esiruta_ds = $frame_mdl_b->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $esiruta_ds->form(
        -top  => [ '&',        $lloc_ds, 0 ],
        -left => [ $ecodp_ds, 5 ],
    );

    #-- Adresa_Ds (adresa_ds)

    my $ladresa_ds = $frame_mdl_b->Label( -text => 'Adresă' );
    $ladresa_ds->form(
        -top     => [ $lloc_ds, 8 ],
        -left    => [ %0, 0 ],
        -padleft => 5
    );

    my $tadresa_ds = $frame_mdl_b->Scrolled(
        'Text',
        -width      => 60,
        -height     => 3,
        -wrap       => 'word',
        -scrollbars => 'e',
        -font       => $my_font
    );

    $tadresa_ds->form(
        -top  => [ '&', $ladresa_ds, 0 ],
        -left => [ %0,  $f1d ],
        -padbottom => 5,
    );

    #- Frame bottom

    my $frame_btm_b = $rec_page->LabFrame(
        -foreground => 'blue',
        -label      => 'Contact',
        -labelside  => 'acrosstop'
    )->pack(
        -expand => 0,
        -fill   => 'x'
    );

    #-- tel - Telefon

    my $ltel = $frame_btm_b->Label( -text => 'Telefon' );
    $ltel->form(
        -top       => [ %0, 0 ],
        -left      => [ %0, 0 ],
        -padleft   => 5,
        -padbottom => 8,
    );

    my $etel = $frame_btm_b->MEntry(
        -width    => 30,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'tel', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $etel->form(
        -top  => [ '&', $ltel, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ email

    my $eemail = $frame_btm_b->MEntry(
        -width    => 30,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'email', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eemail->form(
        -top   => [ '&',  $ltel, 0 ],
        -right => [ %100, -5 ],
    );

    my $lemail = $frame_btm_b->Label( -text => 'E-mail', );
    $lemail->form(
        -top     => [ '&',     $ltel, 0 ],
        -right   => [ $eemail, -10 ],
        -padleft => 5,
    );
    $eemail->bind( '<KeyPress-Return>' => sub { $self->email_ok(); } );

    # Entry objects: var_asoc, var_obiect
    # Other configurations in 'persoane.conf'
    $self->{controls} = {
        id_pers       => [ undef,        $eid_pers ],
        cnp           => [ undef,        $ecnp ],
        nume          => [ undef,        $enume ],
        prenume       => [ undef,        $eprenume ],
        prenume_p     => [ undef,        $eprenume_p ],
        data_nast     => [ \$vdata_nast, $ddata_nast ],
        email         => [ undef,        $eemail ],
        loc_ds        => [ undef,        $eloc_ds ],
        codp_ds       => [ undef,        $ecodp_ds ],
        jud_ds        => [ undef,        $ejud_ds ],
        siruta_ds     => [ undef,        $esiruta_ds ],
        tara_ds       => [ undef,        $etara_ds ],
        tara_cod_ds   => [ undef,        $etara_cod_ds ],
        loc_strain_ds => [ undef,        $eloc_strain_ds ],
        adresa_ds     => [ undef,        $tadresa_ds ],
        nation        => [ undef,        $enation ],
        gen           => [ \$vgen,       $rgen ],
        tel           => [ undef,        $etel ],
    };

    # Required fields: fld_name => [#, Label] If there are no values
    # in the screen for this fields show a dialog message
    $self->{rq_controls} = {
        nume      => [ 0, '  Nume' ],
        prenume   => [ 1, '  Prenume' ],
        cnp       => [ 2, '  Codul numeric personal' ],
        siruta_ds => [ 3, '  Localitate, judet' ],
        adresa_ds => [ 4, '  Adresa de domiciliu' ],
    };

    # $self->{msg_strings} = {
    #     prepare             => 'Neconectat la server',
    #     pk_persoane_id_pers => 'ID duplicat',
    #     uq_persoane_cnp     => 'CNP duplicat!',
    #     nume                => 'Nume?',
    #     prenume             => 'Prenume?',
    # };

    return;
}

sub cnp_ok {
    my ($self, $date_format) = @_;

    $self->{view}->set_status( '', 'ms'); # sterge mesajele anterioare

    my $cnp = $self->{controls}{cnp}[1]->get; # valoare CNP

    return unless ($cnp);

    # Trim spaces to be safe
    $cnp =~ s/^\s+//;
    $cnp =~ s/\s+$//;

    if ( length($cnp) != 13 ) {
        $self->{view}->set_status( 'CNP eronat (lungime)', 'ms', 'red');
        return;
    }

    my @cnp = split( //, $cnp );
    my @prd = split( //, '279146358279' );

    # Check first digit
    if ( $cnp[0] < 1 or $cnp[0] > 6 and $cnp[0] != 9 ) {
        $self->{view}->set_status( 'CNP eronata (prima cifra)', 'ms', 'red');
        return;
    }
    else {
        # Preset gen
        my $gen;
        $gen = 'Masculin' if $cnp[0] == 1;
        $gen = 'Feminin'  if $cnp[0] == 2;
        ${ $self->{controls}{gen}[0] } = $gen;
    }

    # Check date
    my $yy    = substr($cnp,1,2);
    my $month = substr($cnp,3,2);
    my $day   = substr($cnp,5,2);

    my $year = "19$yy";                # TODO: algorithm to guess year

    if ( check_date($year,$month,$day) ) {
        my $date = Tpda3::Utils->dateentry_format_date(
            $date_format, $year, $month, $day);

        # Preset date
        $self->{controls}{data_nast}[1]->delete( 0, 'end' );
        $self->{controls}{data_nast}[1]->insert(0, $date);
    }
    else {
        $self->{view}->set_status( 'CNP eronat! (data)', 'ms', 'red');
        return;
    }

    my $suma = 0;
    foreach ( 0 .. $#prd ) {
        $suma += $cnp[$_] * $prd[$_];
    }

    # print "Suma     = $suma\n";
    my $m11 = $suma % 11;

    # print "Modulo11 = $m11\n";
    # print "CNP(13)  = $cnp[12]\n";

    my $cc;
    if ( $m11 < 10 ) {
        $cc = $m11;
    }
    else {
        if ( $m11 == 10 ) {
            $cc = 1;
        }
        else {
            $cc = -1;                        # imposible?
        }
    }

    # Final chech
    if ( $cnp[12] == $cc ) {
        $self->{view}->set_status( 'CNP valid', 'ms', 'darkgreen');
    }
    else {
        $self->{view}->set_status( 'CNP eronat', 'ms', 'red');
    }

    return;
}

sub email_ok {
    my $self = shift;

    if ( eval { require Email::Valid } ) {
        my $email = $self->{controls}{email}[1]->get; #  E-mail
        my ($msg, $color) = ('Format adresa e-mail ', 'darkgreen');
        if ( Email::Valid->address($email) ) {
            $msg  .= 'valid';
        }
        else {
            $msg  .= 'invalid';
            $color = 'red';
        }
        print "$msg\n";
        $self->{view}->set_status($msg, 'ms', $color );
    }
    else {
        print "Validare E-mail indisponibila.\n";
    }

    return;
}

=head1 AUTHOR

Stefan Suciu, C<< <stefansbv at user.sourceforge.net> >>

=head1 BUGS

None known.

Please report any bugs or feature requests to the author.

=head1 LICENSE AND COPYRIGHT

Copyright 2010-2011 Stefan Suciu.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation.

=cut

1; # End of Tpda3::Tk::App::Notar::Persoane
