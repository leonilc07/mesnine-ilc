

-- 1) ŠIFRANTI

CREATE TABLE mes_merilna_enota (
  merilna_enota_id NUMBER,
  koda             VARCHAR2(30)  CONSTRAINT mes_m_enota_koda_nn NOT NULL,
  ime              VARCHAR2(100) CONSTRAINT mes_m_enota_ime_nn  NOT NULL,
  tip              VARCHAR2(30),
  aktiven_yn        NUMBER(1),

  CONSTRAINT mes_merilna_enota_pk PRIMARY KEY (merilna_enota_id),
  CONSTRAINT mes_m_enota_koda_uk UNIQUE (koda)
);

CREATE TABLE mes_posta (
  postna_st NUMBER,
  ime       VARCHAR2(100) CONSTRAINT mes_posta_ime_nn NOT NULL,

  CONSTRAINT mes_posta_pk PRIMARY KEY (postna_st)
);

CREATE TABLE mes_metoda_placila (
  metoda_placila_id NUMBER,
  koda              VARCHAR2(30)  CONSTRAINT mes_met_pl_koda_nn NOT NULL,
  ime               VARCHAR2(100) CONSTRAINT mes_met_pl_ime_nn  NOT NULL,
  aktivna_yn         NUMBER(1),

  CONSTRAINT mes_metoda_placila_pk PRIMARY KEY (metoda_placila_id),
  CONSTRAINT mes_met_pl_koda_uk UNIQUE (koda)
);

CREATE TABLE mes_izdelek (
  izdelekid        NUMBER,
  ime              VARCHAR2(200) CONSTRAINT mes_izdelek_ime_nn   NOT NULL,
  vrsta_izdelka    VARCHAR2(50)  CONSTRAINT mes_izdelek_vrsta_nn NOT NULL,
  aktiven_yn       NUMBER(1),
  merilna_enota_id NUMBER        CONSTRAINT mes_izdelek_me_nn    NOT NULL,
  obstojnost_dni   NUMBER,

  CONSTRAINT mes_izdelek_pk PRIMARY KEY (izdelekid),
  CONSTRAINT mes_izdelek_me_fk
    FOREIGN KEY (merilna_enota_id) REFERENCES mes_merilna_enota (merilna_enota_id)
);

CREATE TABLE mes_cena_izdelka (
  cena_izdelkaid NUMBER,
  veljavna_od    DATE   CONSTRAINT mes_cena_od_nn   NOT NULL,
  veljavna_do    DATE,
  cena           NUMBER CONSTRAINT mes_cena_cena_nn NOT NULL,
  izdelekid      NUMBER CONSTRAINT mes_cena_izd_nn  NOT NULL,

  CONSTRAINT mes_cena_izdelka_pk PRIMARY KEY (cena_izdelkaid),
  CONSTRAINT mes_cena_izdelek_fk
    FOREIGN KEY (izdelekid) REFERENCES mes_izdelek (izdelekid)
);

-- 2) PARTNERJI

CREATE TABLE mes_dobavitelj (
  dobaviteljid NUMBER,
  ime          VARCHAR2(200) CONSTRAINT mes_dobav_ime_nn NOT NULL,
  kraj         VARCHAR2(100),
  telefon      VARCHAR2(50),
  aktiven_yn   NUMBER(1),
  postna_st    NUMBER,

  CONSTRAINT mes_dobavitelj_pk PRIMARY KEY (dobaviteljid),
  CONSTRAINT mes_dobav_posta_fk
    FOREIGN KEY (postna_st) REFERENCES mes_posta (postna_st)
);

CREATE TABLE mes_stranka (
  strankaid   NUMBER,
  ime         VARCHAR2(200) CONSTRAINT mes_str_ime_nn NOT NULL,
  davcna_st   VARCHAR2(30),
  kraj        VARCHAR2(100),
  telefon     VARCHAR2(50),
  email       VARCHAR2(200),
  aktiven_yn  NUMBER(1),
  postna_st   NUMBER,

  CONSTRAINT mes_stranka_pk PRIMARY KEY (strankaid),
  CONSTRAINT mes_str_posta_fk
    FOREIGN KEY (postna_st) REFERENCES mes_posta (postna_st)
);

-- 3) NABAVA

CREATE TABLE mes_dobava (
  dobavaid      NUMBER,
  datum         DATE         CONSTRAINT mes_dobava_datum_nn NOT NULL,
  st_dobave     VARCHAR2(50) CONSTRAINT mes_dobava_st_nn    NOT NULL,
  status        VARCHAR2(30) CONSTRAINT mes_dobava_stat_nn  NOT NULL,
  opomba        VARCHAR2(4000),
  dobaviteljid  NUMBER       CONSTRAINT mes_dobava_dob_nn   NOT NULL,

  CONSTRAINT mes_dobava_pk PRIMARY KEY (dobavaid),
  CONSTRAINT mes_dobava_dob_fk
    FOREIGN KEY (dobaviteljid) REFERENCES mes_dobavitelj (dobaviteljid)
);

