package Tpda3::Tk::App::Notar::Contracte;

use strict;
use warnings;
use utf8;

use Tk::widgets qw(DateEntry JComboBox RadiobuttonGroup);

use base q{Tpda3::Tk::Screen};

use POSIX qw (strftime);

=head1 NAME

Tpda3::App::Notar::Contracte screen

=head1 VERSION

Version 0.01

=cut

our $VERSION = 0.01;

=head1 SYNOPSIS

    require Tpda3::App::Notar::Contracte;

    my $scr = Tpda3::App::Notar::Contracte->new;

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

    my $f1d = 130;    # distance from left

    # For day names
    my @daynames = ();
    foreach ( 0 .. 6 ) {
        push @daynames, strftime( "%a", 0, 0, 0, 1, 1, 1, $_ );
    }

    #- Frame - Top

    my $frm_top = $rec_page->Frame(
    )->pack(
        -expand => 0,
        -fill   => 'x',
    );

    #- Frame - Top Left

    my $frm_top_left = $frm_top->LabFrame(
        -foreground => 'blue',
        -label      => 'Contract',
        -labelside  => 'acrosstop'
    );
    $frm_top_left->pack(
        -side => 'left',
        -expand => 1,
        -fill   => 'x',
    );

    #-- id_contr

    my $lid_contr = $frm_top_left->Label( -text => 'Identificator', );
    $lid_contr->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );

    my $eid_contr = $frm_top_left->MEntry(
        -width              => 10,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eid_contr->form(
        -top  => [ '&', $lid_contr, 0 ],
        -left => [ %0,  $f1d ],
    );

    # Font
    my $my_font = $eid_contr->cget('-font');

    #-+ data_contr

    my $vdata_contr;
    my $ddata_contr = $frm_top_left->DateEntry(
        -daynames        => \@daynames,
        -variable        => \$vdata_contr,
        -arrowimage      => 'calmonth16',
        -todaybackground => 'lightgreen',
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
    $ddata_contr->form(
        -top   => [ '&',  $lid_contr, 0 ],
        -right => [ %100, -5 ],
    );

    my $ldata_contr = $frm_top_left->Label( -text => 'Dată contract', );
    $ldata_contr->form(
        -top     => [ '&', $lid_contr, 0 ],
        -right   => [ $ddata_contr, -10 ],
        -padleft => 5,
    );

    #-- pret_ob

    my $lpret_ob = $frm_top_left->Label( -text => 'Preț contract', );
    $lpret_ob->form(
        -top  => [ $ldata_contr, 8 ],
        -left => [ %0, 0 ],
        -padleft => 5,
    );
    my $epret_ob = $frm_top_left->MEntry(
        -width              => 13,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -justify            => 'right',
    );
    $epret_ob->form(
        -top  => [ '&', $lpret_ob, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ mod_plata_ob

    my $lmod_plata_ob = $frm_top_left->Label( -text => 'Mod plată', );
    $lmod_plata_ob->form(
        -top  => [ '&', $lpret_ob, 0 ],
        -left => [ $epret_ob, 20 ],
    );

    my $emod_plata_ob = $frm_top_left->MEntry(
        -width              => 40,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $emod_plata_ob->form(
        -top      => [ '&', $lmod_plata_ob, 0 ],
        -left     => [ $epret_ob, 120 ],
        -padright => 5,
    );

    #-- data_predare

    my $vdata_predare;
    my $ldata_predare = $frm_top_left->Label( -text => 'Dată predare' );
    $ldata_predare->form(
        -top     => [ $lpret_ob, 8 ],
        -left    => [ %0,           0 ],
        -padleft => 5,
    );
    my $ddata_predare = $frm_top_left->DateEntry(
        -daynames   => \@daynames,
        -variable   => \$vdata_predare,
        -arrowimage => 'calmonth16',
        -weekstart       => 1,
        -todaybackground => 'lightgreen',
        -parsecmd   => sub {
            Tpda3::Utils->dateentry_parse_date( $date_format, @_ );
        },
        -formatcmd => sub {
            Tpda3::Utils->dateentry_format_date( $date_format, @_ );
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ddata_predare->form(
        -top       => [ '&', $ldata_predare, 0 ],
        -left      => [ %0,  $f1d ],
        -padbottom => 5,
    );

    #-+ loc_predare_ob

    my $lloc_predare_ob = $frm_top_left->Label( -text => 'Loc predare', );
    $lloc_predare_ob->form(
        -top  => [ '&', $ldata_predare, 0 ],
        -left => [ $ddata_predare, 20 ],
    );
    my $eloc_predare_ob = $frm_top_left->MEntry(
        -width              => 40,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eloc_predare_ob->form(
        -top  => [ '&', $lloc_predare_ob, 0 ],
        -left => [ $ddata_predare, 120 ],
    );

    #- Frame - Top Right

    my $frm_top_right = $frm_top->LabFrame(
        -foreground => 'blue',
        -label      => 'Observații',
        -labelside  => 'acrosstop'
    );
    $frm_top_right->pack(
        -side => 'right',
        -expand => 1,
        -fill   => 'both',
    );

    #- mentiuni (mentiuni)

    my $tmentiuni = $frm_top_right->Scrolled(
        'Text',
        -width      => 61,
        -height     => 4,
        -wrap       => 'word',
        -scrollbars => 'e',
        -font       => $my_font,
    )->pack(
        -expand => 1,
        -fill   => 'both',
        -padx   => 5,
        -pady   => 5,
    );

    #- Frame - Middle

    my $frm_md = $rec_page->Frame(
    )->pack(
        -expand => 0,
        -fill   => 'x',
    );

    #- Frame - Middle Left

    my $frm_md_left = $frm_md->LabFrame(
        -foreground => 'blue',
        -label      => 'Între',
        -labelside  => 'acrosstop'
    );
    $frm_md_left->pack(
        -side => 'left',
        -expand => 1,
        -fill   => 'x',
    );

    #-- Tip1

    my $ltip1 = $frm_md_left->Label( -text => 'Tip' );
    $ltip1->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5
    );

    my $tipuri = [ qw{Persoană Firmă} ];
    my $vtip1;
    my $rtip1 = $frm_md_left->RadiobuttonGroup(
        -list        => $tipuri,
        -orientation => 'horizontal',
        -variable    => \$vtip1,
        -command     => sub { $self->toggle_tip1($vtip1) },
    );
    $rtip1->form(
        -top  => [ '&', $ltip1, 0 ],
        -left => [ %0, $f1d ],
    );

    #-- numepren1

    my $lnumepren1 = $frm_md_left->Label( -text => 'Nume si prenume' );
    $lnumepren1->form(
        -top     => [ $ltip1, 8 ],
        -left    => [ %0,     0 ],
        -padleft => 5
    );

    my $enumepren1 = $frm_md_left->MEntry(
        -width              => 20,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $enumepren1->form(
        -top  => [ '&', $lnumepren1, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ id_pers1

    my $eid_pers1 = $frm_md_left->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $eid_pers1->form(
        -top       => [ '&', $lnumepren1, 0 ],
        -left      => [ $enumepren1, 5 ],
        -padbottom => 5,
    );

    #-+ cnp1

    my $lcnp1 = $frm_md_left->Label( -text => 'CNP', );
    $lcnp1->form(
        -top  => [ '&', $lnumepren1, 0 ],
        -left => [ $eid_pers1, 20 ],
    );

    my $ecnp1 = $frm_md_left->MEntry(
        -width => 13,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ecnp1->form(
        -top      => [ '&',        $lcnp1, 0 ],
        -left     => [ $eid_pers1, 60 ],
        -padright => 5,
    );

    #-- denumire1

    my $ldenumire1 = $frm_md_left->Label( -text => 'Denumire', );
    $ldenumire1->form(
        -top     => [ $lcnp1, 8 ],
        -left    => [ %0,     0 ],
        -padleft => 5,
    );

    my $edenumire1 = $frm_md_left->MEntry(
        -width              => 20,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $edenumire1->form(
        -top       => [ '&', $ldenumire1, 0 ],
        -left      => [ %0,  $f1d ],
        -padbottom => 5,
    );

    #-+ id_firma1

    my $eid_firma1 = $frm_md_left->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eid_firma1->form(
        -top  => [ '&', $ldenumire1, 0 ],
        -left => [ $edenumire1, 5 ],
    );

    #-+ cui1

    my $lcui1 = $frm_md_left->Label( -text => 'CUI', );
    $lcui1->form(
        -top  => [ '&', $ldenumire1, 0 ],
        -left => [ $eid_firma1, 20 ],
    );

    my $ecui1 = $frm_md_left->MEntry(
        -width => 13,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ecui1->form(
        -top  => [ '&', $lcui1, 0 ],
        -left => [ $eid_firma1, 60 ],
    );

    #- Frame - Middle Right

    my $frm_md_right = $frm_md->LabFrame(
        -foreground => 'blue',
        -label      => 'și între',
        -labelside  => 'acrosstop'
    );
    $frm_md_right->pack(
        -side => 'right',
        -expand => 1,
        -fill   => 'x',
    );

    #-- Tip2

    my $ltip2 = $frm_md_right->Label( -text => 'Tip' );
    $ltip2->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5
    );

    my $vtip2;
    my $rtip2 = $frm_md_right->RadiobuttonGroup(
        -list        => $tipuri,
        -orientation => 'horizontal',
        -variable    => \$vtip2,
        -command     => sub { $self->toggle_tip2($vtip2) },
    );
    $rtip2->form(
        -top  => [ '&', $ltip2, 0 ],
        -left => [ %0,  $f1d ],
    );

    #-- numepren2

    my $lnumepren2 = $frm_md_right->Label( -text => 'Nume si prenume' );
    $lnumepren2->form(
        -top     => [ $ltip2, 8 ],
        -left    => [ %0,     0 ],
        -padleft => 5
    );

    my $enumepren2 = $frm_md_right->MEntry(
        -width              => 20,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $enumepren2->form(
        -top  => [ '&', $lnumepren2, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ id_pers2

    my $eid_pers2 = $frm_md_right->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $eid_pers2->form(
        -top       => [ '&', $lnumepren2, 0 ],
        -left      => [ $enumepren2, 5 ],
        -padbottom => 5,
    );

    #-+ cnp2

    my $lcnp2 = $frm_md_right->Label( -text => 'CNP', );
    $lcnp2->form(
        -top  => [ '&', $lnumepren2, 0 ],
        -left => [ $eid_pers2, 20 ],
    );

    my $ecnp2 = $frm_md_right->MEntry(
        -width => 13,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ecnp2->form(
        -top      => [ '&',        $lcnp2, 0 ],
        -left     => [ $eid_pers2, 60 ],
        -padright => 5,
    );

    #-- denumire2

    my $ldenumire2 = $frm_md_right->Label( -text => 'Denumire', );
    $ldenumire2->form(
        -top     => [ $lcnp2, 8 ],
        -left    => [ %0,     0 ],
        -padleft => 5,
    );

    my $edenumire2 = $frm_md_right->MEntry(
        -width              => 20,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $edenumire2->form(
        -top       => [ '&', $ldenumire2, 0 ],
        -left      => [ %0,  $f1d ],
        -padbottom => 5,
    );

    #-+ id_firma2

    my $eid_firma2 = $frm_md_right->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eid_firma2->form(
        -top  => [ '&', $ldenumire2, 0 ],
        -left => [ $edenumire2, 5 ],
    );

    #-+ cui2

    my $lcui2 = $frm_md_right->Label( -text => 'CUI', );
    $lcui2->form(
        -top  => [ '&', $ldenumire2, 0 ],
        -left => [ $eid_firma2, 20 ],
    );

    my $ecui2 = $frm_md_right->MEntry(
        -width              => 13,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ecui2->form(
        -top  => [ '&', $lcui2, 0 ],
        -left => [ $eid_firma2, 60 ],
    );

    #- Frame - Bottom

    my $frm_bot = $rec_page->Frame(
    )->pack(
        -expand => 0,
        -fill   => 'x',
    );

    #- Frame - Bottom Left

    my $frm_bot_left = $frm_bot->LabFrame(
        -foreground => 'blue',
        -label      => 'Obiectul contractului',
        -labelside  => 'acrosstop'
    )->pack(
        -side => 'left',
        -expand => 1,
        -fill   => 'x',
    );

    #-- tip_ob

    my $vtip_ob;
    my $ltip_ob = $frm_bot_left->Label( -text => 'Tip obiect', );
    $ltip_ob->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );
    my $mtip_ob = $frm_bot_left->JComboBox(
        -entrywidth         => 20,
        -textvariable       => \$vtip_ob,
        -disabledforeground => 'black'
    );
    $mtip_ob->form(
        -top     => [ '&', $ltip_ob, 0 ],
        -left    => [ %0,  $f1d ],
        -padleft => 1,
    );

    #-- Localitate

    my $lloc_ob = $frm_bot_left->Label( -text => 'Localitate' );
    $lloc_ob->form(
        -top     => [ $ltip_ob, 8 ],
        -left    => [ %0, 0 ],
        -padleft => 5
    );

    my $eloc_ob = $frm_bot_left->MEntry(
        -width              => 29,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eloc_ob->form(
        -top  => [ '&', $lloc_ob, 0 ],
        -left => [ %0, $f1d ],
    );

    #-+ Judet

    my $ejud_ob = $frm_bot_left->MEntry(
        -width              => 3,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ejud_ob->form(
        -top  => [ '&',      $lloc_ob, 0 ],
        -left => [ $eloc_ob, 6 ]
    );

    #-+ codp_ob (Cod loc_ob)

    my $ecodp_ob = $frm_bot_left->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $ecodp_ob->form(
        -top  => [ '&', $lloc_ob, 0 ],
        -left => [ $ejud_ob, 5 ]
    );

    #-+ siruta_ob

    my $esiruta_ob = $frm_bot_left->MEntry(
        -width              => 6,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $esiruta_ob->form(
        -top  => [ '&', $lloc_ob, 0 ],
        -left => [ $ecodp_ob, 5 ],
    );

    #-- Adresa (adresa_ob)

    my $ladresa_ob = $frm_bot_left->Label( -text => 'Adresă' );
    $ladresa_ob->form(
        -top     => [ $lloc_ob, 9 ],
        -left    => [ %0,    0 ],
        -padleft => 5
    );

    my $tadresa_ob = $frm_bot_left->Scrolled(
        'Text',
        -width      => 46,
        -height     => 3,
        -wrap       => 'word',
        -scrollbars => 'e',
        -font       => $my_font
    );

    $tadresa_ob->form(
        -top      => [ '&', $ladresa_ob, 0 ],
        -left     => [ %0,  $f1d ],
    );

    #-- comp_ob

    my $lcomp_ob = $frm_bot_left->Label( -text => 'Compunere', );
    $lcomp_ob->form(
        -top     => [ $ladresa_ob, 40 ],
        -left    => [ %0,       0 ],
        -padleft => 5,
    );

    my $ecomp_ob = $frm_bot_left->MEntry(
        -width              => 49,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $ecomp_ob->form(
        -top      => [ '&', $lcomp_ob, 0 ],
        -left     => [ %0,  $f1d ],
        -padright => 5,
    );

    #-- sup_teren_ob

    my $lsup_teren_ob = $frm_bot_left->Label( -text => 'Suprafață teren', );
    $lsup_teren_ob->form(
        -top     => [ $lcomp_ob, 8 ],
        -left    => [ %0,         0 ],
        -padleft => 5,
    );

    my $esup_teren_ob = $frm_bot_left->MEntry(
        -width              => 8,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
        -justify            => 'right',
    );
    $esup_teren_ob->form(
        -top       => [ '&', $lsup_teren_ob, 0 ],
        -left      => [ %0,  $f1d ],
        -padbottom => 5,
    );

    #-+ mp

    my $lmp = $frm_bot_left->Label( -text => 'mp', );
    $lmp->form(
        -top  => [ '&', $lsup_teren_ob, 0 ],
        -left => [ $esup_teren_ob, 5 ],
    );

    #- Frame - Bottom Right

    my $frm_bot_right = $frm_bot->LabFrame(
        -foreground => 'blue',
        -label      => 'Dobândire',
        -labelside  => 'acrosstop'
    )->pack(
        -side => 'right',
        -expand => 1,
        -fill   => 'x',
    );

    #-- mod_dob_ob

    my $vmod_dob_ob;
    my $lmod_dob_ob = $frm_bot_right->Label( -text => 'Mod', );
    $lmod_dob_ob->form(
        -top     => [ %0, 0 ],
        -left    => [ %0, 0 ],
        -padleft => 5,
    );

    my $mmod_dob_ob = $frm_bot_right->JComboBox(
        -entrywidth         => 20,
        -textvariable       => \$vmod_dob_ob,
        -disabledforeground => 'black'
    );
    $mmod_dob_ob->form(
        -top     => [ '&', $lmod_dob_ob, 0 ],
        -left    => [ %0,  $f1d ],
        -padleft => 1,
    );

    #-- nract_dob_ob

    my $lnract_dob_ob = $frm_bot_right->Label( -text => 'Document', );
    $lnract_dob_ob->form(
        -top  => [ $lmod_dob_ob, 8 ],
        -left => [ %0, 0 ],
        -padleft => 5,
    );

    my $enract_dob_ob = $frm_bot_right->MEntry(
        -width              => 49,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $enract_dob_ob->form(
        -top      => [ '&', $lnract_dob_ob, 0 ],
        -left     => [ %0,  $f1d ],
        -padright => 5,
    );

    #-- cf_nr_ob

    my $lcf_nr_ob = $frm_bot_right->Label( -text => 'Nr. carte funciară', );
    $lcf_nr_ob->form(
        -top     => [ $lnract_dob_ob, 8 ],
        -left    => [ %0,        0 ],
        -padleft => 5,
    );

    my $ecf_nr_ob = $frm_bot_right->MEntry(
        -width              => 20,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black'
    );
    $ecf_nr_ob->form(
        -top  => [ '&', $lcf_nr_ob, 0 ],
        -left => [ %0,  $f1d ],
    );

    #+- cf_data_ob

    my $vcf_data_ob;
    my $dcf_data_ob = $frm_bot_right->DateEntry(
        -daynames   => \@daynames,
        -variable   => \$vcf_data_ob,
        -arrowimage => 'calmonth16',
        -weekstart => 1,
        -todaybackground => 'lightgreen',
        -parsecmd   => sub {
            Tpda3::Utils->dateentry_parse_date($date_format, @_);
        },
        -formatcmd => sub {
            Tpda3::Utils->dateentry_format_date($date_format, @_);
        },
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $dcf_data_ob->form(
        -top   => [ '&', $lcf_nr_ob, 0 ],
        -right => [ %100, -5 ],
    );

    my $lcf_data_ob = $frm_bot_right->Label( -text => 'Data', );
    $lcf_data_ob->form(
        -top     => [ '&', $lcf_nr_ob, 0 ],
        -right   => [ $dcf_data_ob, -10 ],
    );

    #-- notariat_ob

    my $lnotariat_ob = $frm_bot_right->Label( -text => 'Notariatul', );
    $lnotariat_ob->form(
        -top  => [ $lcf_nr_ob, 8 ],
        -left => [ %0, 0 ],
        -padleft => 5,
    );
    my $enotariat_ob = $frm_bot_right->MEntry(
        -width => 49,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $enotariat_ob->form(
        -top  => [ '&', $lnotariat_ob, 0 ],
        -left => [ %0, $f1d ],
    );

    #-- judecator_ob

    my $ljudecator_ob = $frm_bot_right->Label( -text => 'Judecatoria', );
    $ljudecator_ob->form(
        -top  => [ $lnotariat_ob, 8 ],
        -left => [ %0, 0 ],
        -padleft => 5,
    );
    my $ejudecator_ob = $frm_bot_right->MEntry(
        -width => 49,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $ejudecator_ob->form(
        -top  => [ '&', $ljudecator_ob, 0 ],
        -left => [ %0, $f1d ],
    );

    #-- Cazier fiscal nr. (czf_nr_ob)

    my $lczf_nr_ob = $frm_bot_right->Label( -text => 'Cazier fiscal', );
    $lczf_nr_ob->form(
        -top     => [ $ljudecator_ob, 8 ],
        -left    => [ %0,             0 ],
        -padleft => 5,
    );
    my $eczf_nr_ob = $frm_bot_right->MEntry(
        -width              => 10,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eczf_nr_ob->form(
        -top       => [ '&', $lczf_nr_ob, 0 ],
        -left      => [ %0,  $f1d ],
        -padbottom => 5,
    );

    #+- czf_data_ob

    my $vczf_data_ob;
    my $dczf_data_ob = $frm_bot_right->DateEntry(
        -daynames   => \@daynames,
        -variable   => \$vczf_data_ob,
        -arrowimage => 'calmonth16',
        -parsecmd   => sub {
            Tpda3::Utils->dateentry_parse_date( $date_format, @_ );
        },
        -formatcmd => sub {
            Tpda3::Utils->dateentry_format_date( $date_format, @_ );
        },
        -todaybackground => 'lightgreen',
        -weekstart       => 1,
    );
    $dczf_data_ob->form(
        -top  => [ '&', $lczf_nr_ob, 0 ],
        -left => [ $eczf_nr_ob, 5 ],
    );

    #-+ czf_elib_ob

    my $eczf_elib_ob = $frm_bot_right->MEntry(
        -width              => 16,
        -disabledbackground => $self->{bg},
        -disabledforeground => 'black',
    );
    $eczf_elib_ob->form(
        -top   => [ '&', $lczf_nr_ob, 0 ],
        -right => [ %100, -5 ],
    );

    my $lczf_elib_ob = $frm_bot_right->Label( -text => 'AFP' );
    $lczf_elib_ob->form(
        -top     => [ '&', $lczf_nr_ob, 0 ],
        -right   => [ $eczf_elib_ob, -10 ],
        -padleft => 5,
    );

    # Entry objects: var_asoc, var_obiect
    # Other configurations in 'persoane.conf'
    $self->{controls} = {
        id_contr       => [ undef,           $eid_contr ],
        data_contr     => [ \$vdata_contr,   $ddata_contr ],
        pret_ob        => [ undef,           $epret_ob ],
        mod_plata_ob   => [ undef,           $emod_plata_ob ],
        data_predare   => [ \$vdata_predare, $ddata_predare ],
        loc_predare_ob => [ undef,           $eloc_predare_ob ],
        tip1           => [ \$vtip1,         $rtip1 ],
        numepren1      => [ undef,           $enumepren1 ],
        id_pers1       => [ undef,           $eid_pers1 ],
        cnp1           => [ undef,           $ecnp1 ],
        denumire1      => [ undef,           $edenumire1 ],
        id_firma1      => [ undef,           $eid_firma1 ],
        cui1           => [ undef,           $ecui1 ],
        tip2           => [ \$vtip2,         $rtip2 ],
        numepren2      => [ undef,           $enumepren2 ],
        id_pers2       => [ undef,           $eid_pers2 ],
        cnp2           => [ undef,           $ecnp2 ],
        denumire2      => [ undef,           $edenumire2 ],
        id_firma2      => [ undef,           $eid_firma2 ],
        cui2           => [ undef,           $ecui2 ],
        tip_ob         => [ \$vtip_ob,       $mtip_ob ],
        loc_ob         => [ undef,           $eloc_ob ],
        jud_ob         => [ undef,           $ejud_ob ],
        codp_ob        => [ undef,           $ecodp_ob ],
        siruta_ob      => [ undef,           $esiruta_ob ],
        adresa_ob      => [ undef,           $tadresa_ob ],
        comp_ob        => [ undef,           $ecomp_ob ],
        sup_teren_ob   => [ undef,           $esup_teren_ob ],
        mod_dob_ob     => [ \$vmod_dob_ob,   $mmod_dob_ob ],
        nract_dob_ob   => [ undef,           $enract_dob_ob ],
        cf_nr_ob       => [ undef,           $ecf_nr_ob ],
        cf_data_ob     => [ \$vcf_data_ob,   $dcf_data_ob ],
        notariat_ob    => [ undef,           $enotariat_ob ],
        judecator_ob   => [ undef,           $ejudecator_ob ],
        czf_nr_ob      => [ undef,           $eczf_nr_ob ],
        czf_data_ob    => [ \$vczf_data_ob,  $dczf_data_ob ],
        czf_elib_ob    => [ undef,           $eczf_elib_ob ],
        mentiuni       => [ undef,           $tmentiuni ],
    };

    # Required fields: fld_name => [#, Label] If there are no values
    # in the screen for this fields show a dialog message
    $self->{rq_controls} = {
        data_contr     => [ 0, '  Data contract' ],
        pret_ob        => [ 1, '  Pret obiect' ],
        mod_plata_ob   => [ 2, '  Mod plata' ],
        data_predare   => [ 3, '  Data predare' ],
        loc_predare_ob => [ 4, '  Loc predare' ],
        tip_ob         => [ 5, '  Tip obiect' ],
        siruta_ob      => [ 6, '  Localitate si judet obiect' ],
        adresa_ob      => [ 7, '  Adresa obiect' ],
        comp_ob        => [ 8, '  Componenta obiect' ],
        sup_teren_ob   => [ 9, '  Suprafata teren' ],
        mod_dob_ob     => [ 10, '  Mod dobandire obiect' ],
        nract_dob_ob   => [ 11, '  Nr. act dobandire obiect' ],
        cf_nr_ob       => [ 12, '  CF nr. obiect' ],
        cf_data_ob     => [ 13, '  CF data obiect' ],
        notariat_ob    => [ 14, '  Notariat' ],
        judecator_ob   => [ 15, '  Judecatorie' ],
        czf_nr_ob      => [ 16, '  Cazier fiscal nr.' ],
        czf_data_ob    => [ 17, '  Cazier fiscal data' ],
        czf_elib_ob    => [ 18, '  Cazier fiscal eliberat de' ],
        tip1           => [ 19, '  Persoana sau firma 1?' ],
        tip2           => [ 20, '  Persoana sau firma 2?' ],
        id_pers1  => [ 21, '  Nume si CNP 1', [ 'tip1', 'Persoană' ] ],
        id_firma1 => [ 22, '  Denumire firma si CUI 1', [ 'tip1', 'Firmă' ] ],
        id_pers2  => [ 23, '  Nume si CNP 2', [ 'tip2', 'Persoană' ] ],
        id_firma2 => [ 24, '  Denumire firma si CUI 2', [ 'tip2', 'Firmă' ] ],
    };

    return;
}

=head2 toggle_tip1

Toggle for tip1. Also called from L<Controler.pm>.

=cut

sub toggle_tip1 {
    my ($self, $tip) = @_;

    return if !$tip;

    $self->toggle_entries(1, $tip);

    return;
}

=head2 toggle_tip2

Toggle for tip2. Also called from L<Controler.pm>.

=cut

sub toggle_tip2 {
    my ($self, $tip) = @_;

    return if !$tip;

    $self->toggle_entries(2, $tip);

    return;
}

=head2 toggle_entries

Enable / disable entries acording to the tip variable.

=cut

sub toggle_entries {
    my ($self, $n, $tip) = @_;

    if ($tip =~ m{^P}i) {
        $self->{controls}{"numepren$n"}[1]->configure(-state => 'normal');
        $self->{controls}{"denumire$n"}[1]->configure(-state => 'disabled');
    }
    else {
        $self->{controls}{"numepren$n"}[1]->configure(-state => 'disabled');
        $self->{controls}{"denumire$n"}[1]->configure(-state => 'normal');
    }

    return;
}

=head2 on_load_record

Trigger called from the record load method in Controller.

=cut

sub on_load_record {
    my $self = shift;

    my $vtip1 = $self->{view}->control_read_r( $self->{controls}{tip1} );
    my $vtip2 = $self->{view}->control_read_r( $self->{controls}{tip2} );

    $self->toggle_entries(1, $vtip1);
    $self->toggle_entries(2, $vtip2);

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

1; # End of Tpda3::Tk::App::Notar::Contracte
