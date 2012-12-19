/*
 *  NOTAR
 */

/*

Postgresql >= v8.2


Database: notar

DROP DATABASE notar;

% createdb -U postgres -O stefan -T template0 -E UTF8 notar

or (NOT TESTED !)

CREATE ROLE notar CREATEDB LOGIN [ ENCRYPTED ] PASSWORD 'password';

ALTER ROLE notar WITH PASSWORD 'password';

ALTER ROLE notar WITH LOGIN;

CREATE DATABASE notar
    WITH OWNER = 'username'
       ENCODING = 'UTF8'
       TABLESPACE = pg_default;

*/

-- Language

-- CREATE LANGUAGE plpgsql;

-- TABLES

--
-- Tabele comune
--

-- Domenii

CREATE DOMAIN year AS integer
       CONSTRAINT year_check CHECK (((VALUE >= 1901) AND (VALUE <= 2155)));


/*
 * Name : tari
 * Type : table
 * Desc : Țările lumii
 * Deps :
 */
CREATE TABLE tari (
   tara         VARCHAR(50)
 , denumire     VARCHAR(100)
 , tara_cod     CHAR(2)
 , capitala     VARCHAR(100)
 , adjectiv     VARCHAR(100)
 , moneda       VARCHAR(100)
 , moneda_cod   VARCHAR(20)
 , moneda_sub   VARCHAR(50)
);

/*
 * Name : judete
 * Type : table
 * Desc : Judete
 * Deps :
 */
CREATE TABLE judete (
   jud           SMALLINT
 , denj          VARCHAR(20)
 , mnemonic      CHAR(2)
 , zona          SMALLINT
 , CONSTRAINT pk_judete_jud PRIMARY KEY (jud)
);

/*
 * Name : siruta_tip
 * Type : table
 * Desc : SIRUTA tip superior
 * Deps :
 */
CREATE TABLE siruta_tip (
   tip         SMALLINT
 , denumire    VARCHAR(100)   -- utf8
 , CONSTRAINT pk_siruta_tip_tip PRIMARY KEY (tip)
);

/*
 * Name : siruta
 * Type : table
 * Desc : Sistemul Informatic al Registrului Unităților
 *        Teritorial - Administrative
 * Deps :
 */
CREATE TABLE siruta (
   siruta      INTEGER
 , sirsup      INTEGER
 , localitate  VARCHAR(40)   -- utf8
 , superior    VARCHAR(40)   -- utf8
 , tip         SMALLINT
 , med         SMALLINT
 , denloc      VARCHAR(40)   -- ascii uc
 , densup      VARCHAR(40)   -- ascii uc
 , tipsup      SMALLINT
 , regiune     SMALLINT
 , codp        VARCHAR(6)
 , jud         SMALLINT
 , mnemonic    CHAR(2)
 , CONSTRAINT pk_siruta_siruta PRIMARY KEY (siruta)
);

/*
 * Name : codificari
 * Type : table
 * Desc : Codificari diverse
 * Deps :
 */
 CREATE TABLE codificari (
   id_ord       SERIAL
 , variabila    VARCHAR(15)
 , filtru       VARCHAR(5)
 , cod          VARCHAR(5)
 , denumire     VARCHAR(30) NOT NULL
 , descriere    VARCHAR(150)
 , CONSTRAINT pk_codificari_id_ord PRIMARY KEY (id_ord)
);

/*
 * Name : reports
 * Type : table
 * Desc : Report Manager reports metadata
 * Deps :
 */
CREATE TABLE reports (
   id_rep       SERIAL
 , id_user      INTEGER
 , repofile     VARCHAR(150)
 , title        VARCHAR(50)
 , descr        TEXT
 , CONSTRAINT pk_reports_id_rep PRIMARY KEY (id_rep)
);

/*
 * Name : reports_det
 * Type : table
 * Desc : Report Manager reports metadata details
 * Deps :
 */

CREATE TABLE reports_det (
   id_rep       INTEGER      NOT NULL
 , id_art       INTEGER      NOT NULL
 , hint         VARCHAR(15)  NOT NULL
 , tablename    VARCHAR(25)  NOT NULL
 , searchfield  VARCHAR(25)  NOT NULL
 , resultfield  VARCHAR(25)  NOT NULL
 , headerlist   VARCHAR(50)  NOT NULL
 , CONSTRAINT pk_reports_det_id_rep PRIMARY KEY (id_rep, id_art)
 , CONSTRAINT fk_reports_det_id_rep FOREIGN KEY (id_rep)
       REFERENCES reports (id_rep)
           ON DELETE CASCADE
           ON UPDATE CASCADE
);

