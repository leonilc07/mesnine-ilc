/* ============================================================
   ORACLE VIEWI – MESNINE MODEL (za APEX SQL Workshop)
   Namen: lažja izdelava APEX reportov, dashboardov in pregledov
   ============================================================ */

-- vw_mes_izdelek_osnovno
CREATE OR REPLACE VIEW vw_mes_izdelek_osnovno AS
SELECT i.izdelekid,
       i.ime AS izdelek_ime,
       i.vrsta_izdelka,
       i.aktiven_yn,
       i.obstojnost_dni,
       me.merilna_enota_id,
       me.koda AS merilna_enota_koda,
       me.ime  AS merilna_enota_ime,
       me.tip  AS merilna_enota_tip
FROM mes_izdelek i
JOIN mes_merilna_enota me
  ON me.merilna_enota_id = i.merilna_enota_id;

-- vw_mes_izdelek_cena
CREATE OR REPLACE VIEW vw_mes_izdelek_cena AS
SELECT i.izdelekid,
       i.ime AS izdelek_ime,
       c.cena_izdelkaid,
       c.veljavna_od,
       c.veljavna_do,
       c.cena,
       CASE
         WHEN c.veljavna_od <= TRUNC(SYSDATE)
          AND (c.veljavna_do IS NULL OR c.veljavna_do >= TRUNC(SYSDATE))
         THEN 1 ELSE 0
       END AS trenutno_veljavna_yn
FROM mes_izdelek i
JOIN mes_cena_izdelka c
  ON c.izdelekid = i.izdelekid;

-- vw_mes_dobava_pregled
CREATE OR REPLACE VIEW vw_mes_dobava_pregled AS
SELECT d.dobavaid,
       d.datum,
       d.st_dobave,
       d.status,
       d.opomba,
       dob.dobaviteljid,
       dob.ime AS dobavitelj_ime,
       COUNT(pd.postavka_dobaveid) AS stevilo_postavk,
       NVL(SUM(NVL(pd.skupaj, pd.kolicina * pd.cena_na_enoto)), 0) AS znesek_skupaj
FROM mes_dobava d
JOIN mes_dobavitelj dob
  ON dob.dobaviteljid = d.dobaviteljid
LEFT JOIN mes_postavka_dobave pd
  ON pd.dobavaid = d.dobavaid
GROUP BY d.dobavaid, d.datum, d.st_dobave, d.status, d.opomba,
         dob.dobaviteljid, dob.ime;

-- vw_mes_racun_pregled
CREATE OR REPLACE VIEW vw_mes_racun_pregled AS
SELECT r.racunid,
       r.doc_tip,
       r.racun_st,
       r.datum,
       r.status,
       r.opomba,
       r.izvor_racun,
       mp.metoda_placila_id,
       mp.ime AS metoda_placila_ime,
       s.strankaid,
       s.ime AS stranka_ime,
       COUNT(pr.izdelekid) AS stevilo_postavk,
       NVL(SUM(NVL(pr.vrstica_skupaj,
                   pr.kolicina * pr.cena_kosa - NVL(pr.kolicinski_popust, 0))), 0) AS znesek_skupaj
FROM mes_racun r
JOIN mes_metoda_placila mp
  ON mp.metoda_placila_id = r.metoda_placila_id
JOIN mes_stranka s
  ON s.strankaid = r.strankaid
LEFT JOIN mes_postavka_racun pr
  ON pr.racunid = r.racunid
GROUP BY r.racunid, r.doc_tip, r.racun_st, r.datum, r.status, r.opomba, r.izvor_racun,
         mp.metoda_placila_id, mp.ime, s.strankaid, s.ime;

-- vw_mes_postavka_dobave_izdelek
CREATE OR REPLACE VIEW vw_mes_postavka_dobave_izdelek AS
SELECT pd.postavka_dobaveid,
       pd.dobavaid,
       pd.vrstica_st,
       pd.kolicina,
       pd.cena_na_enoto,
       NVL(pd.skupaj, pd.kolicina * pd.cena_na_enoto) AS skupaj,
       pd.opomba,
       pd.izdelekid,
       i.ime             AS izdelek_ime,
       i.vrsta_izdelka
FROM mes_postavka_dobave pd
JOIN mes_izdelek i
  ON i.izdelekid = pd.izdelekid;

