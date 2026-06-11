/* ============================================================
   TESTNI PODATKI – MESNINE MODEL
   Predpostavke:
   - uporabljaš trenutno verzijo MES_POSTAVKA_DOBAVE z IZDELEKID
   - zaloga za začimbe nastaja prek triggerja na MES_POSTAVKA_DOBAVE
   - poraba začimb nastaja prek triggerja na MES_SERIJA_VNOS
   - zaloga za meso / hrenovke se po tvoji logiki doda ročno v MES_ZALOGA
   ============================================================ */

---------------------------------------------------------------
-- 1) Šifranti
---------------------------------------------------------------
INSERT INTO mes_merilna_enota (merilna_enota_id, koda, ime, tip, aktiven_yn)
VALUES (1, 'KG', 'Kilogram', 'MASA', 1);

INSERT INTO mes_merilna_enota (merilna_enota_id, koda, ime, tip, aktiven_yn)
VALUES (2, 'KOS', 'Kos', 'KOS', 1);

INSERT INTO mes_merilna_enota (merilna_enota_id, koda, ime, tip, aktiven_yn)
VALUES (3, 'L', 'Liter', 'VOLUMEN', 1);


INSERT INTO mes_posta (postna_st, ime) VALUES (1000, 'Ljubljana');
INSERT INTO mes_posta (postna_st, ime) VALUES (2000, 'Maribor');
INSERT INTO mes_posta (postna_st, ime) VALUES (3000, 'Celje');
INSERT INTO mes_posta (postna_st, ime) VALUES (3210, 'Slovenske Konjice');
INSERT INTO mes_posta (postna_st, ime) VALUES (8000, 'Novo mesto');


INSERT INTO mes_metoda_placila (metoda_placila_id, koda, ime, aktivna_yn)
VALUES (1, 'GOTOVINA', 'Gotovina', 1);

INSERT INTO mes_metoda_placila (metoda_placila_id, koda, ime, aktivna_yn)
VALUES (2, 'KARTICA', 'Kartica', 1);

INSERT INTO mes_metoda_placila (metoda_placila_id, koda, ime, aktivna_yn)
VALUES (3, 'NAKAZILO', 'Bančno nakazilo', 1);


---------------------------------------------------------------
-- 2) Izdelki
---------------------------------------------------------------
INSERT INTO mes_izdelek (izdelekid, ime, vrsta_izdelka, aktiven_yn, merilna_enota_id, obstojnost_dni)
VALUES (1, 'Svinjski vrat', 'SVEZE_MESO', 1, 1, 7);

INSERT INTO mes_izdelek (izdelekid, ime, vrsta_izdelka, aktiven_yn, merilna_enota_id, obstojnost_dni)
VALUES (2, 'Svinjska ribca', 'SVEZE_MESO', 1, 1, 6);

INSERT INTO mes_izdelek (izdelekid, ime, vrsta_izdelka, aktiven_yn, merilna_enota_id, obstojnost_dni)
VALUES (3, 'Dimljena slanina', 'SVEZE_MESO', 1, 1, 14);

INSERT INTO mes_izdelek (izdelekid, ime, vrsta_izdelka, aktiven_yn, merilna_enota_id, obstojnost_dni)
VALUES (4, 'Hrenovke klasične', 'HRENOVKA', 1, 1, 10);

INSERT INTO mes_izdelek (izdelekid, ime, vrsta_izdelka, aktiven_yn, merilna_enota_id, obstojnost_dni)
VALUES (5, 'Hrenovke s sirom', 'HRENOVKA', 1, 1, 10);

INSERT INTO mes_izdelek (izdelekid, ime, vrsta_izdelka, aktiven_yn, merilna_enota_id, obstojnost_dni)
VALUES (6, 'Sol', 'ZACIMBA', 1, 1, 365);

INSERT INTO mes_izdelek (izdelekid, ime, vrsta_izdelka, aktiven_yn, merilna_enota_id, obstojnost_dni)
VALUES (7, 'Črni poper', 'ZACIMBA', 1, 1, 365);

INSERT INTO mes_izdelek (izdelekid, ime, vrsta_izdelka, aktiven_yn, merilna_enota_id, obstojnost_dni)
VALUES (8, 'Česen v prahu', 'ZACIMBA', 1, 1, 365);