--
-- Tabele specifice
--


/*
 * Name : personal
 * Type : table
 * Desc : Personal angajat
 * Deps :
 */

CREATE TABLE personal (
   id_pers     SERIAL                     -- PK
 , nume        VARCHAR(25)   NOT NULL     -- Nume
 , prenume     VARCHAR(35)   NOT NULL     -- Prenume
 , functia     VARCHAR(35)   DEFAULT NULL -- Functia
 , data_ang    DATE          DEFAULT NULL -- Data angajarii
 , data_plec   DATE          DEFAULT NULL -- Data plecarii
 , CONSTRAINT pk_personal_id_pers PRIMARY KEY (id_pers)
);


/*
 * Name : terti
 * Type : table
 * Desc : Date despre terte firme
 * Deps :
 */

CREATE TABLE firme (
   -- Identificare
   id_firma    SERIAL
 , denumire    VARCHAR(100) NOT NULL       -- Nume firma
 , cui         VARCHAR(20)  DEFAULT NULL   -- Cod unic de identificare
 , nr_reg_com  VARCHAR(15)  DEFAULT NULL   -- Nr. Registrul Comertului
   -- Localizare
 , siruta      INTEGER                     -- Localitate (siruta)
 , codp        CHAR(6)                     -- Cod postal
 , adresa      TEXT                        -- Adresa
   -- Reprezentare
 , reprez_func VARCHAR(20)  DEFAULT NULL   -- Director?
 , reprez_titl VARCHAR(20)  DEFAULT NULL   -- Domn/Doamna/Ing./etc.
 , reprez_nume VARCHAR(50)  DEFAULT NULL   -- Persoana de contact
   -- Contact
 , tel         VARCHAR(100) DEFAULT NULL   -- Telefon
 , fax         VARCHAR(100) DEFAULT NULL   -- Fax
 , e_mail      VARCHAR(100) DEFAULT NULL   -- E-mail
 , obs         TEXT
 , CONSTRAINT pk_firme_id_firma PRIMARY KEY (id_firma)
);


/*
 * Name : contracte
 * Type : table
 * Desc : Contracte
 * Deps :
 */

CREATE TABLE contracte (
   -- Contract
   id_contr          SERIAL
 , data_contr        DATE         DEFAULT 'today'
 , pret_ob           INTEGER
 , mod_plata_ob      VARCHAR(160)
 , data_predare      DATE
 , loc_predare_ob    VARCHAR(160)
   -- Vanzator
 , tip1              VARCHAR(10)
 , id_pers1          INTEGER
 , id_firma1         INTEGER
   -- Cumparator
 , tip2              VARCHAR(10)
 , id_pers2          INTEGER
 , id_firma2         INTEGER
   -- Obiect
 , tip_ob            VARCHAR(2)
 , siruta_ob         INTEGER                     -- Localitate (siruta)
 , codp_ob           CHAR(6)                     -- Cod postal
 , adresa_ob         TEXT                        -- Adresa
 , comp_ob           VARCHAR(160)
 , sup_teren_ob      VARCHAR(10)
 , mod_dob_ob        VARCHAR(2)
 , nract_dob_ob      VARCHAR(20)
 , cf_nr_ob          VARCHAR(20)
 , cf_data_ob        DATE
 , notariat_ob       VARCHAR(160)
 , judecator_ob      VARCHAR(160)
 , czf_nr_ob         VARCHAR(20)
 , czf_data_ob       DATE
 , czf_elib_ob       VARCHAR(30)
   -- Obs
 , mentiuni          TEXT
 , CONSTRAINT pk_contracte_id_contr PRIMARY KEY (id_contr)
);

/*
 * Name: persoane
 * Type: table
 * Desc: Lista persoane aflate in evidenta
 * Deps:
 */
