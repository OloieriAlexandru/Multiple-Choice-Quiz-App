
set serveroutput on;

CREATE OR REPLACE FUNCTION genereaza_numar_random(p_minim INT, p_maxim INT)
RETURN INT AS
BEGIN
    RETURN FLOOR(DBMS_RANDOM.value(p_minim, p_maxim+1));
END;
/

CREATE OR REPLACE FUNCTION verifica_existenta_test(p_id_utilizator VARCHAR2)
RETURN INT AS
    -- v_intrebari_ramase INT;
    v_intrebari_test INT;
BEGIN
    -- SELECT COUNT(*) INTO v_intrebari_ramase FROM intrebari_utilizatori i_u JOIN utilizatori u ON i_u.id_utilizator = u.id WHERE u.email = p_email AND raspuns IS NULL;
    SELECT COUNT(*) INTO v_intrebari_test
        FROM intrebari_utilizatori
        WHERE id_utilizator = p_id_utilizator;
    IF v_intrebari_test > 0 THEN
        RETURN 1;
    END IF;
    RETURN 0;
END;
/

CREATE OR REPLACE PROCEDURE creaza_intrebare_test(p_id_utilizator INT, p_id_test_utilizator INT, p_numar_ordine INT, p_intrebare_id VARCHAR2)
AS
    TYPE varr_raspunsuri IS TABLE OF VARCHAR2(8);

    v_random INT;
    v_raspuns_curent VARCHAR(8);

    v_raspunsuri_corecte varr_raspunsuri := varr_raspunsuri();
    v_raspunsuri_fara_cel_corect varr_raspunsuri := varr_raspunsuri();
    v_raspunsuri_selectate varr_raspunsuri := varr_raspunsuri();
    v_raspunsuri_amestecate varr_raspunsuri := varr_raspunsuri();
BEGIN
    FOR v_raspunsuri_corecte_linie IN (SELECT id FROM raspunsuri WHERE q_id = p_intrebare_id AND corect = 1) LOOP
        v_raspunsuri_corecte.EXTEND(1);
        v_raspunsuri_corecte(v_raspunsuri_corecte.COUNT) := v_raspunsuri_corecte_linie.id;
    END LOOP;
    
    v_raspunsuri_selectate.EXTEND(1);
    v_raspunsuri_selectate(1) := v_raspunsuri_corecte(genereaza_numar_random(1, v_raspunsuri_corecte.COUNT));
    
    FOR v_restul_raspunsuri_linie IN (SELECT id FROM raspunsuri WHERE q_id = p_intrebare_id AND id <> v_raspunsuri_selectate(1)) LOOP
        v_raspunsuri_fara_cel_corect.EXTEND(1);
        v_raspunsuri_fara_cel_corect(v_raspunsuri_fara_cel_corect.COUNT) := v_restul_raspunsuri_linie.id;
    END LOOP;
    
    FOR v_i IN 2..6 LOOP
        v_raspunsuri_selectate.EXTEND(1);
        
        v_random := genereaza_numar_random(1, v_raspunsuri_fara_cel_corect.COUNT);
        v_raspunsuri_selectate(v_i) := v_raspunsuri_fara_cel_corect(v_random);
        
        v_raspunsuri_fara_cel_corect(v_random) := v_raspunsuri_fara_cel_corect(v_raspunsuri_fara_cel_corect.COUNT);
        v_raspunsuri_fara_cel_corect.TRIM();
    END LOOP;
    
    FOR v_i IN 1..6 LOOP
        v_raspunsuri_amestecate.EXTEND(1);
        
        v_random := genereaza_numar_random(1, v_raspunsuri_selectate.COUNT);
        v_raspunsuri_amestecate(v_i) := v_raspunsuri_selectate(v_random);
        
        v_raspunsuri_selectate(v_random) := v_raspunsuri_selectate(v_raspunsuri_selectate.COUNT);
        v_raspunsuri_selectate.TRIM();
    END LOOP;
    
    INSERT INTO intrebari_utilizatori(id_utilizator, id_test_utilizator, id_intrebare, nr_ordine_intrebare, raspuns_utilizator, punctaj, raspuns_1, raspuns_2, raspuns_3, raspuns_4, raspuns_5, raspuns_6)
        VALUES (p_id_utilizator, p_id_test_utilizator, p_intrebare_id, p_numar_ordine, NULL, NULL, v_raspunsuri_amestecate(1), v_raspunsuri_amestecate(2), v_raspunsuri_amestecate(3), v_raspunsuri_amestecate(4), v_raspunsuri_amestecate(5), v_raspunsuri_amestecate(6));
