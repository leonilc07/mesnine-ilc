/* ============================================================
   TRIGGERJI ZA APEX SQL WORKSHOP
   
   OPOMBA: Ta datoteka je prilagojena za APEX SQL Workshop.
   Sekvence so v ločeni datoteki: mesnine_sekvence_apex.sql
   ============================================================ */

---------------------------------------------------------------
-- 1) DOBAVA: datum ne sme biti v prihodnosti
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_dobava_dat_trg
  BEFORE INSERT OR UPDATE OF datum ON mes_dobava
  FOR EACH ROW
BEGIN
  IF :NEW.datum > TRUNC(SYSDATE) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Mes_dobava: datum ne sme biti v prihodnosti.');
  END IF;
END;
/

---------------------------------------------------------------
-- 2) POSTAVKA_DOBAVE: samodejni izracun SKUPAJ
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_post_dob_skupaj_trg
  BEFORE INSERT OR UPDATE OF kolicina, cena_na_enoto ON mes_postavka_dobave
  FOR EACH ROW
DECLARE
  v_cena NUMBER;
BEGIN
  IF :NEW.cena_na_enoto IS NULL THEN
    BEGIN
      SELECT cena INTO v_cena
        FROM mes_cena_izdelka
       WHERE izdelekid = :NEW.izdelekid
         AND veljavna_od <= TRUNC(SYSDATE)
         AND (veljavna_do IS NULL OR veljavna_do >= TRUNC(SYSDATE))
       ORDER BY veljavna_od DESC
       FETCH FIRST 1 ROW ONLY;
      :NEW.cena_na_enoto := v_cena;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;
  END IF;

  :NEW.skupaj := NVL(:NEW.kolicina, 0) * NVL(:NEW.cena_na_enoto, 0);
END;
/

---------------------------------------------------------------
-- 3) SERIJA_VNOS: samodejni izracun CENA_PORABE
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_serija_vnos_cena_trg
  BEFORE INSERT OR UPDATE OF kol_porabe, cena_komada ON mes_serija_vnos
  FOR EACH ROW
DECLARE
  v_vrsta VARCHAR2(50);
BEGIN
  -- Za začimbe: samodejno nastavi cena_komada iz drseče cene (če ni ročno vpisana)
  IF :NEW.cena_komada IS NULL THEN
    BEGIN
      SELECT vrsta_izdelka INTO v_vrsta
        FROM mes_izdelek WHERE izdelekid = :NEW.izdelekid;
      IF UPPER(v_vrsta) IN ('ZACIMBA', 'ZACIMBE') THEN
        SELECT cena INTO :NEW.cena_komada
          FROM mes_cena_izdelka
         WHERE izdelekid  = :NEW.izdelekid
           AND veljavna_od = (
                 SELECT MAX(veljavna_od) FROM mes_cena_izdelka
                  WHERE izdelekid   = :NEW.izdelekid
                    AND (veljavna_do IS NULL OR veljavna_do >= TRUNC(SYSDATE))
               );
      END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;
  END IF;

  -- Izračun cena_porabe
  :NEW.cena_porabe := NVL(:NEW.kol_porabe, 0) * NVL(:NEW.cena_komada, 0);
END;
/

---------------------------------------------------------------
-- 4) POSTAVKA_RACUN: samodejni izracun VRSTICA_SKUPAJ + CENA_KOSA
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_post_rac_vsota_trg
  BEFORE INSERT OR UPDATE OF kolicina, cena_kosa, kolicinski_popust, izdelekid ON mes_postavka_racun
  FOR EACH ROW
DECLARE
  v_cena NUMBER;
BEGIN
  -- Če cena_kosa ni podana, jo pridobi iz trenutno veljavne cene izdelka
  IF :NEW.cena_kosa IS NULL THEN
    BEGIN
      SELECT cena INTO v_cena
        FROM mes_cena_izdelka
       WHERE izdelekid = :NEW.izdelekid
         AND veljavna_od <= TRUNC(SYSDATE)
         AND (veljavna_do IS NULL OR veljavna_do >= TRUNC(SYSDATE))
       ORDER BY veljavna_od DESC
       FETCH FIRST 1 ROW ONLY;
      :NEW.cena_kosa := v_cena;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20010, 'Ni veljavne cene za izdelek ID ' || :NEW.izdelekid);
    END;
  END IF;

  -- Izračun vrstica_skupaj
  :NEW.vrstica_skupaj :=
      (NVL(:NEW.kolicina, 0) * NVL(:NEW.cena_kosa, 0))
      - NVL(:NEW.kolicinski_popust, 0);
