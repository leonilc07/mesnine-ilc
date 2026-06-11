/* ============================================================
   DROP CHECK CONSTRAINTS (Oracle)
   Zaženi samo kadar želiš pobrisati check constrainte,
   npr. pred ponovnim ustvarjanjem ali med razvojem.
   ============================================================ */

-- 1) MERILNA ENOTA
ALTER TABLE mes_merilna_enota  DROP CONSTRAINT mes_m_enota_aktiven_ck;
ALTER TABLE mes_merilna_enota  DROP CONSTRAINT mes_m_enota_tip_ck;

-- 2) IZDELEK
ALTER TABLE mes_izdelek         DROP CONSTRAINT mes_izdelek_aktiven_ck;
ALTER TABLE mes_izdelek         DROP CONSTRAINT mes_izdelek_obstoj_ck;

-- 3) CENA IZDELKA
ALTER TABLE mes_cena_izdelka    DROP CONSTRAINT mes_cena_veljav_ck;
ALTER TABLE mes_cena_izdelka    DROP CONSTRAINT mes_cena_cena_ck;

-- 4) DOBAVA
ALTER TABLE mes_dobava          DROP CONSTRAINT mes_dobava_stat_ck;

-- 5) POSTAVKA DOBAVE
ALTER TABLE mes_postavka_dobave DROP CONSTRAINT mes_post_dob_kol_ck;
ALTER TABLE mes_postavka_dobave DROP CONSTRAINT mes_post_dob_cen_ck;
ALTER TABLE mes_postavka_dobave DROP CONSTRAINT mes_post_dob_skp_ck;

-- 6) RAČUN
ALTER TABLE mes_racun           DROP CONSTRAINT mes_racun_status_ck;
ALTER TABLE mes_racun           DROP CONSTRAINT mes_racun_doc_tip_ck;

-- 7) POSTAVKA RAČUNA
ALTER TABLE mes_postavka_racun  DROP CONSTRAINT mes_post_rac_xor_ck;
ALTER TABLE mes_postavka_racun  DROP CONSTRAINT mes_post_rac_kol_ck;
ALTER TABLE mes_postavka_racun  DROP CONSTRAINT mes_post_rac_cena_ck;
ALTER TABLE mes_postavka_racun  DROP CONSTRAINT mes_post_rac_pop_ck;
ALTER TABLE mes_postavka_racun  DROP CONSTRAINT mes_post_rac_skp_ck;

-- 8) PRAŠIČI
ALTER TABLE mes_prasic          DROP CONSTRAINT mes_pr_teza_prev_ck;
ALTER TABLE mes_prasic          DROP CONSTRAINT mes_pr_status_ck;

-- 9) KLANJE
ALTER TABLE mes_klanje_prasic   DROP CONSTRAINT mes_kp_teza_ck;

-- 10) SERIJE
ALTER TABLE mes_serija          DROP CONSTRAINT mes_ser_koda_uk;
ALTER TABLE mes_serija          DROP CONSTRAINT mes_ser_dat_ck;
ALTER TABLE mes_serija          DROP CONSTRAINT mes_ser_kol_ck;
ALTER TABLE mes_serija          DROP CONSTRAINT mes_ser_stsal_ck;
ALTER TABLE mes_serija          DROP CONSTRAINT mes_ser_izvor_ne_sebe_ck;
ALTER TABLE mes_serija          DROP CONSTRAINT mes_ser_status_ck;

-- 11) SERIJA VNOS
ALTER TABLE mes_serija_vnos     DROP CONSTRAINT mes_sv_kol_ck;
ALTER TABLE mes_serija_vnos     DROP CONSTRAINT mes_sv_cena_ck;

-- 12) SERIJA_PRAŠIČ
ALTER TABLE mes_serija_prasic   DROP CONSTRAINT mes_sp_ocena_ck;

-- 13) HRENOVKE
ALTER TABLE mes_hrenovke_serija DROP CONSTRAINT mes_hs_status_ck;
ALTER TABLE mes_hrenovke_serija DROP CONSTRAINT mes_hs_dat_ck;
ALTER TABLE mes_hrenovke_serija DROP CONSTRAINT mes_hs_kol_ck;

-- 14) ZALOGA
ALTER TABLE mes_zaloga          DROP CONSTRAINT mes_zal_kd_ne0_ck;
ALTER TABLE mes_zaloga          DROP CONSTRAINT mes_zal_tip_ck;

-- 15) ZALOGA TRAJNA
ALTER TABLE mes_zaloga_trajna   DROP CONSTRAINT mes_zt_kol_ck;