END;
/

CREATE OR REPLACE PROCEDURE creaza_intrebare_domeniu(p_id_utilizator INT, p_id_test_utilizator INT, p_numar_ordine INT, p_domeniu VARCHAR2)
AS
    TYPE varr_intrebari IS TABLE OF VARCHAR(8);
    
    v_intrebare INT;
    v_intrebari_domeniu varr_intrebari := varr_intrebari();
BEGIN
    FOR v_linie_intrebari_domeniu IN (SELECT id FROM intrebari WHERE domeniu = p_domeniu) LOOP
        v_intrebari_domeniu.EXTEND(1);
        v_intrebari_domeniu(v_intrebari_domeniu.COUNT) := v_linie_intrebari_domeniu.id;
    END LOOP;
    
    v_intrebare := genereaza_numar_random(1, v_intrebari_domeniu.COUNT);
    creaza_intrebare_test(p_id_utilizator, p_id_test_utilizator, p_numar_ordine, v_intrebari_domeniu(v_intrebare));
END;
/

CREATE OR REPLACE PROCEDURE creaza_test(p_id_utilizator VARCHAR2)
AS
    TYPE varr_domenii IS TABLE OF VARCHAR2(5);
    v_domenii varr_domenii := varr_domenii();
    
    v_random INT;
BEGIN
    FOR v_intrebare_linie IN (SELECT DISTINCT domeniu FROM intrebari) LOOP
        v_domenii.EXTEND(1);
        v_domenii(v_domenii.COUNT) := v_intrebare_linie.domeniu;
    END LOOP;
        
    FOR v_i in 1..10 LOOP
        v_random := genereaza_numar_random(1, v_domenii.COUNT);
        
        creaza_intrebare_domeniu(p_id_utilizator, 1, v_i, v_domenii(v_random));
        v_domenii(v_random) := v_domenii(v_domenii.COUNT);
        v_domenii.TRIM();
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE analizeaza_raspuns(p_id_utilizator VARCHAR2, p_raspuns VARCHAR2)
AS
    v_id_intrebare VARCHAR2(8);
    v_raspuns VARCHAR2(48);
    
    v_i INT;
    v_lungime INT;
    
    v_count INT;
BEGIN
    v_i := 1;
    v_lungime := LENGTH(p_raspuns);
    
    LOOP
        EXIT WHEN v_i > v_lungime OR SUBSTR(p_raspuns, v_i, 1) = ',';
        v_i := v_i + 1;
    END LOOP;
    
    v_id_intrebare := SUBSTR(p_raspuns, 1, (v_i - 1));
    SELECT COUNT(*) INTO v_count
        FROM intrebari_utilizatori
        WHERE id_utilizator = p_id_utilizator AND id_intrebare = v_id_intrebare AND raspuns_utilizator IS NULL;
        
    IF v_count > 0 THEN
        v_raspuns := SUBSTR(p_raspuns, v_i+1);
        UPDATE intrebari_utilizatori
            SET raspuns_utilizator = v_raspuns
            WHERE id_utilizator = p_id_utilizator AND id_intrebare = v_id_intrebare;
    END IF;
END;
/

CREATE OR REPLACE FUNCTION ia_text_raspuns(p_id_raspuns VARCHAR2)
RETURN VARCHAR2 AS
    v_text_raspuns raspunsuri.text_raspuns%TYPE;
BEGIN
    SELECT text_raspuns INTO v_text_raspuns FROM raspunsuri WHERE id = p_id_raspuns;
    return v_text_raspuns;
END;
/