---------------------------------------------------------------
-- 3) Cenik
---------------------------------------------------------------
INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
VALUES (1, DATE '2026-01-01', NULL, 9.80, 1);

INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
VALUES (2, DATE '2026-01-01', NULL, 11.90, 2);

INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
VALUES (3, DATE '2026-01-01', NULL, 13.50, 3);

INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
VALUES (4, DATE '2026-01-01', NULL, 7.20, 4);

INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
VALUES (5, DATE '2026-01-01', NULL, 8.40, 5);

INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
VALUES (6, DATE '2026-01-01', NULL, 0.90, 6);

INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
VALUES (7, DATE '2026-01-01', NULL, 12.50, 7);

INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
VALUES (8, DATE '2026-01-01', NULL, 8.70, 8);


---------------------------------------------------------------
-- 4) Partnerji
---------------------------------------------------------------
INSERT INTO mes_dobavitelj (dobaviteljid, ime, kraj, telefon, aktiven_yn, postna_st)
VALUES (1, 'Kmetija Novak', 'Slovenske Konjice', '031111111', 1, 3210);

INSERT INTO mes_dobavitelj (dobaviteljid, ime, kraj, telefon, aktiven_yn, postna_st)
VALUES (2, 'Začimbe Plus d.o.o.', 'Ljubljana', '031222222', 1, 1000);

INSERT INTO mes_dobavitelj (dobaviteljid, ime, kraj, telefon, aktiven_yn, postna_st)
VALUES (3, 'Mesna industrija Vzhod d.o.o.', 'Maribor', '031333333', 1, 2000);

INSERT INTO mes_dobavitelj (dobaviteljid, ime, kraj, telefon, aktiven_yn, postna_st)
VALUES (4, 'Polnilnica Savinja d.o.o.', 'Celje', '031444444', 1, 3000);


INSERT INTO mes_stranka (strankaid, ime, davcna_st, kraj, telefon, email, aktiven_yn, postna_st)
VALUES (1, 'Gostilna Pri lipi', 'SI10000001', 'Ljubljana', '040111111', 'lipa@example.si', 1, 1000);

INSERT INTO mes_stranka (strankaid, ime, davcna_st, kraj, telefon, email, aktiven_yn, postna_st)
VALUES (2, 'Trgovina Mesarček', 'SI10000002', 'Maribor', '040222222', 'mesarcek@example.si', 1, 2000);

INSERT INTO mes_stranka (strankaid, ime, davcna_st, kraj, telefon, email, aktiven_yn, postna_st)
VALUES (3, 'Restavracija Most', 'SI10000003', 'Celje', '040333333', 'most@example.si', 1, 3000);

INSERT INTO mes_stranka (strankaid, ime, davcna_st, kraj, telefon, email, aktiven_yn, postna_st)
VALUES (4, 'Mini market Tina', 'SI10000004', 'Novo mesto', '040444444', 'tina@example.si', 1, 8000);


---------------------------------------------------------------
-- 5) Dobave začimb
---------------------------------------------------------------
INSERT INTO mes_dobava (dobavaid, datum, st_dobave, status, opomba, dobaviteljid)
VALUES (1, DATE '2026-02-01', 'DOB-2026-001', 'OBJAVLJENA', 'Prva februarska dobava začimb.', 2);

INSERT INTO mes_dobava (dobavaid, datum, st_dobave, status, opomba, dobaviteljid)
VALUES (2, DATE '2026-02-15', 'DOB-2026-002', 'OBJAVLJENA', 'Dopolnitev zaloge začimb.', 2);

INSERT INTO mes_dobava (dobavaid, datum, st_dobave, status, opomba, dobaviteljid)
VALUES (3, DATE '2026-03-01', 'DOB-2026-003', 'DELNA', 'Tretja dobava začimb.', 2);


-- Ta tabela predvideva tvojo novo verzijo: MES_POSTAVKA_DOBAVE vsebuje tudi IZDELEKID.
INSERT INTO mes_postavka_dobave
  (postavka_dobaveid, vrstica_st, kolicina, cena_na_enoto, skupaj, opomba, dobavaid, izdelekid)
VALUES
  (1, 1, 25, 0.90, NULL, 'Sol 25 kg', 1, 6);

