/* ============================================================
   TESTNE POIZVEDBE – MESNINE MODEL (Oracle)
   ============================================================ */


-- 1) SEZNAM VSEH IZDELKOV Z TRENUTNO VELJAVNO CENO
--    Prikaže vse aktivne izdelke in njihovo ceno, ki je danes veljavna.
-- ------------------------------------------------------------
SELECT
  i.izdelekid,
  i.ime                          AS izdelek,
  i.vrsta_izdelka,
  me.koda                        AS enota,
  c.cena,
  c.veljavna_od,
  c.veljavna_do
FROM mes_izdelek i
JOIN mes_merilna_enota me ON me.merilna_enota_id = i.merilna_enota_id
LEFT JOIN mes_cena_izdelka c
  ON  c.izdelekid  = i.izdelekid
  AND c.veljavna_od <= TRUNC(SYSDATE)
  AND (c.veljavna_do IS NULL OR c.veljavna_do >= TRUNC(SYSDATE))
WHERE i.aktiven_yn = 1
ORDER BY i.vrsta_izdelka, i.ime;


-- 2) PREGLED ZALOGE PO IZDELKIH
--    Sešteje vse kol_delta za vsak izdelek – prikaže trenutno stanje zaloge.
-- ------------------------------------------------------------
SELECT
  i.ime                          AS izdelek,
  i.vrsta_izdelka,
  me.koda                        AS enota,
  SUM(z.kol_delta)               AS zaloga_skupaj
FROM mes_zaloga z
JOIN mes_izdelek i  ON i.izdelekid = z.izdelekid
JOIN mes_merilna_enota me ON me.merilna_enota_id = i.merilna_enota_id
GROUP BY i.ime, i.vrsta_izdelka, me.koda
ORDER BY i.vrsta_izdelka, i.ime;


-- 3) RAČUNI S SKUPNIM ZNESKOM PO STRANKI
--    Za vsak račun prikaže stranko, datum, status in vsoto vrstic.
-- ------------------------------------------------------------
SELECT
  r.racun_st,
  r.doc_tip,
  r.datum,
  r.status,
  s.ime                          AS stranka,
  mp.ime                         AS metoda_placila,
  SUM(pr.vrstica_skupaj)         AS skupaj_eur
FROM mes_racun r
JOIN mes_stranka        s  ON s.strankaid         = r.strankaid
JOIN mes_metoda_placila mp ON mp.metoda_placila_id = r.metoda_placila_id
LEFT JOIN mes_postavka_racun pr
  ON pr.racunid = r.racunid
GROUP BY r.racun_st, r.doc_tip, r.datum, r.status, s.ime, mp.ime
ORDER BY r.datum, r.racun_st;


-- 4) DOBAVE Z DOBAVITELJEM IN VSOTO POSTAVK
--    Prikaže vsako dobavo, od koga je prišla in skupno vrednost.
-- ------------------------------------------------------------
SELECT
  d.st_dobave,
  d.datum,
  d.status,
  dob.ime                        AS dobavitelj,
  COUNT(pd.postavka_dobaveid)    AS st_postavk,
  SUM(pd.skupaj)                 AS vrednost_eur
FROM mes_dobava d
JOIN mes_dobavitelj dob ON dob.dobaviteljid = d.dobaviteljid
LEFT JOIN mes_postavka_dobave pd ON pd.dobavaid = d.dobavaid
GROUP BY d.st_dobave, d.datum, d.status, dob.ime
ORDER BY d.datum;


-- 6) SERIJE POVEZANE Z DOLOČENIM KLANJEM (APEX: P63_KLANJEID)
--    Prikaže vse serije in izdelke, ki so bili narejeni iz prašičev tega klanja.
-- ------------------------------------------------------------
SELECT DISTINCT s.serijaid,
       s.koda AS koda_serije,
       s.datum_zac,
       s.status,
       i.ime AS ime_izdelka
FROM mes_klanje_prasic kp
JOIN mes_prasic p ON kp.prasicid = p.prasicid
JOIN mes_serija_prasic sp ON sp.prasicid = p.prasicid
JOIN mes_serija s ON sp.serijaid = s.serijaid
JOIN mes_izdelek i ON s.izdelekid = i.izdelekid
WHERE kp.klanjeid = :P63_KLANJEID;


-- 5) GIBANJA ZALOGE (LEDGER) ZA POSAMEZEN IZDELEK
--    Prikaže kronološki pregled vseh +/- gibanj po izdelku.
-- ------------------------------------------------------------
SELECT
  z.datum_gibanja,
  i.ime                          AS izdelek,
  z.tip_gibanja,
  z.kol_delta,
  z.opomba
FROM mes_zaloga z
JOIN mes_izdelek i ON i.izdelekid = z.izdelekid
ORDER BY z.datum_gibanja, i.ime, z.zalogaid;