CREATE OR REPLACE FUNCTION ia_text_intrebare(p_id_intrebare VARCHAR2)
RETURN VARCHAR2 AS
    v_text_intrebare intrebari.text_intrebare%TYPE;
BEGIN
    SELECT text_intrebare INTO v_text_intrebare FROM intrebari WHERE id = p_id_intrebare;
    return v_text_intrebare;
END;
/

CREATE OR REPLACE FUNCTION ia_corectitudine_raspuns(p_id_raspuns VARCHAR2)
RETURN VARCHAR2 AS
    v_corectitudine_raspuns raspunsuri.corect%TYPE;
BEGIN
    SELECT corect INTO v_corectitudine_raspuns FROM raspunsuri WHERE id = p_id_raspuns;
    return v_corectitudine_raspuns;
END;
/

CREATE OR REPLACE FUNCTION construieste_json_raspuns(p_id_raspuns VARCHAR2)
RETURN VARCHAR2 AS
    v_json VARCHAR2(1024) := '';
BEGIN
    v_json := '{ "id_raspuns": "' || p_id_raspuns || '", "text_raspuns": "' || ia_text_raspuns(p_id_raspuns) || '" }';
    return v_json;
END;
/

CREATE OR REPLACE FUNCTION construieste_json_raspuns_full(p_id_raspuns VARCHAR2)
RETURN VARCHAR2 AS
    v_json VARCHAR2(1024) := '';
BEGIN
    v_json := '{ "id_raspuns": "' || p_id_raspuns || '", "text_raspuns": "' || ia_text_raspuns(p_id_raspuns) || '", "corect": "' || ia_corectitudine_raspuns(p_id_raspuns) || '" }';
    return v_json;
END;
/

CREATE OR REPLACE FUNCTION urmatoarea_intrebare_test(p_id_utilizator VARCHAR2)
RETURN VARCHAR2 AS
    v_json VARCHAR2(10240) := '';
    v_gasit INT := 0;
BEGIN
    FOR v_linie_intrebare IN (SELECT * FROM intrebari_utilizatori WHERE id_utilizator = p_id_utilizator AND raspuns_utilizator IS NULL ORDER BY nr_ordine_intrebare) LOOP
        
        v_json := '{ "id_intrebare": "' || v_linie_intrebare.id_intrebare || '", "text_intrebare": "' || ia_text_intrebare(v_linie_intrebare.id_intrebare) || '", "numar_ordine": ' || v_linie_intrebare.nr_ordine_intrebare || ', "raspunsuri": [ ';
        
        v_json := v_json || construieste_json_raspuns(v_linie_intrebare.raspuns_1) || ', ';
        v_json := v_json || construieste_json_raspuns(v_linie_intrebare.raspuns_2) || ', ';
        v_json := v_json || construieste_json_raspuns(v_linie_intrebare.raspuns_3) || ', ';
        v_json := v_json || construieste_json_raspuns(v_linie_intrebare.raspuns_4) || ', ';
        v_json := v_json || construieste_json_raspuns(v_linie_intrebare.raspuns_5) || ', ';
        v_json := v_json || construieste_json_raspuns(v_linie_intrebare.raspuns_6) || '] }';
        
        v_gasit := v_gasit + 1;
        EXIT WHEN v_gasit = 1;
    END LOOP;
    IF v_gasit = 1 THEN
        return v_json;
    END IF;
    return null;
END;
/

CREATE OR REPLACE FUNCTION ia_punctaj_intrebare(p_id_utilizator VARCHAR2, p_nr_ordine_intrebare INT)
RETURN FLOAT AS
    v_punctaj_intrebare intrebari_utilizatori.punctaj%TYPE;
BEGIN
    SELECT punctaj INTO v_punctaj_intrebare
        FROM intrebari_utilizatori
        WHERE nr_ordine_intrebare = p_nr_ordine_intrebare AND id_utilizator = p_id_utilizator
        ORDER BY nr_ordine_intrebare ASC;
    return v_punctaj_intrebare;
END;
/