INSERT INTO mes_postavka_dobave
  (postavka_dobaveid, vrstica_st, kolicina, cena_na_enoto, skupaj, opomba, dobavaid, izdelekid)
VALUES
  (2, 2, 10, 12.50, NULL, 'Črni poper 10 kg', 1, 7);

INSERT INTO mes_postavka_dobave
  (postavka_dobaveid, vrstica_st, kolicina, cena_na_enoto, skupaj, opomba, dobavaid, izdelekid)
VALUES
  (3, 3, 8, 8.70, NULL, 'Česen v prahu 8 kg', 1, 8);

INSERT INTO mes_postavka_dobave
  (postavka_dobaveid, vrstica_st, kolicina, cena_na_enoto, skupaj, opomba, dobavaid, izdelekid)
VALUES
  (4, 1, 20, 0.95, NULL, 'Sol 20 kg', 2, 6);

INSERT INTO mes_postavka_dobave
  (postavka_dobaveid, vrstica_st, kolicina, cena_na_enoto, skupaj, opomba, dobavaid, izdelekid)
VALUES
  (5, 2, 6, 12.80, NULL, 'Črni poper 6 kg', 2, 7);

INSERT INTO mes_postavka_dobave
  (postavka_dobaveid, vrstica_st, kolicina, cena_na_enoto, skupaj, opomba, dobavaid, izdelekid)
VALUES
  (6, 1, 5, 8.90, NULL, 'Česen v prahu 5 kg', 3, 8);


---------------------------------------------------------------
-- 6) Prašiči in klanje
---------------------------------------------------------------
INSERT INTO mes_prasic_skupina (prasic_skupinaid, koda, datum_dobave, opomba, dobaviteljid)
VALUES (1, 'PS-2026-001', DATE '2026-01-10', 'Prva skupina prašičev.', 1);

INSERT INTO mes_prasic_skupina (prasic_skupinaid, koda, datum_dobave, opomba, dobaviteljid)
VALUES (2, 'PS-2026-002', DATE '2026-02-05', 'Druga skupina prašičev.', 1);


INSERT INTO mes_prasic (prasicid, koda, teza_pri_prevzemu_kg, status, opomba, prasic_skupinaid)
VALUES (1, 'PR-2026-001', 118, 'ZAKLAN', 'Uporabljen v prvem klanju.', 1);

INSERT INTO mes_prasic (prasicid, koda, teza_pri_prevzemu_kg, status, opomba, prasic_skupinaid)
VALUES (2, 'PR-2026-002', 121, 'ZAKLAN', 'Uporabljen v prvem klanju.', 1);

INSERT INTO mes_prasic (prasicid, koda, teza_pri_prevzemu_kg, status, opomba, prasic_skupinaid)
VALUES (3, 'PR-2026-003', 116, 'ZAKLAN', 'Uporabljen v prvem klanju.', 1);

INSERT INTO mes_prasic (prasicid, koda, teza_pri_prevzemu_kg, status, opomba, prasic_skupinaid)
VALUES (4, 'PR-2026-004', 123, 'ZAKLAN', 'Uporabljen v drugem klanju.', 2);

INSERT INTO mes_prasic (prasicid, koda, teza_pri_prevzemu_kg, status, opomba, prasic_skupinaid)
VALUES (5, 'PR-2026-005', 119, 'ZAKLAN', 'Uporabljen v drugem klanju.', 2);

INSERT INTO mes_prasic (prasicid, koda, teza_pri_prevzemu_kg, status, opomba, prasic_skupinaid)
VALUES (6, 'PR-2026-006', 115, 'V_REJI', 'Ostane za kasneje.', 2);


INSERT INTO mes_klanje (klanjeid, datum_klanja, doc_st, opomba)
VALUES (1, DATE '2026-02-10', 'KLA-2026-001', 'Prvo klanje.');

INSERT INTO mes_klanje (klanjeid, datum_klanja, doc_st, opomba)
VALUES (2, DATE '2026-03-03', 'KLA-2026-002', 'Drugo klanje.');


INSERT INTO mes_klanje_prasic (teza_trupla_kg, klanjeid, prasicid)
VALUES (86, 1, 1);

INSERT INTO mes_klanje_prasic (teza_trupla_kg, klanjeid, prasicid)
VALUES (88, 1, 2);

INSERT INTO mes_klanje_prasic (teza_trupla_kg, klanjeid, prasicid)
VALUES (84, 1, 3);

