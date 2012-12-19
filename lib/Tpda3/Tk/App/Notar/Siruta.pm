package Tpda3::Tk::App::Notar::Siruta;

use strict;
use warnings;
use utf8;

use base q{Tpda3::Tk::Screen};

=head1 NAME

Tpda3::App::Notar::Siruta screen.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

    require Tpda3::App::Notar::Siruta;

    my $scr = Tpda3::App::Notar::Siruta->new;

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

    #- Frame1

    my $frame1 = $rec_page->LabFrame(
        -foreground => 'blue',
        -label      => 'Localitate',
        -labelside  => 'acrosstop'
    );
    $frame1->grid(
        $frame1,
        -row    => 0,
        -column => 0,
        -ipadx  => 3,
        -ipady  => 3,
        -sticky => 'nsew',
    );

    my $f1d = 90;                            # distance from left

    #-- siruta

    my $lsiruta = $frame1->Label(
        -text => 'SIRUTA',
    );
    $lsiruta->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );

    my $esiruta = $frame1->Entry(
        -width              => 10,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $esiruta->form(
        -top  => [ '&', $lsiruta, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ sirsup

    my $esirsup = $frame1->Entry(
        -width => 7,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $esirsup->form(
        -top   => [ '&', $lsiruta, 0 ],
        -right => [ %100, -5 ],
    );

    my $lsirsup = $frame1->Label(
        -text => 'Superior',
    );
    $lsirsup->form(
        -top     => [ '&',      $lsiruta, 0 ],
        -right   => [ $esirsup, -10 ],
        -padleft => 5,
    );

    #-- Localitate (localitate)

    my $llocalitate = $frame1->Label(
        -text => 'Localitate',
    );
    $llocalitate->form(
        -top     => [ $lsiruta, 8 ],
        -left    => [ %0,       0 ],
        -padleft => 5,
    );

    my $elocalitate = $frame1->Entry(
        -width => 39,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $elocalitate->form(
        -top  => [ '&', $llocalitate, 0 ],
        -left => [ %0, $f1d ],
    );

    #-- Judet (judet)

    my $ljudet = $frame1->Label(
        -text => 'Judet',
    );
    $ljudet->form(
        -left    => [ %0,           0 ],
        -top     => [ $llocalitate, 8 ],
        -padleft => 5,
    );

    my $ejudet = $frame1->Entry(
        -width              => 34,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $ejudet->form(
        -top  => [ '&', $ljudet, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ jud (SMALLINT)

    my $ejud = $frame1->Entry(
        -width   => 3,
        -justify => 'right',
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $ejud->form(
        -top   => [ '&', $ljudet,      0 ],
        -right => [ '&', $elocalitate, 0 ],
    );

    #-- superior

    my $lsuperior = $frame1->Label(
        -text => 'Superior',
    );
    $lsuperior->form(
        -top     => [ $ljudet, 8 ],
        -left    => [ %0,      0 ],
        -padleft => 5,
    );
    my $esuperior = $frame1->Entry(
        -width => 39,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $esuperior->form(
        -top  => [ '&', $lsuperior, 0 ],
        -left => [ %0, 90 ],
    );

    #-- codp

    my $lcodp = $frame1->Label(
        -text => 'Cod postal',
    );
    $lcodp->form(
        -top     => [ $lsuperior, 8 ],
        -left    => [ %0,         0 ],
        -padleft => 5,
    );
    my $ecodp = $frame1->Entry(
        -width => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $ecodp->form(
        -top  => [ '&', $lcodp, 0 ],
        -left => [ %0, 90 ],
    );

    #-+ med

    my $emed = $frame1->Entry(
        -width   => 3,
        -justify => 'right',
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $emed->form(
        -top   => [ '&', $lcodp, 0 ],
        -right => [ %100, -5 ],
    );
    my $lmed = $frame1->Label(
        -text => 'Mediu',
    );
    $lmed->form(
        -top   => [ '&', $lcodp, 0 ],
        -right => [ $emed, -10 ],
        -padleft => 5,
    );

    #-- tip

    my $ltip = $frame1->Label(
        -text => 'Tip',
    );
    $ltip->form(
        -top     => [ $lcodp, 8 ],
        -left    => [ %0,     0 ],
        -padleft => 5,
    );
    my $etip = $frame1->Entry(
        -width   => 3,
        -justify => 'right',
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $etip->form(
        -top  => [ '&', $ltip, 0 ],
        -left => [ %0, 90 ],
    );

    #-+ mnemonic

    my $lmnemonic = $frame1->Label(
        -text => 'Mnemonic',
    );
    $lmnemonic->form(
        -top     => [ '&',   $ltip, 0 ],
        -left    => [ $etip, 17 ],
        -padleft => 5,
    );
    my $emnemonic = $frame1->Entry(
        -width   => 3,
        -justify => 'right',
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $emnemonic->form(
        -top  => [ '&', $lmnemonic, 0 ],
        -left => [ $lmnemonic, 10 ],
    );

    #-+ regiune

    my $eregiune = $frame1->Entry(
        -width   => 3,
        -justify => 'right',
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $eregiune->form(
        -top   => [ '&', $ltip, 0 ],
        -right => [ '&', $ejud,     0 ],
    );

    my $lregiune = $frame1->Label(
        -text => 'Regiune',
    );
    $lregiune->form(
        -top     => [ '&',        $ltip, 0 ],
        -right   => [ $eregiune, -10 ],
        -padleft => 5,
    );

    # Entry objects: var_asoc, var_obiect
    # Other configurations in 'sirsup.conf'
    $self->{controls} = {
        siruta     => [ undef, $esiruta ],
        tip        => [ undef, $etip ],
        sirsup     => [ undef, $esirsup ],
        superior   => [ undef, $esuperior ],
        localitate => [ undef, $elocalitate ],
        judet      => [ undef, $ejudet ],
        jud        => [ undef, $ejud ],
        mnemonic   => [ undef, $emnemonic ],
        regiune    => [ undef, $eregiune ],
        codp       => [ undef, $ecodp ],
        med        => [ undef, $emed ],
    };

    # Required fields: fld_name => [#, Label]
    # If there is no value in the screen for this fields show a dialog message
    $self->{req_controls} = {
        siruta     => [ 0, '  Cod SIRUTA' ],
        localitate => [ 1, '  Localitate' ],
        jud        => [ 2, '  Cod Judet ' ],
    };

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

1; # End of Tpda3::Tk::App::Notar::Siruta