CREATE TABLE persoane (
   id_pers        SERIAL                     -- PK
 , nume           VARCHAR(25)   NOT NULL     -- Nume
 , prenume        VARCHAR(35)   NOT NULL     -- Prenume
 , prenume_p      VARCHAR(35)   DEFAULT NULL -- Prenume tata
 , cnp            VARCHAR(13)   NOT NULL     -- CNP
 , data_nast      DATE          NOT NULL     -- Data nasterii
 , siruta_ds      INTEGER       DEFAULT NULL -- (localitate) Domiciliu
 , codp_ds        CHAR(6)                    -- Cod postal
 , adresa_ds      TEXT          DEFAULT NULL -- Adresa
 , tara_cod_ds    CHAR(2)       DEFAULT 'RO' -- Țara
 , loc_strain_ds  VARCHAR(160)  DEFAULT NULL -- Localitate din strainatate
 , gen            VARCHAR(10)   NOT NULL     -- Gen (masculin feminin)
 , nation         VARCHAR(30)   DEFAULT NULL -- Naționalitate
 , tel            VARCHAR(50)   DEFAULT NULL -- Telefon
 , email          VARCHAR(150)  DEFAULT NULL -- E-mail
 , obs            TEXT          DEFAULT NULL -- Observatii
 , CONSTRAINT pk_persoane_id_pers PRIMARY KEY (id_pers)
 , CONSTRAINT uq_persoane_cnp UNIQUE (cnp)
);

--
-- Vederi (views)
--

/*
 *  Name  : v_siruta
 *  Descr :
 *  Deps  : table: siruta
 */
CREATE OR REPLACE VIEW v_siruta (
   siruta
 , sirsup
 , localitate
 , superior
 , tip
 , med
 , denloc
 , densup
 , tipsup
 , regiune
 , codp
 , jud
 , mnemonic
 , judet
) AS
SELECT
   sr.siruta
 , sr.sirsup
 , sr.localitate
 , CASE
    WHEN (sr.tipsup IS NULL) THEN NULL
    WHEN (sr.tipsup = 3) THEN 'Comuna ' || sr.superior
    ELSE sr.superior
   END AS superior
 , sr.tip
 , sr.med
 , sr.denloc
 , sr.densup
 , sr.tipsup
 , sr.regiune
 , sr.codp
 , sr.jud
 , sr.mnemonic
 , sj.denj AS judet
  FROM siruta sr
      LEFT JOIN judete sj ON sr.jud = sj.jud
;

/*
 *  Name  : v_persoane
 *  Descr : Registru persoane si date personale
 *  Deps  : table:persoane
 */
--Vab
CREATE OR REPLACE VIEW v_persoane (
   id_pers
 , nume
 , prenume
 , numepren
 , prenume_p
 , cnp
 , data_nast
 , siruta_ds, loc_ds, jud_ds, codp_ds, judet_ds
 , adresa_ds
 , tara_ds, tara_cod_ds
 , loc_strain_ds
 , gen
 , nation
 , tel
 , email
 , obs
) AS
SELECT
   p.id_pers
 , p.nume
 , p.prenume
 , p.nume || ' ' || p.prenume AS numepren
 , p.prenume_p
 , p.cnp
 , p.data_nast
 , p.siruta_ds, sds.localitate AS loc_ds, sds.mnemonic AS jud_ds, sds.codp AS codp_ds, sds.judet AS judet_ds
 , p.adresa_ds
 , t.tara, p.tara_cod_ds
 , p.loc_strain_ds
 , p.gen
 , p.nation
 , p.tel
 , p.email
 , p.obs
 FROM persoane p
     LEFT OUTER JOIN v_siruta sds ON p.siruta_ds = sds.siruta
     LEFT OUTER JOIN tari t ON p.tara_cod_ds = t.tara_cod
;

CREATE OR REPLACE VIEW v_firme (
   id_firma
 , denumire
 , cui
 , nr_reg_com
 , localitate
 , siruta
 , judet
 , codjud
 , codp
 , adresa
 , reprez_func
 , reprez_titl
 , reprez_nume
 , tel
 , fax
 , e_mail
) AS
SELECT
   f.id_firma
 , f.denumire
 , f.cui
 , f.nr_reg_com
 , s.localitate
 , f.siruta
 , s.judet
 , s.mnemonic
 , f.codp
 , f.adresa
 , f.reprez_func
 , f.reprez_titl
 , f.reprez_nume
 , f.tel
 , f.fax
 , f.e_mail
 FROM firme f
     LEFT OUTER JOIN v_siruta s ON f.siruta = s.siruta