CREATE TABLE mes_postavka_dobave (
  postavka_dobaveid NUMBER,
  vrstica_st        NUMBER CONSTRAINT mes_post_dob_vst_nn  NOT NULL,
  kolicina          NUMBER CONSTRAINT mes_post_dob_kol_nn  NOT NULL,
  cena_na_enoto     NUMBER,
  skupaj            NUMBER,
  opomba            VARCHAR2(4000),
  dobavaid          NUMBER CONSTRAINT mes_post_dob_dob_nn  NOT NULL,
  izdelekid         NUMBER CONSTRAINT mes_post_dob_izd_nn  NOT NULL,

  CONSTRAINT mes_postavka_dobave_pk PRIMARY KEY (postavka_dobaveid),
  CONSTRAINT mes_post_dob_dob_fk
    FOREIGN KEY (dobavaid) REFERENCES mes_dobava (dobavaid),
  CONSTRAINT mes_post_dob_izd_fk
    FOREIGN KEY (izdelekid) REFERENCES mes_izdelek (izdelekid)
);

-- 4) PRODAJA

CREATE TABLE mes_racun (
  racunid           NUMBER,
  doc_tip           VARCHAR2(30)  CONSTRAINT mes_racun_doc_nn  NOT NULL,
  racun_st          VARCHAR2(50)  CONSTRAINT mes_racun_st_nn   NOT NULL,
  datum             DATE          CONSTRAINT mes_racun_dat_nn  NOT NULL,
  status            VARCHAR2(30)  CONSTRAINT mes_racun_sta_nn  NOT NULL,
  opomba            VARCHAR2(4000),
  izvor_racun       NUMBER,
  metoda_placila_id NUMBER        CONSTRAINT mes_racun_mp_nn   NOT NULL,
  strankaid         NUMBER        CONSTRAINT mes_racun_str_nn  NOT NULL,

  CONSTRAINT mes_racun_pk PRIMARY KEY (racunid),
  CONSTRAINT mes_racun_st_uk UNIQUE (racun_st),
  constraint mes_racun_izvor_fk
    FOREIGN KEY (izvor_racun) REFERENCES mes_racun (racunid),
  CONSTRAINT mes_racun_mp_fk 
    FOREIGN KEY (metoda_placila_id) REFERENCES mes_metoda_placila (metoda_placila_id),
  CONSTRAINT mes_racun_str_fk
    FOREIGN KEY (strankaid) REFERENCES mes_stranka (strankaid)
);

-- 5) PRAŠIČI / KLANJE

CREATE TABLE mes_prasic_skupina (
  prasic_skupinaid NUMBER,
  koda             VARCHAR2(50) CONSTRAINT mes_ps_koda_nn NOT NULL,
  datum_dobave     DATE         CONSTRAINT mes_ps_dat_nn  NOT NULL,
  opomba           VARCHAR2(4000),
  dobaviteljid     NUMBER       CONSTRAINT mes_ps_dob_nn  NOT NULL,

  CONSTRAINT mes_prasic_skupina_pk PRIMARY KEY (prasic_skupinaid),
  CONSTRAINT mes_ps_koda_uk UNIQUE (koda),
  CONSTRAINT mes_ps_dob_fk
    FOREIGN KEY (dobaviteljid) REFERENCES mes_dobavitelj (dobaviteljid)
);



CREATE TABLE mes_prasic (
  prasicid             NUMBER,
  koda                 VARCHAR2(50) CONSTRAINT mes_pr_koda_nn NOT NULL,
  teza_pri_prevzemu_kg NUMBER,
  status               VARCHAR2(30) CONSTRAINT mes_pr_sta_nn  NOT NULL,
  opomba               VARCHAR2(4000),
  prasic_skupinaid     NUMBER       CONSTRAINT mes_pr_ps_nn   NOT NULL,

  CONSTRAINT mes_prasic_pk PRIMARY KEY (prasicid),
  CONSTRAINT mes_pr_koda_uk UNIQUE (koda),
  CONSTRAINT mes_pr_ps_fk
    FOREIGN KEY (prasic_skupinaid) REFERENCES mes_prasic_skupina (prasic_skupinaid)
);


CREATE TABLE mes_klanje (
  klanjeid     NUMBER,
  datum_klanja DATE         CONSTRAINT mes_kl_dat_nn NOT NULL,
  doc_st       VARCHAR2(50) CONSTRAINT mes_kl_doc_nn NOT NULL,
  opomba       VARCHAR2(4000),

  CONSTRAINT mes_klanje_pk PRIMARY KEY (klanjeid)
);