END;
/


---------------------------------------------------------------
-- 6) POSTAVKA_DOBAVE -> drseča cena za začimbe (brez vpisa v zaloga)
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_post_dob_zaloga_trg
  AFTER INSERT ON mes_postavka_dobave
  FOR EACH ROW
DECLARE
  v_vrsta          mes_izdelek.vrsta_izdelka%TYPE;
  v_stara_cena     NUMBER := 0;
  v_cena_izdelkaid mes_cena_izdelka.cena_izdelkaid%TYPE;
  v_cena_max_plus1 NUMBER;
  v_cena_seq_next  NUMBER;
BEGIN
  BEGIN
    SELECT vrsta_izdelka INTO v_vrsta
      FROM mes_izdelek
     WHERE izdelekid = :NEW.izdelekid;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN;
  END;

  IF UPPER(v_vrsta) IN ('ZACIMBA', 'ZACIMBE') THEN

    -- Pridobi trenutno veljavno ceno
    BEGIN
      SELECT cena INTO v_stara_cena
        FROM mes_cena_izdelka
       WHERE izdelekid = :NEW.izdelekid
         AND veljavna_od = (
               SELECT MAX(veljavna_od) FROM mes_cena_izdelka
                WHERE izdelekid  = :NEW.izdelekid
                  AND (veljavna_do IS NULL OR veljavna_do >= TRUNC(SYSDATE))
             );
    EXCEPTION WHEN NO_DATA_FOUND THEN v_stara_cena := 0;
    END;

    -- Nova cena = zadnja nakupna cena (zaloga ni sledena)
    IF :NEW.cena_na_enoto != v_stara_cena OR v_stara_cena = 0 THEN
      UPDATE mes_cena_izdelka
         SET veljavna_do = TRUNC(SYSDATE) - 1
       WHERE izdelekid  = :NEW.izdelekid
         AND veljavna_do IS NULL;

      -- Sekvenca je lahko za obstoječimi podatki (npr. po seed skripti z ročnimi ID-ji).
      -- V tem primeru rezerviramo naslednji prosti ID in varno vstavimo novo ceno.
      BEGIN
        SELECT NVL(MAX(cena_izdelkaid), 0) + 1
          INTO v_cena_max_plus1
          FROM mes_cena_izdelka;

        SELECT mes_cena_izdelka_id_seq.NEXTVAL
          INTO v_cena_seq_next
          FROM dual;

        v_cena_izdelkaid := GREATEST(v_cena_seq_next, v_cena_max_plus1);

        INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
        VALUES (v_cena_izdelkaid, TRUNC(SYSDATE), NULL, :NEW.cena_na_enoto, :NEW.izdelekid);
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          SELECT NVL(MAX(cena_izdelkaid), 0) + 1
            INTO v_cena_izdelkaid
            FROM mes_cena_izdelka;

          INSERT INTO mes_cena_izdelka (cena_izdelkaid, veljavna_od, veljavna_do, cena, izdelekid)
          VALUES (v_cena_izdelkaid, TRUNC(SYSDATE), NULL, :NEW.cena_na_enoto, :NEW.izdelekid);
      END;
    END IF;

  END IF;
END;
/

---------------------------------------------------------------
-- 7) POSTAVKA_RACUN -> MES_ZALOGA (prodaja - samo serije)
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_post_rac_zaloga_trg
  AFTER INSERT OR UPDATE OF kolicina, izdelekid, serijaid OR DELETE ON mes_postavka_racun
  FOR EACH ROW
DECLARE
  v_zalogaid mes_zaloga.zalogaid%TYPE;

  PROCEDURE dodaj_gibanje (
    p_izdelekid IN mes_zaloga.izdelekid%TYPE,
    p_serijaid  IN mes_zaloga.serijaid%TYPE,
    p_racunid   IN mes_zaloga.racunid_p%TYPE,
    p_delta     IN mes_zaloga.kol_delta%TYPE,
    p_opomba    IN mes_zaloga.opomba%TYPE
  ) IS
  BEGIN
    -- Zaloga se vodi samo za prodajo iz serij.
    IF p_serijaid IS NOT NULL AND NVL(p_delta, 0) <> 0 THEN
      v_zalogaid := mes_zaloga_id_seq.NEXTVAL;

      INSERT INTO mes_zaloga (
        zalogaid,
        datum_gibanja,
        tip_gibanja,
        kol_delta,
        opomba,
        izdelekid,
        postavka_dobaveid,
        serijaid,
        izdelekid_p,
        racunid_p
      ) VALUES (
        v_zalogaid,
        TRUNC(SYSDATE),
        'PRODAJA',
        p_delta,
        p_opomba,
        p_izdelekid,
        NULL,
        p_serijaid,
        p_izdelekid,
        p_racunid
      );
    END IF;
  END dodaj_gibanje;
