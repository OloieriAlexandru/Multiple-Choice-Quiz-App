
-- https://chartio.com/resources/tutorials/how-to-define-an-auto-increment-primary-key-in-oracle/

DROP TABLE intrebari_utilizatori;
/
DROP SEQUENCE intrebari_utilizatori_secv;
/

DROP TABLE utilizatori;
/
DROP SEQUENCE utilizatori_secv;
/

CREATE TABLE utilizatori (
    id INT NOT NULL PRIMARY KEY,
    email VARCHAR2(255),
    hash VARCHAR(64)
);
/

CREATE SEQUENCE utilizatori_secv;
/

CREATE OR REPLACE TRIGGER utilizator_on_insert
    BEFORE INSERT ON utilizatori
    FOR EACH ROW
BEGIN
    SELECT utilizatori_secv.nextval
    INTO :new.id
    FROM dual;
END;
/

CREATE TABLE intrebari_utilizatori (
    id INT NOT NULL PRIMARY KEY,
    id_utilizator INT NOT NULL,
    id_test_utilizator INT NOT NULL,
    id_intrebare VARCHAR(8) NOT NULL,
    nr_ordine_intrebare INT NOT NULL,
    raspuns_utilizator VARCHAR2(56),
    punctaj FLOAT,
    raspuns_1 VARCHAR2(8) NOT NULL,
    raspuns_2 VARCHAR2(8) NOT NULL,
    raspuns_3 VARCHAR2(8) NOT NULL,
    raspuns_4 VARCHAR2(8) NOT NULL,
    raspuns_5 VARCHAR2(8) NOT NULL,
    raspuns_6 VARCHAR2(8) NOT NULL,
    
    CONSTRAINT fk_test_utilizator
        FOREIGN KEY (id_utilizator)
        REFERENCES utilizatori (id)
        ON DELETE CASCADE
);
/

CREATE SEQUENCE intrebari_utilizatori_secv;
/

CREATE OR REPLACE TRIGGER intrebare_utilizator_on_insert
    BEFORE INSERT ON intrebari_utilizatori
    FOR EACH ROW
BEGIN
    SELECT intrebari_utilizatori_secv.nextval
    INTO :new.id
    FROM dual;
END;
/