;

/*
 *  Name  : mod_dob_ob
 *  Descr : Mod dobandire obiect
 *  Deps  : codificari
 */
CREATE OR REPLACE VIEW mod_dob_ob (
   cod
 , denumire
) AS
   SELECT cod, denumire
   FROM codificari
   WHERE variabila = 'mod_dob_ob';

/*
 *  Name  : tip_ob
 *  Descr : Lista tipuri obiecte
 *  Deps  : codificari
 */
CREATE OR REPLACE VIEW tip_ob (
   cod
 , denumire
) AS
   SELECT cod, denumire
       FROM codificari
       WHERE variabila = 'tip_ob';

CREATE OR REPLACE VIEW v_contracte (
   id_contr
 , data_contr
 , pret_ob
 , mod_plata_ob
 , data_predare
 , loc_predare_ob
 , tip1
 , numepren1
 , id_pers1
 , cnp1
 , denumire1
 , id_firma1
 , cui1
 , tip2
 , numepren2
 , id_pers2
 , cnp2
 , denumire2
 , id_firma2
 , cui2
 , tip_ob, tipd_ob
 , loc_ob
 , jud_ob
 , judet_ob
 , siruta_ob
 , codp_ob
 , adresa_ob
 , comp_ob
 , sup_teren_ob
 , mod_dob_ob, moddob_ob
 , nract_dob_ob
 , cf_nr_ob
 , cf_data_ob
 , notariat_ob
 , judecator_ob
 , czf_nr_ob
 , czf_data_ob
 , czf_elib_ob
 , mentiuni
) AS
 SELECT
   c.id_contr
 , c.data_contr
 , c.pret_ob
 , c.mod_plata_ob
 , c.data_predare
 , c.loc_predare_ob
 , c.tip1
 , p1.nume || ' ' || p1.prenume AS numepren1
 , c.id_pers1
 , p1.cnp AS cnp1
 , f1.denumire AS denumire1
 , c.id_firma1
 , f1.cui AS cui1
 , c.tip2
 , p2.nume || ' ' || p2.prenume AS numepren2
 , c.id_pers2
 , p2.cnp AS cnp2
 , f2.denumire AS denumire2
 , c.id_firma2
 , f2.cui AS cui2
 , c.tip_ob, tp.denumire AS tipd_ob
 , s.localitate AS loc_ob
 , s.mnemonic AS jud_ob
 , s.judet AS judet_ob
 , c.siruta_ob
 , c.codp_ob
 , c.adresa_ob
 , c.comp_ob
 , c.sup_teren_ob
 , c.mod_dob_ob, md.denumire AS moddob_ob
 , c.nract_dob_ob
 , c.cf_nr_ob
 , c.cf_data_ob
 , c.notariat_ob
 , c.judecator_ob
 , c.czf_nr_ob
 , c.czf_data_ob
 , c.czf_elib_ob
 , c.mentiuni
 FROM contracte c
     LEFT OUTER JOIN v_siruta s ON c.siruta_ob = s.siruta
     LEFT OUTER JOIN v_persoane p1 ON c.id_pers1 = p1.id_pers
     LEFT OUTER JOIN v_persoane p2 ON c.id_pers2 = p2.id_pers
     LEFT OUTER JOIN v_firme f1 ON c.id_firma1 = f1.id_firma
     LEFT OUTER JOIN v_firme f2 ON c.id_firma2 = f2.id_firma
     LEFT OUTER JOIN mod_dob_ob md ON c.mod_dob_ob = md.cod
     LEFT OUTER JOIN tip_ob tp ON c.tip_ob = tp.cod
;