CREATE OR REPLACE FUNCTION construieste_json_intrebare(p_id_utilizator VARCHAR2, p_nr_ordine_intrebare INT)
RETURN VARCHAR2 AS
    v_json VARCHAR2(10800) := '';
    v_linie_intrebare intrebari_utilizatori%ROWTYPE;
BEGIN
    SELECT * INTO v_linie_intrebare
        FROM intrebari_utilizatori
        WHERE id_utilizator = p_id_utilizator AND nr_ordine_intrebare = p_nr_ordine_intrebare
        ORDER BY nr_ordine_intrebare ASC;

    v_json := '{ "id_intrebare": "' || v_linie_intrebare.id_intrebare || '", "text_intrebare": "' || ia_text_intrebare(v_linie_intrebare.id_intrebare) || '", "numar_ordine": ' || v_linie_intrebare.nr_ordine_intrebare || ', "raspunsuri": [ ';
        
    v_json := v_json || construieste_json_raspuns_full(v_linie_intrebare.raspuns_1) || ', ';
    v_json := v_json || construieste_json_raspuns_full(v_linie_intrebare.raspuns_2) || ', ';
    v_json := v_json || construieste_json_raspuns_full(v_linie_intrebare.raspuns_3) || ', ';
    v_json := v_json || construieste_json_raspuns_full(v_linie_intrebare.raspuns_4) || ', ';
    v_json := v_json || construieste_json_raspuns_full(v_linie_intrebare.raspuns_5) || ', ';
    v_json := v_json || construieste_json_raspuns_full(v_linie_intrebare.raspuns_6) || '], "raspuns_utilizator": "' || v_linie_intrebare.raspuns_utilizator || '" }';

    return v_json;
END;
/

CREATE OR REPLACE FUNCTION construieste_json_punctaj(p_id_utilizator VARCHAR2, p_punctaj FLOAT)
RETURN VARCHAR2 AS
    v_json VARCHAR2(10864);
BEGIN
    v_json := '{ "punctaj": "' || p_punctaj || '", "punctaje_intrebari": [ ';
    
    FOR v_i in 1..10 LOOP
        v_json := v_json || ia_punctaj_intrebare(p_id_utilizator, v_i);
        IF v_i < 10 THEN
            v_json := v_json || ', ';
        END IF;
    END LOOP;
    
    v_json := v_json || ' ], "intrebari": [ ';
    
    FOR v_i in 1..10 LOOP
        v_json := v_json || construieste_json_intrebare(p_id_utilizator, v_i);
        IF v_i < 10 THEN
            v_json := v_json || ', ';
        END IF;
    END LOOP;
    
    v_json := v_json || ' ] }';
    return v_json;
END;
/

CREATE OR REPLACE FUNCTION este_raspunsul_corect(p_id_raspuns VARCHAR2)
RETURN INT AS
    v_corect INT;
BEGIN
    SELECT corect INTO v_corect FROM raspunsuri WHERE id = p_id_raspuns;
    return v_corect;
END;
/

CREATE OR REPLACE PROCEDURE calculeaza_punctaj_intrebare(p_id_utilizator VARCHAR2, p_nr_ordine_intrebare INT)
AS
    v_linie_intrebare intrebari_utilizatori%ROWTYPE;
    
    v_valoare_raspuns FLOAT;
    v_punctaj FLOAT := 0;
    v_id_raspuns VARCHAR2(48);
    
    v_raspunsuri_corecte INT := 0;
    v_raspuns_corect INT;

    v_i INT;
    v_ultim_i INT;
    v_lungime INT;
