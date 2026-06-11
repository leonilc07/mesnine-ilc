/* ============================================================
   BASIC CHECK CONSTRAINTS (Oracle)
   ============================================================ */

-- 1) MERILNA ENOTA (če želiš osnovno validacijo)
ALTER TABLE mes_merilna_enota
  ADD CONSTRAINT mes_m_enota_aktiven_ck
  CHECK (aktiven_yn IN (0,1) OR aktiven_yn IS NULL);

-- tip: če želiš omejitve že zdaj (opcijsko)
ALTER TABLE mes_merilna_enota
  ADD CONSTRAINT mes_m_enota_tip_ck
  CHECK (tip IN ('MASA','KOS','VOLUMEN') OR tip IS NULL);


-- 2) IZDELEK
ALTER TABLE mes_izdelek
  ADD CONSTRAINT mes_izdelek_aktiven_ck
  CHECK (aktiven_yn IN (0,1) OR aktiven_yn IS NULL);

ALTER TABLE mes_izdelek
  ADD CONSTRAINT mes_izdelek_obstoj_ck
  CHECK (obstojnost_dni IS NULL OR obstojnost_dni >= 0);

ALTER TABLE mes_izdelek
  ADD CONSTRAINT mes_izdelek_vrsta_ck
  CHECK (vrsta_izdelka IN ('SVEZE_MESO','HRENOVKA','SUHOMESNATI_IZDELEK','ZACIMBA','POTROSNI_MATERIJAL') OR vrsta_izdelka IS NULL);


-- 3) CENA IZDELKA (veljavnost)
ALTER TABLE mes_cena_izdelka
  ADD CONSTRAINT mes_cena_veljav_ck
  CHECK (veljavna_do IS NULL OR veljavna_do >= veljavna_od);

ALTER TABLE mes_cena_izdelka
  ADD CONSTRAINT mes_cena_cena_ck
  CHECK (cena >= 0);


-- 4) DOBAVA
ALTER TABLE mes_dobava
  ADD CONSTRAINT mes_dobava_stat_ck
  CHECK (status IN ('OSNUTEK','OBJAVLJENA'));


-- 5) POSTAVKA DOBAVE
ALTER TABLE mes_postavka_dobave
  ADD CONSTRAINT mes_post_dob_kol_ck
  CHECK (kolicina > 0);

ALTER TABLE mes_postavka_dobave
  ADD CONSTRAINT mes_post_dob_cen_ck
  CHECK (cena_na_enoto >= 0);

ALTER TABLE mes_postavka_dobave
  ADD CONSTRAINT mes_post_dob_skp_ck
  CHECK (skupaj IS NULL OR skupaj >= 0);


-- 6) RAČUN
ALTER TABLE mes_racun
  ADD CONSTRAINT mes_racun_status_ck
  CHECK (status IN ('OSNUTEK','IZDAN','PLACAN','STORNIRAN'));

-- doc_tip: tukaj daj dejanske vrednosti ki jih uporabljaš (primer)
ALTER TABLE mes_racun
  ADD CONSTRAINT mes_racun_doc_tip_ck
  CHECK (doc_tip IN ('RACUN','DOBROPIS','BREMENOPIS','DOBAVNICA','RACUN_PRODAJA'));



-- 7) POSTAVKA RAČUNA (XOR: natanko ena sledljivost)
ALTER TABLE mes_postavka_racun
  ADD CONSTRAINT mes_post_rac_xor_ck
  CHECK (
    (CASE WHEN serijaid          IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN klanjeid          IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN hrenovke_serijaid IS NULL THEN 0 ELSE 1 END)
    = 1
  );

ALTER TABLE mes_postavka_racun
  ADD CONSTRAINT mes_post_rac_kol_ck
  CHECK (kolicina > 0);

ALTER TABLE mes_postavka_racun
  ADD CONSTRAINT mes_post_rac_cena_ck
  CHECK (cena_kosa >= 0);

ALTER TABLE mes_postavka_racun
  ADD CONSTRAINT mes_post_rac_pop_ck
  CHECK (kolicinski_popust IS NULL OR kolicinski_popust >= 0);