-- vw_mes_nabava_po_dobavi
CREATE OR REPLACE VIEW vw_mes_nabava_po_dobavi AS
SELECT d.dobavaid,
       d.st_dobave,
       d.datum,
       dob.ime AS dobavitelj_ime,
       pdi.postavka_dobaveid,
       pdi.vrstica_st,
       pdi.izdelekid,
       pdi.izdelek_ime,
       pdi.kolicina,
       pdi.cena_na_enoto,
       pdi.skupaj
FROM mes_dobava d
JOIN mes_dobavitelj dob
  ON dob.dobaviteljid = d.dobaviteljid
JOIN vw_mes_postavka_dobave_izdelek pdi
  ON pdi.dobavaid = d.dobavaid;

-- vw_mes_zaloga_gibanja
CREATE OR REPLACE VIEW vw_mes_zaloga_gibanja AS
SELECT z.zalogaid,
       z.datum_gibanja,
       z.tip_gibanja,
       z.kol_delta,
       z.opomba,
       z.izdelekid,
       i.ime AS izdelek_ime,
       z.postavka_dobaveid,
       z.serijaid,
       s.koda AS serija_koda,
       z.izdelekid_p,
       z.racunid_p
FROM mes_zaloga z
JOIN mes_izdelek i
  ON i.izdelekid = z.izdelekid
LEFT JOIN mes_serija s
  ON s.serijaid = z.serijaid;

-- vw_mes_trenutna_zaloga_izdelek
CREATE OR REPLACE VIEW vw_mes_trenutna_zaloga_izdelek AS
SELECT zt.izdelekid,
       i.ime             AS izdelek_ime,
       i.vrsta_izdelka,
       me.koda           AS merilna_enota,
       zt.trenutna_kolicina,
       zt.zadnje_gibanje
FROM mes_zaloga_trajna zt
JOIN mes_izdelek i
  ON i.izdelekid = zt.izdelekid
JOIN mes_merilna_enota me
  ON me.merilna_enota_id = i.merilna_enota_id;

-- vw_mes_trenutna_zaloga_serija
CREATE OR REPLACE VIEW vw_mes_trenutna_zaloga_serija AS
SELECT z.izdelekid,
       i.ime AS izdelek_ime,
       z.serijaid,
       s.koda AS serija_koda,
       s.status AS serija_status,
       s.datum_zac,
       s.datum_kon,
       SUM(z.kol_delta) AS trenutna_kolicina
FROM mes_zaloga z
JOIN mes_izdelek i
  ON i.izdelekid = z.izdelekid
LEFT JOIN mes_serija s
  ON s.serijaid = z.serijaid
GROUP BY z.izdelekid, i.ime, z.serijaid, s.koda, s.status, s.datum_zac, s.datum_kon;

-- vw_mes_prodaja_po_izdelku
CREATE OR REPLACE VIEW vw_mes_prodaja_po_izdelku AS
SELECT pr.izdelekid,
       i.ime AS izdelek_ime,
       i.vrsta_izdelka,
       SUM(pr.kolicina) AS prodana_kolicina,
       SUM(NVL(pr.vrstica_skupaj,
               pr.kolicina * pr.cena_kosa - NVL(pr.kolicinski_popust, 0))) AS promet
FROM mes_postavka_racun pr
JOIN mes_izdelek i
  ON i.izdelekid = pr.izdelekid
GROUP BY pr.izdelekid, i.ime, i.vrsta_izdelka;

-- vw_mes_prodaja_po_racunu
CREATE OR REPLACE VIEW vw_mes_prodaja_po_racunu AS
SELECT r.racunid,
       r.racun_st,
       r.datum,
       s.ime AS stranka_ime,
       pr.izdelekid,
       i.ime AS izdelek_ime,
       pr.vrstica_st,
       pr.kolicina,
       pr.cena_kosa,
       pr.kolicinski_popust,
       NVL(pr.vrstica_skupaj,
           pr.kolicina * pr.cena_kosa - NVL(pr.kolicinski_popust, 0)) AS vrstica_skupaj
FROM mes_racun r
JOIN mes_stranka s
  ON s.strankaid = r.strankaid
JOIN mes_postavka_racun pr
  ON pr.racunid = r.racunid
JOIN mes_izdelek i
  ON i.izdelekid = pr.izdelekid;

-- vw_mes_serija_pregled
CREATE OR REPLACE VIEW vw_mes_serija_pregled AS
SELECT s.serijaid,
       s.koda AS serija_koda,
       s.datum_zac,
       s.datum_kon,
       s.kolicina_zac,
       s.kolicina_kon,
       s.status,
       s.opomba,
       s.st_sal_kos,
       s.izdelekid,
       i.ime AS izdelek_ime,
       s.izvor_serijaid,
       si.koda AS izvor_serija_koda