CREATE TABLE mes_klanje_prasic (
  teza_trupla_kg NUMBER,
  klanjeid       NUMBER CONSTRAINT mes_kp_kl_nn NOT NULL,
  prasicid       NUMBER CONSTRAINT mes_kp_pr_nn NOT NULL,

  CONSTRAINT mes_klanje_prasic_pk PRIMARY KEY (klanjeid, prasicid),
  CONSTRAINT mes_kp_kl_fk FOREIGN KEY (klanjeid) REFERENCES mes_klanje (klanjeid),
  CONSTRAINT mes_kp_pr_fk FOREIGN KEY (prasicid) REFERENCES mes_prasic (prasicid)
);

-- 6) SERIJE

CREATE TABLE mes_serija (
  serijaid       NUMBER,
  koda           VARCHAR2(50) CONSTRAINT mes_ser_koda_nn NOT NULL,
  datum_zac      DATE         CONSTRAINT mes_ser_dz_nn   NOT NULL,
  datum_kon      DATE,
  kolicina_zac   NUMBER       CONSTRAINT mes_ser_kz_nn   NOT NULL,
  kolicina_kon   NUMBER,
  status         VARCHAR2(30) CONSTRAINT mes_ser_sta_nn  NOT NULL,
  opomba         VARCHAR2(4000),
  st_sal_kos     NUMBER,
  izdelekid      NUMBER       CONSTRAINT mes_ser_izd_nn  NOT NULL,
  izvor_serijaid NUMBER,

  CONSTRAINT mes_serija_pk PRIMARY KEY (serijaid),
  CONSTRAINT mes_ser_izd_fk FOREIGN KEY (izdelekid) REFERENCES mes_izdelek (izdelekid),
  CONSTRAINT mes_ser_izvor_fk FOREIGN KEY (izvor_serijaid) REFERENCES mes_serija (serijaid)
);

CREATE TABLE mes_serija_vnos (
  serija_vnosid     NUMBER,
  kol_porabe        NUMBER CONSTRAINT mes_sv_kol_nn NOT NULL,
  cena_komada       NUMBER ,
  cena_porabe       NUMBER,
  opomba            VARCHAR2(4000),
  postavka_dobaveid NUMBER CONSTRAINT mes_sv_posd_fk_nn NOT NULL,
  serijaid          NUMBER CONSTRAINT mes_sv_ser_fk_nn NOT NULL,
  izdelekid         NUMBER CONSTRAINT mes_sv_izd_nn NOT NULL,

  CONSTRAINT mes_serija_vnos_pk PRIMARY KEY (serija_vnosid),
  CONSTRAINT mes_sv_pd_fk FOREIGN KEY (postavka_dobaveid) REFERENCES mes_postavka_dobave (postavka_dobaveid),
  CONSTRAINT mes_sv_ser_fk FOREIGN KEY (serijaid) REFERENCES mes_serija (serijaid),
  CONSTRAINT mes_sv_izd_fk FOREIGN KEY (izdelekid) REFERENCES mes_izdelek (izdelekid)
);

CREATE TABLE mes_serija_prasic (
  opomba      VARCHAR2(4000),
  ocenjeno_kg NUMBER,
  prasicid    NUMBER CONSTRAINT mes_sp_pr_nn  NOT NULL,
  serijaid    NUMBER CONSTRAINT mes_sp_ser_nn NOT NULL,

  CONSTRAINT mes_serija_prasic_pk PRIMARY KEY (prasicid, serijaid),
  CONSTRAINT mes_sp_pr_fk FOREIGN KEY (prasicid) REFERENCES mes_prasic (prasicid),
  CONSTRAINT mes_sp_ser_fk FOREIGN KEY (serijaid) REFERENCES mes_serija (serijaid)
);

-- 7) HRENOVKE

CREATE TABLE mes_hrenovke_serija (
  hrenovke_serijaid NUMBER,
  koda              VARCHAR2(50) CONSTRAINT mes_hs_koda_nn NOT NULL,
  datum_poslano     DATE constraint mes_hs_dp_nn NOT NULL,
  datum_prevzema    DATE,
  status            VARCHAR2(30) CONSTRAINT mes_hs_sta_nn  NOT NULL,
  kol_poslano_kg    NUMBER constraint mes_hs_kp_nn NOT NULL,
  kol_dobljeno_kg   NUMBER,
  opomba            VARCHAR2(4000),
  dobaviteljid      NUMBER CONSTRAINT mes_hs_dob_nn  NOT NULL,

  CONSTRAINT mes_hrenovke_serija_pk PRIMARY KEY (hrenovke_serijaid),
  CONSTRAINT mes_hs_koda_uk UNIQUE (koda),
  CONSTRAINT mes_hs_dob_fk FOREIGN KEY (dobaviteljid) REFERENCES mes_dobavitelj (dobaviteljid)
);