ALTER TABLE mes_postavka_racun
  ADD CONSTRAINT mes_post_rac_skp_ck
  CHECK (vrstica_skupaj IS NULL OR vrstica_skupaj >= 0);


-- 8) PRAŠIČI
ALTER TABLE mes_prasic
  ADD CONSTRAINT mes_pr_teza_prev_ck
  CHECK (teza_pri_prevzemu_kg IS NULL OR teza_pri_prevzemu_kg >= 0);


ALTER TABLE mes_prasic
  ADD CONSTRAINT mes_pr_status_ck
  CHECK (status IN ('V_REJI','ZAKLAN','PRODAN','ODPISAN'));


-- 9) KLANJE
ALTER TABLE mes_klanje_prasic
  ADD CONSTRAINT mes_kp_teza_ck
  CHECK (teza_trupla_kg IS NULL OR teza_trupla_kg >= 0);


-- 10) SERIJE
ALTER TABLE mes_serija
  ADD CONSTRAINT mes_ser_dat_ck
  CHECK (datum_kon IS NULL OR datum_kon >= datum_zac);

ALTER TABLE mes_serija
  ADD CONSTRAINT mes_ser_kol_ck
  CHECK (kolicina_zac > 0 AND (kolicina_kon IS NULL OR kolicina_kon >= 0));

ALTER TABLE mes_serija
  ADD CONSTRAINT mes_ser_stsal_ck
  CHECK (st_sal_kos IS NULL OR st_sal_kos >= 0);

-- self-FK: ne sme kazati nase (osnovno)
ALTER TABLE mes_serija
  ADD CONSTRAINT mes_ser_izvor_ne_sebe_ck
  CHECK (izvor_serijaid IS NULL OR izvor_serijaid <> serijaid);

-- status serije (primer; prilagodi)
ALTER TABLE mes_serija
  ADD CONSTRAINT mes_ser_status_ck
  CHECK (status IN ('PREDELAVA','KONCANA'));


-- 11) SERIJA VNOS (poraba)
ALTER TABLE mes_serija_vnos
  ADD CONSTRAINT mes_sv_kol_ck
  CHECK (kol_porabe > 0);

ALTER TABLE mes_serija_vnos
  ADD CONSTRAINT mes_sv_cena_ck
  CHECK (cena_komada >= 0 AND (cena_porabe IS NULL OR cena_porabe >= 0));


-- 12) SERIJA_PRAŠIČ (ocena prispevka)
ALTER TABLE mes_serija_prasic
  ADD CONSTRAINT mes_sp_ocena_ck
  CHECK (ocenjeno_kg IS NULL OR ocenjeno_kg >= 0);


-- 13) HRENOVKE
ALTER TABLE mes_hrenovke_serija
  ADD CONSTRAINT mes_hs_status_ck
  CHECK (status IN ('POSLANO','VRNJENO','POSLANA','VRNJENA'));

ALTER TABLE mes_hrenovke_serija
  ADD CONSTRAINT mes_hs_dat_ck
  CHECK (datum_prevzema IS NULL OR datum_prevzema >= datum_poslano);

ALTER TABLE mes_hrenovke_serija
  ADD CONSTRAINT mes_hs_kol_ck
  CHECK (
    (kol_poslano_kg  >= 0) AND
    (kol_dobljeno_kg IS NULL OR kol_dobljeno_kg >= 0)
  );


-- 14) ZALOGA (ledger)
ALTER TABLE mes_zaloga
  ADD CONSTRAINT mes_zal_kd_ne0_ck
  CHECK (kol_delta <> 0);

-- tip_gibanja: primer; prilagodi
ALTER TABLE mes_zaloga
  ADD CONSTRAINT mes_zal_tip_ck
  CHECK (tip_gibanja IN ('DOBAVA','PRODAJA','PROIZVODNJA','ODPIS','INVENTURA','STORNO'));


-- 15) ZALOGA TRAJNA (snapshot)
ALTER TABLE mes_zaloga_trajna
  ADD CONSTRAINT mes_zt_kol_ck
  CHECK (trenutna_kolicina >= 0);