FROM mes_serija s
JOIN mes_izdelek i
  ON i.izdelekid = s.izdelekid
LEFT JOIN mes_serija si
  ON si.serijaid = s.izvor_serijaid;

-- vw_mes_prasic_pregled
CREATE OR REPLACE VIEW vw_mes_prasic_pregled AS
SELECT p.prasicid,
       p.koda AS prasic_koda,
       p.teza_pri_prevzemu_kg,
       p.status,
       p.opomba,
       ps.prasic_skupinaid,
       ps.koda AS skupina_koda,
       ps.datum_dobave,
       d.ime AS dobavitelj_ime
FROM mes_prasic p
JOIN mes_prasic_skupina ps
  ON ps.prasic_skupinaid = p.prasic_skupinaid
JOIN mes_dobavitelj d
  ON d.dobaviteljid = ps.dobaviteljid;

-- vw_mes_klanje_pregled
CREATE OR REPLACE VIEW vw_mes_klanje_pregled AS
SELECT k.klanjeid,
       k.datum_klanja,
       k.doc_st,
       k.opomba,
       COUNT(kp.prasicid) AS stevilo_prasicev,
       NVL(SUM(kp.teza_trupla_kg), 0) AS skupaj_teza_trupla_kg
FROM mes_klanje k
LEFT JOIN mes_klanje_prasic kp
  ON kp.klanjeid = k.klanjeid
GROUP BY k.klanjeid, k.datum_klanja, k.doc_st, k.opomba;

-- vw_mes_hrenovke_pregled
CREATE OR REPLACE VIEW vw_mes_hrenovke_pregled AS
SELECT hs.hrenovke_serijaid,
       hs.koda,
       hs.datum_poslano,
       hs.datum_prevzema,
       hs.status,
       hs.kol_poslano_kg,
       hs.kol_dobljeno_kg,
       hs.opomba,
       d.ime AS dobavitelj_ime,
       COUNT(ih.klanjeid) AS stevilo_klanj
FROM mes_hrenovke_serija hs
JOIN mes_dobavitelj d
  ON d.dobaviteljid = hs.dobaviteljid
LEFT JOIN mes_izvor_hrenovk ih
  ON ih.hrenovke_serijaid = hs.hrenovke_serijaid
GROUP BY hs.hrenovke_serijaid, hs.koda, hs.datum_poslano, hs.datum_prevzema,
         hs.status, hs.kol_poslano_kg, hs.kol_dobljeno_kg, hs.opomba, d.ime;

-- vw_mes_dashboard_povzetek
CREATE OR REPLACE VIEW vw_mes_dashboard_povzetek AS
SELECT 'STEVILO_IZDELKOV' AS metrika, COUNT(*) AS vrednost
FROM mes_izdelek
UNION ALL
SELECT 'AKTIVNI_IZDELKI', COUNT(*)
FROM mes_izdelek
WHERE NVL(aktiven_yn, 0) = 1
UNION ALL
SELECT 'STEVILO_STRANK', COUNT(*)
FROM mes_stranka
UNION ALL
SELECT 'STEVILO_DOBAVITELJEV', COUNT(*)
FROM mes_dobavitelj
UNION ALL
SELECT 'SKUPNA_ZALOGA_POSTAVK', COUNT(*)
FROM vw_mes_trenutna_zaloga_izdelek
UNION ALL
SELECT 'SKUPNA_KOLICINA_ZALOGE', NVL(SUM(trenutna_kolicina), 0)
FROM vw_mes_trenutna_zaloga_izdelek
UNION ALL
SELECT 'STEVILO_RACUNOV', COUNT(*)
FROM mes_racun
UNION ALL
SELECT 'PROMET_SKUPAJ', NVL(SUM(promet), 0)
FROM vw_mes_prodaja_po_izdelku
UNION ALL
SELECT 'AKTIVNI_PRASICI', COUNT(*)
FROM mes_prasic
WHERE STATUS = 'V_REJI'
UNION ALL
SELECT 'STEVILO_SERIJI', COUNT(*)
FROM mes_serija
WHERE izvor_serijaid IS NULL
UNION ALL
SELECT 'STEVILO_SERJI_HRENOVK', COUNT(*)
FROM mes_hrenovke_serija;