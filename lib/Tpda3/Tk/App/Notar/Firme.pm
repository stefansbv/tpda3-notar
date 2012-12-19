package Tpda3::Tk::App::Notar::Firme;

use strict;
use warnings;
use utf8;

use Tk::widgets qw(); # DateEntry JComboBox

use base q{Tpda3::Tk::Screen};

use POSIX qw (strftime);

use Tpda3::Utils;

=head1 NAME

Tpda3::Tk::App::Notar::Firme screen.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    require Tpda3::App::Notar::Firme;

    my $scr = Tpda3::App::Notar::Firme->new;

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

    #-  Frame TOP

    my $top = $rec_page->Frame()->pack(
        -side   => 'top',
        -fill   => 'both',
        -expand => 0,
    );

    #-- LabFrame top - left

    my $frm_tl = $top->LabFrame(
        -foreground => 'blue',
        -label      => 'Identificare',
        -labelside  => 'acrosstop'
        )->pack(
        -side   => 'left',
        -expand => 0,
        -fill   => 'both',
        );

    my $f1d = 90;              # distance from left

    #- denumire (denumire)

    my $ldenumire = $frm_tl->Label( -text => 'Denumire', );
    $ldenumire->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );

    my $edenumire = $frm_tl->MEntry(
        -width              => 40,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate           => 'key',
        -vcmd               => sub {
            $validation->validate_entry( 'denumire', @_ );
        },
    );
    $edenumire->form(
        -top      => [ '&', $ldenumire, 0 ],
        -left     => [ %0,  $f1d ],
        -padright => 5,
    );

    #- id_firma (id_firma)

    my $lid_firma = $frm_tl->Label( -text => 'Id. firmă', );
    $lid_firma->form(
        -top     => [ $ldenumire, 8 ],
        -left    => [ %0,         0 ],
        -padleft => 5,
    );

    my $eid_firma = $frm_tl->MEntry(
        -width              => 10,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eid_firma->form(
        -top  => [ '&', $lid_firma, 0 ],
        -left => [ %0,  $f1d ],
    );

    #-+ nr_reg_com

    my $enr_reg_com = $frm_tl->MEntry(
        -width    => 10,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'nr_reg_com', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $enr_reg_com->form(
        -top   => [ '&', $lid_firma, 0 ],
        -right => [ '&', $edenumire, -5 ],
    );

    my $lnr_reg_com = $frm_tl->Label( -text => 'Nr. reg. com.', );
    $lnr_reg_com->form(
        -top     => [ '&',          $lid_firma, 0 ],
        -right   => [ $enr_reg_com, -10 ],
        -padleft => 5,
    );

    #-- cui (cui)

    my $lcui = $frm_tl->Label(
        -text => 'CUI',
    );
    $lcui->form(
        -top  => [ $lnr_reg_com, 8 ],
        -left => [ %0, 0 ],
        -padleft => 5,
    );

    my $ecui = $frm_tl->MEntry(
        -width              => 15,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate           => 'key',
        -vcmd               => sub {
            $validation->validate_entry( 'cui', @_ );
        },
    );
    $ecui->form(
        -top       => [ '&', $lcui, 0 ],
        -left      => [ %0,  $f1d ],
        -padbottom => 5,
    );

    #-- LabFrame top - right

    my $frm_tr = $top->LabFrame(
        -foreground => 'blue',
        -label      => 'Adresa',
        -labelside  => 'acrosstop',
        )->pack(
        -side   => 'left',
        -expand => 1,
        -fill   => 'both',
        );

    #- adresa (adresa)

    my $my_font = $eid_firma->cget('-font');    # font

    my $tadresa = $frm_tr->Scrolled(
        'Text',
        -width      => 40,
        -height     => 3,
        -wrap       => 'word',
        -scrollbars => 'e',
        -font       => $my_font,
    )->pack(
        -expand => 1,
        -fill   => 'both',
        -padx   => 5,
        -pady   => 5,
    );

    #-  Frame MIDDLE

    my $middle = $rec_page->Frame()->pack(
        -side   => 'top',
        -fill   => 'both',
        -expand => 0,
    );

    #- LabFrame - middle left (adresa)

    my $frm_ml = $middle->LabFrame(
        -foreground => 'blue',
        -label      => 'Localizare',
        -labelside  => 'acrosstop',
    )->pack(
        -side   => 'left',
        -expand => 0,
        -fill   => 'both',
    );

    #-- localitate

    my $llocalitate = $frm_ml->Label( -text => 'Localitate' );
    $llocalitate->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5
    );

    my $elocalitate = $frm_ml->MEntry(
        -width              => 32,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $elocalitate->form(
        -top  => [ '&', $llocalitate, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ siruta

    my $esiruta = $frm_ml->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $esiruta->form(
        -top       => [ '&',          $llocalitate, 0 ],
        -left      => [ $elocalitate, 6 ],
        -padright  => 6,
        -padbottom => 5,
    );

    #-- codjud

    my $ljudet = $frm_ml->Label(
        -text => 'Județ',
    );
    $ljudet->form(
        -top  => [ $llocalitate, 8 ],
        -left => [ %0, 0 ],
        -padleft => 5,
    );

    my $ejudet = $frm_ml->MEntry(
        -width              => 13,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ejudet->form(
        -top  => [ '&', $ljudet, 0 ],
        -left => [ %0, 90 ],
        -padbottom => 7,
    );

    #-+ codjud

    my $ecodjud = $frm_ml->MEntry(
        -width              => 3,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ecodjud->form(
        -top  => [ '&', $ljudet, 0 ],
        -left => [ $ejudet, 5 ],
    );

    #-- codp

    my $ecodp = $frm_ml->MEntry(
        -width    => 6,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'codp', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ecodp->form(
        -top   => [ '&', $ljudet,  0 ],
        -right => [ '&', $esiruta, -6 ],
    );

    my $lcodp = $frm_ml->Label( -text => 'Cod poștal', );
    $lcodp->form(
        -top     => [ '&',     $ljudet, 0 ],
        -right   => [ $ecodp, -12 ],
        -padleft => 5,
    );

    #-- LabFrame - middle right

    my $frm_mr = $middle->LabFrame(
        -foreground => 'blue',
        -label      => 'Reprezentant',
        -labelside  => 'acrosstop'
    )->pack(
        -side => 'left',
        -expand => 1,
        -fill   => 'x',
    );

    #- reprez_nume (reprez_nume)

    my $lreprez_nume = $frm_mr->Label( -text => 'Nume', );
    $lreprez_nume->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );

    my $ereprez_nume = $frm_mr->MEntry(
        -width              => 38,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate           => 'key',
        -vcmd               => sub {
            $validation->validate_entry( 'reprez_nume', @_ );
        },
    );
    $ereprez_nume->form(
        -top       => [ '&', $lreprez_nume, 0 ],
        -left      => [ %0,  $f1d ],
        -padright  => 5,
        -padbottom => 7,
    );

    #- reprez_func (reprez_func)

    my $lreprez_func = $frm_mr->Label( -text => 'Funcție', );
    $lreprez_func->form(
        -top     => [ $lreprez_nume, 8 ],
        -left    => [ %0,            0 ],
        -padleft => 5,
    );

    my $ereprez_func = $frm_mr->MEntry(
        -width              => 15,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate           => 'key',
        -vcmd               => sub {
            $validation->validate_entry( 'reprez_func', @_ );
        },
    );
    $ereprez_func->form(
        -top       => [ '&', $lreprez_func, 0 ],
        -left      => [ %0,  $f1d ],
        -padbottom => 7,
    );

    #-+ reprez_titl

    my $ereprez_titl = $frm_mr->MEntry(
        -width    => 15,
        -validate => 'key',
        -vcmd     => sub {
            $validation->validate_entry( 'reprez_titl', @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ereprez_titl->form(
        -top   => [ '&', $ereprez_func, 0 ],
        -right => [ '&', $ereprez_nume, -5 ],
    );

    my $lreprez_titl = $frm_mr->Label( -text => 'Titlu', );
    $lreprez_titl->form(
        -top     => [ '&',           $lreprez_func, 0 ],
        -right   => [ $ereprez_titl, -10 ],
        -padleft => 5,
    );

    #-  Frame BOTTOM

    my $bottom = $rec_page->Frame()->pack(
        -fill   => 'x',
        -expand => 0,
    );

    #-- LabFrame - bottom left

    my $frm_bl = $bottom->LabFrame(
        -foreground => 'blue',
        -label      => 'Contact',
        -labelside  => 'acrosstop',
    )->pack(
        -side => 'left',
        -expand => 0,
        -fill   => 'both',
    );

    #- tel (tel)

    my $ltel = $frm_bl->Label(
        -text => 'Telefon',
    );
    $ltel->form(
        -top      => [ %0, 0 ],
        -left     => [ %0, 0 ],
        -padleft  => 5,
    );

    my $etel = $frm_bl->MEntry(
        -width              => 40,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate           => 'key',
        -vcmd               => sub {
            $validation->validate_entry( 'tel', @_ );
        },
    );
    $etel->form(
        -top      => [ '&', $ltel, 0 ],
        -left     => [ %0,  $f1d ],
        -padright => 5,
    );

    #- fax (fax)

    my $lfax = $frm_bl->Label( -text => 'Fax', );
    $lfax->form(
        -top     => [ $ltel, 8 ],
        -left    => [ %0,    0 ],
        -padleft => 5,
    );

    my $efax = $frm_bl->MEntry(
        -width              => 40,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate           => 'key',
        -vcmd               => sub {
            $validation->validate_entry( 'fax', @_ );
        },
    );
    $efax->form(
        -top      => [ '&', $lfax, 0 ],
        -left     => [ %0,  $f1d ],
    );

    #- e_mail (e_mail)

    my $le_mail = $frm_bl->Label( -text => 'E-mail', );
    $le_mail->form(
        -top     => [ $lfax, 8 ],
        -left    => [ %0,    0 ],
        -padleft => 5,
    );

    my $ee_mail = $frm_bl->MEntry(
        -width              => 40,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -validate           => 'key',
        -vcmd               => sub {
            $validation->validate_entry( 'e_mail', @_ );
        },
    );
    $ee_mail->form(
        -top       => [ '&', $le_mail, 0 ],
        -left      => [ %0,  $f1d ],
        -padbottom => 5,
    );

    #- LabFrame - bottom right

    $f1d += 15;

    my $frm_br = $bottom->LabFrame(
        -foreground => 'blue',
        -label      => 'Observații',
        -labelside  => 'acrosstop',
        )->pack(
        -side   => 'left',
        -expand => 1,
        -fill   => 'x',
        );

    #-- obs

    my $tobs = $frm_br->Scrolled(
        'Text',
        -width      => 40,
        -height     => 4,
        -wrap       => 'word',
        -scrollbars => 'e',
        -background => 'white',
    );
    $tobs->pack(
        -expand => 1,
        -fill   => 'both',
        -padx   => 5,
        -pady   => 6,
    );

    # Entry objects: var_asoc, var_obiect
    # Other configurations in '.conf'
    $self->{controls} = {
        id_firma    => [ undef, $eid_firma ],
        denumire    => [ undef, $edenumire ],
        cui         => [ undef, $ecui ],
        nr_reg_com  => [ undef, $enr_reg_com ],
        localitate  => [ undef, $elocalitate ],
        siruta      => [ undef, $esiruta ],
        judet       => [ undef, $ejudet ],
        codjud      => [ undef, $ecodjud ],
        codp        => [ undef, $ecodp ],
        adresa      => [ undef, $tadresa ],
        reprez_func => [ undef, $ereprez_func ],
        reprez_titl => [ undef, $ereprez_titl ],
        reprez_nume => [ undef, $ereprez_nume ],
        tel         => [ undef, $etel ],
        fax         => [ undef, $efax ],
        e_mail      => [ undef, $ee_mail ],
        obs         => [ undef, $tobs ],
    };

    # Required fields: fld_name => [#, Label]
    $self->{rq_controls} = {
        denumire    => [ 0, '  Denumire' ],
        siruta      => [ 1, '  Localitate, judet' ],
        cui         => [ 2, '  CUI firma' ],
        nr_reg_com  => [ 3, '  Nr. reg. com.' ],
        reprez_func => [ 4, '  Functie reprezentant' ],
        reprez_titl => [ 5, '  Titlu reprezentant' ],
        reprez_nume => [ 6, '  Nume reprezentant' ],
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

1; # End of Tpda3::App::Notar::Firme