BEGIN
  IF INSERTING THEN
    dodaj_gibanje(
      :NEW.izdelekid,
      :NEW.serijaid,
      :NEW.racunid,
      -NVL(:NEW.kolicina, 0),
      'Prodaja iz serije ' || :NEW.serijaid || ', račun ' || :NEW.racunid
    );

  ELSIF DELETING THEN
    dodaj_gibanje(
      :OLD.izdelekid,
      :OLD.serijaid,
      NULL,  -- postavka je zbrisana, FK ne sme referencirat izbrisan zapis
      NVL(:OLD.kolicina, 0),
      'Storno postavke iz serije ' || :OLD.serijaid || ', račun ' || :OLD.racunid
    );

  ELSIF UPDATING THEN
    -- Če je sprememba vsebinsko enaka, ne zapisujemo gibanja.
    IF NVL(:OLD.kolicina, 0) = NVL(:NEW.kolicina, 0)
       AND NVL(:OLD.izdelekid, -1) = NVL(:NEW.izdelekid, -1)
       AND NVL(:OLD.serijaid, -1) = NVL(:NEW.serijaid, -1) THEN
      NULL;
    ELSE
      -- Najprej razveljavi staro porabo, nato zapiši novo porabo.
      dodaj_gibanje(
        :OLD.izdelekid,
        :OLD.serijaid,
        :OLD.racunid,
        NVL(:OLD.kolicina, 0),
        'Popravek postavke (reverz) serija ' || :OLD.serijaid || ', račun ' || :OLD.racunid
      );

      dodaj_gibanje(
        :NEW.izdelekid,
        :NEW.serijaid,
        :NEW.racunid,
        -NVL(:NEW.kolicina, 0),
        'Popravek postavke (nova poraba) serija ' || :NEW.serijaid || ', račun ' || :NEW.racunid
      );
    END IF;
  END IF;
END;
/

---------------------------------------------------------------
-- 8) MES_ZALOGA -> MES_ZALOGA_TRAJNA (posodobitev trenutne zaloge)
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_zaloga_posodobi_trajno_trg
  AFTER INSERT ON mes_zaloga
  FOR EACH ROW
BEGIN
  UPDATE mes_zaloga_trajna
     SET trenutna_kolicina = trenutna_kolicina + :NEW.kol_delta,
         zadnje_gibanje    = :NEW.datum_gibanja
   WHERE izdelekid = :NEW.izdelekid;

  IF SQL%ROWCOUNT = 0 THEN
    INSERT INTO mes_zaloga_trajna (izdelekid, trenutna_kolicina, zadnje_gibanje)
    VALUES (:NEW.izdelekid, :NEW.kol_delta, :NEW.datum_gibanja);
  END IF;
END;
/

---------------------------------------------------------------
-- 9) POSTAVKA_RACUN: kontrola zaloge SAMO za serije
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_post_rac_preveri_zalogo_trg
  BEFORE INSERT OR UPDATE OF kolicina, izdelekid, serijaid ON mes_postavka_racun
  FOR EACH ROW
DECLARE
  v_na_voljo NUMBER := 0;
BEGIN
  -- Preveri zalogo SAMO če gre za prodajo iz serije
  IF :NEW.serijaid IS NOT NULL THEN
    BEGIN
      SELECT trenutna_kolicina INTO v_na_voljo
        FROM mes_zaloga_trajna
       WHERE izdelekid = :NEW.izdelekid;
    EXCEPTION WHEN NO_DATA_FOUND THEN v_na_voljo := 0;
    END;

    IF NVL(:NEW.kolicina, 0) > v_na_voljo THEN
      RAISE_APPLICATION_ERROR(
        -20005,
        'Ni dovolj zaloge za izdelek ID ' || :NEW.izdelekid ||
        '. Na voljo: ' || v_na_voljo
      );
    END IF;
  END IF;
END;
/

-- 10) POSTAVKA_RACUN: samodejni izracun VRSTICA_ST
CREATE OR REPLACE TRIGGER trg_postavka_vrstica_st
BEFORE INSERT ON mes_postavka_racun
FOR EACH ROW
BEGIN
  IF :NEW.vrstica_st IS NULL THEN
    SELECT NVL(MAX(vrstica_st), 0) + 1
      INTO :NEW.vrstica_st
      FROM mes_postavka_racun
     WHERE racunid = :NEW.racunid;
  END IF;