CREATE OR REPLACE VIEW v_contracte_imobil (
   id_contr
 , data_contr
 , pret_ob
 , mod_plata_ob
 , data_predare
 , loc_predare_ob
 , tip1
 , numepren1
 , id_pers1
 , cnp1
 , localitatep1
 , judetp1
 , codpp1
 , adresap1
 , denumire1
 , id_firma1
 , cui1
 , nrregcom1
 , localitatef1
 , judetf1
 , codpf1
 , adresaf1
 , reprezfunc1
 , repreztitl1
 , repreznume1
 , telf1
 , tip2
 , numepren2
 , id_pers2
 , cnp2
 , localitatep2
 , judetp2
 , codpp2
 , adresap2
 , denumire2
 , id_firma2
 , cui2
 , nrregcom2
 , localitatef2
 , judetf2
 , codpf2
 , adresaf2
 , reprezfunc2
 , repreztitl2
 , repreznume2
 , telf2
 , tip_ob, tipd_ob
 , loc_ob
 , jud_ob
 , judet_ob
 , siruta_ob
 , codp_ob
 , adresa_ob
 , comp_ob
 , sup_teren_ob
 , mod_dob_ob, moddob_ob
 , nract_dob_ob
 , cf_nr_ob
 , cf_data_ob
 , notariat_ob
 , judecator_ob
 , czf_nr_ob
 , czf_data_ob
 , czf_elib_ob
 , mentiuni
) AS
 SELECT
   c.id_contr
 , to_char(c.data_contr, 'DD.MM.YYYY') AS data_contr
 , c.pret_ob
 , c.mod_plata_ob
 , to_char(c.data_predare, 'DD.MM.YYYY') AS data_predare
 , c.loc_predare_ob
 , c.tip1
 , p1.nume || ' ' || p1.prenume AS numepren1
 , c.id_pers1
 , p1.cnp AS cnp1
 , p1.loc_ds AS localitatep1
 , p1.judet_ds AS judetp1
 , p1.codp_ds AS codpp1
 , p1.adresa_ds AS adresap1
 , f1.denumire AS denumire1
 , c.id_firma1
 , f1.cui AS cui1
 , f1.nr_reg_com AS nrregcom1
 , f1.localitate AS localitatef1
 , f1.judet AS judetf1
 , f1.codp AS codpf1
 , f1.adresa AS adresaf1
 , f1.reprez_func AS reprezfunc1
 , f1.reprez_titl AS repreztitl1
 , f1.reprez_nume AS repreznume1
 , f1.tel AS telf1
 , c.tip2
 , p2.nume || ' ' || p2.prenume AS numepren2
 , c.id_pers2
 , p2.cnp AS cnp2
 , p2.loc_ds AS localitatep2
 , p2.judet_ds AS judetp2
 , p2.codp_ds AS codpp2
 , p2.adresa_ds AS adresap2
 , f2.denumire AS denumire2
 , c.id_firma2
 , f2.cui AS cui2
 , f2.nr_reg_com AS nrregcom2
 , f2.localitate AS localitatef2
 , f2.judet AS judetf2
 , f2.codp AS codpf2
 , f2.adresa AS adresaf2
 , f2.reprez_func AS reprezfunc2
 , f2.reprez_titl AS repreztitl2
 , f2.reprez_nume AS repreznume2
 , f2.tel AS telf2
 , c.tip_ob, tp.denumire AS tipd_ob
 , s.localitate AS loc_ob
 , s.mnemonic AS jud_ob
 , s.judet AS judet_ob
 , c.siruta_ob
 , c.codp_ob
 , c.adresa_ob
 , c.comp_ob
 , c.sup_teren_ob
 , c.mod_dob_ob, md.denumire AS moddob_ob
 , c.nract_dob_ob
 , c.cf_nr_ob
 , to_char(c.cf_data_ob, 'DD.MM.YYYY') AS cf_data_ob
 , c.notariat_ob
 , c.judecator_ob
 , c.czf_nr_ob
 , to_char(c.czf_data_ob, 'DD.MM.YYYY') AS czf_data_ob
 , c.czf_elib_ob
 , c.mentiuni
 FROM contracte c
     LEFT OUTER JOIN v_siruta s ON c.siruta_ob = s.siruta
     LEFT OUTER JOIN v_persoane p1 ON c.id_pers1 = p1.id_pers
     LEFT OUTER JOIN v_persoane p2 ON c.id_pers2 = p2.id_pers
     LEFT OUTER JOIN v_firme f1 ON c.id_firma1 = f1.id_firma
     LEFT OUTER JOIN v_firme f2 ON c.id_firma2 = f2.id_firma
     LEFT OUTER JOIN mod_dob_ob md ON c.mod_dob_ob = md.cod
     LEFT OUTER JOIN tip_ob tp ON c.tip_ob = tp.cod
;