BEGIN
    SELECT * INTO v_linie_intrebare 
        FROM intrebari_utilizatori 
        WHERE nr_ordine_intrebare = p_nr_ordine_intrebare AND id_utilizator = p_id_utilizator;

    v_raspunsuri_corecte := v_raspunsuri_corecte + este_raspunsul_corect(v_linie_intrebare.raspuns_1);
    v_raspunsuri_corecte := v_raspunsuri_corecte + este_raspunsul_corect(v_linie_intrebare.raspuns_2);
    v_raspunsuri_corecte := v_raspunsuri_corecte + este_raspunsul_corect(v_linie_intrebare.raspuns_3);
    v_raspunsuri_corecte := v_raspunsuri_corecte + este_raspunsul_corect(v_linie_intrebare.raspuns_4);
    v_raspunsuri_corecte := v_raspunsuri_corecte + este_raspunsul_corect(v_linie_intrebare.raspuns_5);
    v_raspunsuri_corecte := v_raspunsuri_corecte + este_raspunsul_corect(v_linie_intrebare.raspuns_6);
    
    v_valoare_raspuns := 10.0 / v_raspunsuri_corecte;
    
    v_i := 1;
    v_ultim_i := 1;
    v_lungime := LENGTH(v_linie_intrebare.raspuns_utilizator);
    FOR v_j IN 1..6 LOOP
        LOOP 
            EXIT WHEN v_i > v_lungime OR SUBSTR(v_linie_intrebare.raspuns_utilizator, v_i, 1) = ',';
            v_i := v_i + 1;
        END LOOP;
        IF v_i > v_lungime AND v_i - v_ultim_i = 0 THEN
            EXIT;
        END IF;
        IF v_i - v_ultim_i = 0 THEN
            v_i := v_i + 1;
            v_ultim_i := v_i;
            CONTINUE;
        END IF;
        
        v_id_raspuns := SUBSTR(v_linie_intrebare.raspuns_utilizator, v_ultim_i, (v_i - v_ultim_i));
        v_raspuns_corect := este_raspunsul_corect(v_id_raspuns);
        IF v_raspuns_corect = 1 THEN
            v_punctaj := v_punctaj + v_valoare_raspuns;
        ELSE
            v_punctaj := v_punctaj - v_valoare_raspuns;
        END IF;
        
        v_i := v_i + 1;
        v_ultim_i := v_i;
    END LOOP;
    IF v_punctaj < 0 THEN
        v_punctaj := 0;
    END IF;
    v_punctaj := ROUND(v_punctaj, 2);
    UPDATE intrebari_utilizatori
        SET punctaj = v_punctaj
        WHERE nr_ordine_intrebare = p_nr_ordine_intrebare AND id_utilizator = p_id_utilizator;
END;
/

CREATE OR REPLACE FUNCTION calculeaza_punctaj(p_id_utilizator VARCHAR2)
RETURN VARCHAR2 AS
    v_punctaj FLOAT;
    v_punctaje_calculate INT;
BEGIN
    SELECT COUNT(*) INTO v_punctaje_calculate FROM intrebari_utilizatori WHERE id_utilizator = p_id_utilizator AND punctaj IS NULL;
    IF v_punctaje_calculate > 0 THEN
        FOR v_i in 1..10 LOOP
            calculeaza_punctaj_intrebare(p_id_utilizator, v_i);
        END LOOP;
    END IF;
    SELECT SUM(punctaj) INTO v_punctaj FROM intrebari_utilizatori WHERE id_utilizator = p_id_utilizator;
    return construieste_json_punctaj(p_id_utilizator, v_punctaj);    
END;
/

CREATE OR REPLACE FUNCTION urmatoarea_intrebare(p_email VARCHAR2, p_raspuns VARCHAR2)
RETURN VARCHAR2 AS
    v_id_utilizator INT;

    v_exista_test INT;

    v_urmatoarea_intrebare VARCHAR2(10240);
BEGIN
    SELECT id INTO v_id_utilizator FROM utilizatori WHERE email = p_email;

    IF p_raspuns IS NULL THEN
        v_exista_test := verifica_existenta_test(v_id_utilizator);
        IF v_exista_test = 0 THEN
            creaza_test(v_id_utilizator);
        END IF;
    ELSE
        analizeaza_raspuns(v_id_utilizator, p_raspuns);
    END IF;
        
    v_urmatoarea_intrebare := urmatoarea_intrebare_test(v_id_utilizator);
    IF v_urmatoarea_intrebare IS NULL THEN
        RETURN calculeaza_punctaj(v_id_utilizator);
    ELSE
        RETURN v_urmatoarea_intrebare;
    END IF;
END;
/