CREATE TABLE mes_izvor_hrenovk (
  klanjeid          NUMBER CONSTRAINT mes_ih_kl_nn NOT NULL,
  hrenovke_serijaid NUMBER CONSTRAINT mes_ih_hs_nn NOT NULL,

  CONSTRAINT mes_izvor_hrenovk_pk PRIMARY KEY (klanjeid, hrenovke_serijaid),
  CONSTRAINT mes_ih_kl_fk FOREIGN KEY (klanjeid) REFERENCES mes_klanje (klanjeid),
  CONSTRAINT mes_ih_hs_fk FOREIGN KEY (hrenovke_serijaid) REFERENCES mes_hrenovke_serija (hrenovke_serijaid)
);

-- 8) POSTAVKA RAČUNA (PK = (izdelekid, racunid) po sliki)

CREATE TABLE mes_postavka_racun (
  vrstica_st        NUMBER CONSTRAINT mes_pr_vst_nn NOT NULL,
  kolicina          NUMBER CONSTRAINT mes_pr_kol_nn NOT NULL,
  cena_kosa         NUMBER,
  kolicinski_popust NUMBER,
  vrstica_skupaj    NUMBER,
  serijaid          NUMBER,
  klanjeid          NUMBER,
  hrenovke_serijaid NUMBER,
  izdelekid         NUMBER CONSTRAINT mes_pr_izd_nn NOT NULL,
  racunid           NUMBER CONSTRAINT mes_pr_rac_nn NOT NULL,
 
  CONSTRAINT mes_postavka_racun_pk PRIMARY KEY (izdelekid, racunid),
  CONSTRAINT mes_pr_izd_fk FOREIGN KEY (izdelekid) REFERENCES mes_izdelek (izdelekid),
  CONSTRAINT mes_pr_rac_fk FOREIGN KEY (racunid) REFERENCES mes_racun (racunid),
  CONSTRAINT mes_pr_ser_fk FOREIGN KEY (serijaid) REFERENCES mes_serija (serijaid),
  CONSTRAINT mes_pr_kl_fk  FOREIGN KEY (klanjeid) REFERENCES mes_klanje (klanjeid),
  CONSTRAINT mes_pr_hs_fk  FOREIGN KEY (hrenovke_serijaid) REFERENCES mes_hrenovke_serija (hrenovke_serijaid)
);

-- 9) ZALOGA

CREATE TABLE mes_zaloga (
  zalogaid          NUMBER,
  datum_gibanja     DATE         CONSTRAINT mes_zal_dat_nn NOT NULL,
  tip_gibanja       VARCHAR2(30) CONSTRAINT mes_zal_tip_nn NOT NULL,
  kol_delta         NUMBER       CONSTRAINT mes_zal_kd_nn  NOT NULL,
  opomba            VARCHAR2(4000),
  izdelekid         NUMBER       CONSTRAINT mes_zal_izd_fk_nn  NOT NULL,
  postavka_dobaveid NUMBER,
  serijaid          NUMBER,
  izdelekid_p       NUMBER,
  racunid_p         NUMBER,

  CONSTRAINT mes_zaloga_pk PRIMARY KEY (zalogaid),
  CONSTRAINT mes_zal_izd_fk FOREIGN KEY (izdelekid) REFERENCES mes_izdelek (izdelekid),
  CONSTRAINT mes_zal_pd_fk  FOREIGN KEY (postavka_dobaveid) REFERENCES mes_postavka_dobave (postavka_dobaveid),
  CONSTRAINT mes_zal_ser_fk FOREIGN KEY (serijaid) REFERENCES mes_serija (serijaid),
  CONSTRAINT mes_zal_pr_fk  FOREIGN KEY (izdelekid_p, racunid_p) REFERENCES mes_postavka_racun (izdelekid, racunid)
);

-- 10) ZALOGA TRAJNA (trenutno stanje po izdelku, polni se s trigerji iz MES_ZALOGA)

CREATE TABLE mes_zaloga_trajna (
  izdelekid          NUMBER CONSTRAINT mes_zt_izd_nn  NOT NULL,
  trenutna_kolicina  NUMBER CONSTRAINT mes_zt_kol_nn  NOT NULL,
  zadnje_gibanje     DATE,

  CONSTRAINT mes_zaloga_trajna_pk PRIMARY KEY (izdelekid),
  CONSTRAINT mes_zt_izd_fk FOREIGN KEY (izdelekid) REFERENCES mes_izdelek (izdelekid)
);