END;
/



-- izdelek before insert trigger: samodejno nastavi aktiven na 'DA' in obstoj na 'DA'
CREATE OR REPLACE TRIGGER mes_izdelek_bi
BEFORE INSERT ON mes_izdelek
FOR EACH ROW
BEGIN
  IF :NEW.izdelekid IS NULL THEN
    :NEW.izdelekid := mes_izdelek_id_seq.NEXTVAL;
  END IF;
END;
/

-- cena_izdelka before insert trigger: samodejno nastavi cena_izdelkaid
CREATE OR REPLACE TRIGGER mes_cena_izdelek_bi
BEFORE INSERT ON mes_cena_izdelka
FOR EACH ROW
BEGIN
  IF :NEW.cena_izdelkaid IS NULL THEN
    :NEW.cena_izdelkaid := mes_cena_izdelka_id_seq.NEXTVAL;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER mes_dobavitelj_bi
BEFORE INSERT ON mes_dobavitelj
FOR EACH ROW
BEGIN
  IF :NEW.dobaviteljid IS NULL THEN
    :NEW.dobaviteljid := mes_dobavitelj_id_seq.NEXTVAL;
  END IF;
  :NEW.aktiven_yn := 1;
END;
/


CREATE OR REPLACE TRIGGER mes_stranka_bi
BEFORE INSERT ON mes_stranka
FOR EACH ROW
BEGIN
  IF :NEW.strankaid IS NULL THEN
    :NEW.strankaid := mes_stranka_id_seq.NEXTVAL;
  END IF;
  :NEW.aktiven_yn := 1;
END;
/

---------------------------------------------------------------
-- ID triggerji za šifrante
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_merilna_enota_id
BEFORE INSERT ON mes_merilna_enota
FOR EACH ROW
BEGIN
  IF :NEW.merilna_enota_id IS NULL THEN
    :NEW.merilna_enota_id := mes_merilna_enota_id_seq.NEXTVAL;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER mes_metoda_placila_id
BEFORE INSERT ON mes_metoda_placila
FOR EACH ROW
BEGIN
  IF :NEW.metoda_placila_id IS NULL THEN
    :NEW.metoda_placila_id := mes_metoda_placila_id_seq.NEXTVAL;
  END IF;
END;
/

------------------------------------------------
-- ID trigger za dobavo (če se vnaša brez ID-ja)
------------------------------------------------

CREATE OR REPLACE TRIGGER mes_dobava_bir
BEFORE INSERT ON mes_dobava
FOR EACH ROW
BEGIN
  IF (:NEW.dobavaid IS NULL) THEN
    :NEW.dobavaid := mes_dobava_id_seq.NEXTVAL;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER mes_postavka_dobave_bir
BEFORE INSERT ON mes_postavka_dobave
FOR EACH ROW
BEGIN
  IF (:NEW.postavka_dobaveid IS NULL) THEN
    :NEW.postavka_dobaveid := mes_postavka_dobave_id_seq.NEXTVAL;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER mes_racun_bir
BEFORE INSERT ON mes_racun
FOR EACH ROW
BEGIN
  IF (:NEW.racunid IS NULL) THEN
    :NEW.racunid := mes_racun_id_seq.NEXTVAL;
  END IF;
END;
/


-------------------------------------------------------------
-- Serija KONCANA -> vpis kolicina_kon v mes_zaloga
---------------------------------------------------------------
CREATE OR REPLACE TRIGGER mes_serija_koncana_zaloga_trg
  AFTER INSERT OR UPDATE OF status ON mes_serija
  FOR EACH ROW
BEGIN
  IF :NEW.status = 'KONCANA'  THEN
    INSERT INTO mes_zaloga (
      zalogaid,
      datum_gibanja,
      tip_gibanja,
      kol_delta,
      opomba,
      izdelekid,
      postavka_dobaveid,
      serijaid,
      izdelekid_p,
      racunid_p
    ) VALUES (
      mes_zaloga_id_seq.NEXTVAL,
      TRUNC(SYSDATE),
      'PROIZVODNJA',
      :NEW.kolicina_kon,
      'Zaključek serije ' || :NEW.koda,
      :NEW.izdelekid,
      NULL,
      :NEW.serijaid,
      NULL,
      NULL
    );
  END IF;
END;
/