INSERT INTO mes_klanje_prasic (teza_trupla_kg, klanjeid, prasicid)
VALUES (90, 2, 4);

INSERT INTO mes_klanje_prasic (teza_trupla_kg, klanjeid, prasicid)
VALUES (87, 2, 5);


---------------------------------------------------------------
-- 7) Serije
---------------------------------------------------------------
INSERT INTO mes_serija
  (serijaid, koda, datum_zac, datum_kon, kolicina_zac, kolicina_kon, status, opomba, st_sal_kos, izdelekid, izvor_serijaid)
VALUES
  (1, 'S26-0001', DATE '2026-02-11', DATE '2026-02-12', 40, 38, 'KONCANA',
   'Serija dimljene slanine iz prvega klanja.', NULL, 3, NULL);

INSERT INTO mes_serija
  (serijaid, koda, datum_zac, datum_kon, kolicina_zac, kolicina_kon, status, opomba, st_sal_kos, izdelekid, izvor_serijaid)
VALUES
  (2, 'S26-0002', DATE '2026-03-04', DATE '2026-03-05', 35, 33, 'KONCANA',
   'Druga serija dimljene slanine.', NULL, 3, NULL);

INSERT INTO mes_serija
  (serijaid, koda, datum_zac, datum_kon, kolicina_zac, kolicina_kon, status, opomba, st_sal_kos, izdelekid, izvor_serijaid)
VALUES
  (3, 'S26-0003', DATE '2026-03-05', DATE '2026-03-06', 20, 19, 'KONCANA',
   'Manjša serija ribce.', NULL, 2, NULL);


INSERT INTO mes_serija_prasic (opomba, ocenjeno_kg, prasicid, serijaid)
VALUES ('Prispevek v serijo 1', 13, 1, 1);

INSERT INTO mes_serija_prasic (opomba, ocenjeno_kg, prasicid, serijaid)
VALUES ('Prispevek v serijo 1', 12, 2, 1);

INSERT INTO mes_serija_prasic (opomba, ocenjeno_kg, prasicid, serijaid)
VALUES ('Prispevek v serijo 2', 11, 4, 2);

INSERT INTO mes_serija_prasic (opomba, ocenjeno_kg, prasicid, serijaid)
VALUES ('Prispevek v serijo 2', 10, 5, 2);

INSERT INTO mes_serija_prasic (opomba, ocenjeno_kg, prasicid, serijaid)
VALUES ('Prispevek v serijo 3', 9, 3, 3);


---------------------------------------------------------------
-- 8) Poraba začimb po serijah
--    To sproži trigger za minus v MES_ZALOGA.
---------------------------------------------------------------
INSERT INTO mes_serija_vnos
  (serija_vnosid, kol_porabe, cena_komada, cena_porabe, opomba, postavka_dobaveid, serijaid, izdelekid)
VALUES
  (1, 5, 0.90, NULL, 'Poraba soli za serijo 1', 1, 1, 6);

INSERT INTO mes_serija_vnos
  (serija_vnosid, kol_porabe, cena_komada, cena_porabe, opomba, postavka_dobaveid, serijaid, izdelekid)
VALUES
  (2, 1.2, 12.50, NULL, 'Poraba popra za serijo 1', 2, 1, 7);

INSERT INTO mes_serija_vnos
  (serija_vnosid, kol_porabe, cena_komada, cena_porabe, opomba, postavka_dobaveid, serijaid, izdelekid)
VALUES
  (3, 0.8, 8.70, NULL, 'Poraba česna za serijo 1', 3, 1, 8);

INSERT INTO mes_serija_vnos
  (serija_vnosid, kol_porabe, cena_komada, cena_porabe, opomba, postavka_dobaveid, serijaid, izdelekid)
VALUES
  (4, 4, 0.95, NULL, 'Poraba soli za serijo 2', 4, 2, 6);

INSERT INTO mes_serija_vnos
  (serija_vnosid, kol_porabe, cena_komada, cena_porabe, opomba, postavka_dobaveid, serijaid, izdelekid)
VALUES
  (5, 1, 12.80, NULL, 'Poraba popra za serijo 2', 5, 2, 7);

INSERT INTO mes_serija_vnos
  (serija_vnosid, kol_porabe, cena_komada, cena_porabe, opomba, postavka_dobaveid, serijaid, izdelekid)
