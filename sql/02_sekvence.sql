/* ============================================================
   SEKVENCE ZA APEX SQL WORKSHOP

   OPOMBA: Poženi to datoteko PRED triggerji.
   Če sekvenca že obstaja, bo javila napako - to ignoriraj.
   ============================================================ */

-- DROP obstoječih sekvenc (ignoriraj napako če ne obstajajo)
DROP SEQUENCE mes_merilna_enota_id_seq;
DROP SEQUENCE mes_metoda_placila_id_seq;
DROP SEQUENCE mes_izdelek_id_seq;
DROP SEQUENCE mes_cena_izdelka_id_seq;
DROP SEQUENCE mes_dobavitelj_id_seq;
DROP SEQUENCE mes_stranka_id_seq;
DROP SEQUENCE mes_dobava_id_seq;
DROP SEQUENCE mes_postavka_dobave_id_seq;
DROP SEQUENCE mes_racun_id_seq;
DROP SEQUENCE mes_prasic_skupina_id_seq;
DROP SEQUENCE mes_prasic_id_seq;
DROP SEQUENCE mes_klanje_id_seq;
DROP SEQUENCE mes_serija_id_seq;
DROP SEQUENCE mes_serija_vnos_id_seq;
DROP SEQUENCE mes_hrenovke_serija_id_seq;
DROP SEQUENCE mes_zaloga_id_seq;

CREATE SEQUENCE mes_merilna_enota_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_metoda_placila_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_izdelek_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_cena_izdelka_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_dobavitelj_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_stranka_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_dobava_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_postavka_dobave_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_racun_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_prasic_skupina_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_prasic_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_klanje_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_serija_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_serija_vnos_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_hrenovke_serija_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

CREATE SEQUENCE mes_zaloga_id_seq START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

-- Poženi to, da se sekvence uskladijo z obstoječimi podatki (če so id-ji bili vnešeni ročno)
DECLARE
  v_target NUMBER;
  v_curr   NUMBER;
  v_step   NUMBER;
BEGIN
  SELECT NVL(MAX(IDTABELE), 0) + 1
    INTO v_target
    FROM TABELA;

  SELECT IME_SEKVENCA.NEXTVAL
    INTO v_curr
    FROM dual;

  IF v_curr < v_target THEN
    v_step := v_target - v_curr;

    EXECUTE IMMEDIATE
      'ALTER SEQUENCE IME_SEKVENCE INCREMENT BY ' || v_step;

    SELECT IME_SEKVENCE.NEXTVAL
      INTO v_curr
      FROM dual;

    EXECUTE IMMEDIATE
      'ALTER SEQUENCE IME_SEKVENCE INCREMENT BY 1';
  END IF;
END;
/


DECLARE
  v_target NUMBER;
  v_curr   NUMBER;
  v_step   NUMBER;
BEGIN
  SELECT NVL(MAX(cena_izdelkaid), 0) + 1
    INTO v_target
    FROM mes_cena_izdelka;

  SELECT mes_cena_izdelka_id_seq.NEXTVAL
    INTO v_curr
    FROM dual;

  IF v_curr < v_target THEN
    v_step := v_target - v_curr;

    EXECUTE IMMEDIATE
      'ALTER SEQUENCE mes_cena_izdelka_id_seq INCREMENT BY ' || v_step;

    SELECT mes_cena_izdelka_id_seq.NEXTVAL
      INTO v_curr
      FROM dual;

    EXECUTE IMMEDIATE
      'ALTER SEQUENCE mes_cena_izdelka_id_seq INCREMENT BY 1';
  END IF;
END;
/