VALUES
  (6, 0.5, 8.90, NULL, 'Poraba česna za serijo 2', 6, 2, 8);

INSERT INTO mes_serija_vnos
  (serija_vnosid, kol_porabe, cena_komada, cena_porabe, opomba, postavka_dobaveid, serijaid, izdelekid)
VALUES
  (7, 2, 0.95, NULL, 'Poraba soli za serijo 3', 4, 3, 6);


---------------------------------------------------------------
-- 9) Hrenovke
---------------------------------------------------------------
INSERT INTO mes_hrenovke_serija
  (hrenovke_serijaid, koda, datum_poslano, datum_prevzema, status, kol_poslano_kg, kol_dobljeno_kg, opomba, dobaviteljid)
VALUES
  (1, 'HS-2026-001', DATE '2026-02-18', DATE '2026-02-20', 'VRNJENO', 55, 50,
   'Klasične hrenovke in del s sirom.', 4);

INSERT INTO mes_hrenovke_serija
  (hrenovke_serijaid, koda, datum_poslano, datum_prevzema, status, kol_poslano_kg, kol_dobljeno_kg, opomba, dobaviteljid)
VALUES
  (2, 'HS-2026-002', DATE '2026-03-06', DATE '2026-03-08', 'VRNJENO', 40, 36,
   'Druga pošiljka hrenovk.', 4);


INSERT INTO mes_izvor_hrenovk (klanjeid, hrenovke_serijaid) VALUES (1, 1);
INSERT INTO mes_izvor_hrenovk (klanjeid, hrenovke_serijaid) VALUES (2, 2);


---------------------------------------------------------------
-- 10) Ročni plusi v zalogo za meso in hrenovke
--     To je po tvoji logiki ročni vnos.
---------------------------------------------------------------
INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (100, DATE '2026-02-12', 'PROIZVODNJA', 40, 'Ročni vnos zaloge za serijo 1 - dimljena slanina.', 3, NULL, 1, NULL, NULL);

INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (101, DATE '2026-03-05', 'PROIZVODNJA', 35, 'Ročni vnos zaloge za serijo 2 - dimljena slanina.', 3, NULL, 2, NULL, NULL);

INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (102, DATE '2026-03-06', 'PROIZVODNJA', 20, 'Ročni vnos zaloge za serijo 3 - ribca.', 2, NULL, 3, NULL, NULL);

INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (103, DATE '2026-02-10', 'PROIZVODNJA', 30, 'Ročni vnos zaloge za svinjski vrat iz klanja 1.', 1, NULL, NULL, NULL, NULL);

INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (104, DATE '2026-03-03', 'PROIZVODNJA', 25, 'Ročni vnos zaloge za svinjski vrat iz klanja 2.', 1, NULL, NULL, NULL, NULL);

INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (105, DATE '2026-02-20', 'PROIZVODNJA', 35, 'Ročni vnos zaloge za hrenovke klasične iz serije HS-2026-001.', 4, NULL, NULL, NULL, NULL);

INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (106, DATE '2026-02-20', 'PROIZVODNJA', 15, 'Ročni vnos zaloge za hrenovke s sirom iz serije HS-2026-001.', 5, NULL, NULL, NULL, NULL);

INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (107, DATE '2026-03-08', 'PROIZVODNJA', 22, 'Ročni vnos zaloge za hrenovke klasične iz serije HS-2026-002.', 4, NULL, NULL, NULL, NULL);

INSERT INTO mes_zaloga
  (zalogaid, datum_gibanja, tip_gibanja, kol_delta, opomba, izdelekid, postavka_dobaveid, serijaid, izdelekid_p, racunid_p)
VALUES
  (108, DATE '2026-03-08', 'PROIZVODNJA', 14, 'Ročni vnos zaloge za hrenovke s sirom iz serije HS-2026-002.', 5, NULL, NULL, NULL, NULL);


---------------------------------------------------------------
-- 11) Računi
---------------------------------------------------------------
INSERT INTO mes_racun
  (racunid, doc_tip, racun_st, datum, status, opomba, izvor_racun, metoda_placila_id, strankaid)
VALUES
  (1, 'RACUN', 'RAC-2026-001', DATE '2026-02-21', 'IZDAN', 'Prva prodaja po vrnitvi hrenovk.', NULL, 2, 1);

INSERT INTO mes_racun
  (racunid, doc_tip, racun_st, datum, status, opomba, izvor_racun, metoda_placila_id, strankaid)
VALUES
  (2, 'RACUN', 'RAC-2026-002', DATE '2026-02-25', 'PLACAN', 'Dobava trgovini.', NULL, 3, 2);

INSERT INTO mes_racun
  (racunid, doc_tip, racun_st, datum, status, opomba, izvor_racun, metoda_placila_id, strankaid)
VALUES
  (3, 'RACUN', 'RAC-2026-003', DATE '2026-03-07', 'IZDAN', 'Prodaja svežega mesa in slanine.', NULL, 1, 3);

INSERT INTO mes_racun
  (racunid, doc_tip, racun_st, datum, status, opomba, izvor_racun, metoda_placila_id, strankaid)
VALUES
  (4, 'RACUN', 'RAC-2026-004', DATE '2026-03-10', 'PLACAN', 'Večja prodaja hrenovk.', NULL, 2, 4);

INSERT INTO mes_racun
  (racunid, doc_tip, racun_st, datum, status, opomba, izvor_racun, metoda_placila_id, strankaid)
VALUES
  (5, 'RACUN', 'RAC-2026-005', DATE '2026-03-12', 'IZDAN', 'Dodatna prodaja mesa.', NULL, 2, 1);


---------------------------------------------------------------
-- 12) Postavke računov
--     Te vrstice sprožijo preverjanje zaloge in minus v MES_ZALOGA.
---------------------------------------------------------------
INSERT INTO mes_postavka_racun
  (vrstica_st, kolicina, cena_kosa, kolicinski_popust, vrstica_skupaj, serijaid, klanjeid, hrenovke_serijaid, izdelekid, racunid)
VALUES
  (1, 8, 13.50, 0, NULL, 1, NULL, NULL, 3, 1);

INSERT INTO mes_postavka_racun
  (vrstica_st, kolicina, cena_kosa, kolicinski_popust, vrstica_skupaj, serijaid, klanjeid, hrenovke_serijaid, izdelekid, racunid)
VALUES
  (2, 12, 7.20, 3, NULL, NULL, NULL, 1, 4, 1);

INSERT INTO mes_postavka_racun
  (vrstica_st, kolicina, cena_kosa, kolicinski_popust, vrstica_skupaj, serijaid, klanjeid, hrenovke_serijaid, izdelekid, racunid)
VALUES
  (1, 2, 11.90, 0, NULL, NULL, 1, NULL, 2, 2);

INSERT INTO mes_postavka_racun
  (vrstica_st, kolicina, cena_kosa, kolicinski_popust, vrstica_skupaj, serijaid, klanjeid, hrenovke_serijaid, izdelekid, racunid)
VALUES
  (2, 10, 8.40, 2, NULL, NULL, NULL, 1, 5, 2);

INSERT INTO mes_postavka_racun
  (vrstica_st, kolicina, cena_kosa, kolicinski_popust, vrstica_skupaj, serijaid, klanjeid, hrenovke_serijaid, izdelekid, racunid)
VALUES
  (1, 7, 9.80, 0, NULL, NULL, 2, NULL, 1, 3);

INSERT INTO mes_postavka_racun
  (vrstica_st, kolicina, cena_kosa, kolicinski_popust, vrstica_skupaj, serijaid, klanjeid, hrenovke_serijaid, izdelekid, racunid)
VALUES
  (2, 5, 13.50, 0, NULL, 2, NULL, NULL, 3, 3);

INSERT INTO mes_postavka_racun
  (vrstica_st, kolicina, cena_kosa, kolicinski_popust, vrstica_skupaj, serijaid, klanjeid, hrenovke_serijaid, izdelekid, racunid)
VALUES
  (1, 8, 7.20, 0, NULL, NULL, NULL, 2, 4, 4);

INSERT INTO mes_postavka_racun
  (vrstica_st, kolicina, cena_kosa, kolicinski_popust, vrstica_skupaj, serijaid, klanjeid, hrenovke_serijaid, izdelekid, racunid)
VALUES
  (1, 6, 9.80, 0, NULL, NULL, 1, NULL, 1, 5);


COMMIT;
