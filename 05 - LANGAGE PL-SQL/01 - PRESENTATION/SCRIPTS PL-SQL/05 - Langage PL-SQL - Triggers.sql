
/****************************************************************************** 
          SOMMAIRE
    
                    • TRIGGERS
                    • TRIGGERS LMD
                    • TRIGGERS : Prédicats INSERTING, DELETING et UPDATING
                    • TRIGGERS SUR EVENEMENTS SYSTEME
                    • TRIGGERS LDD
                    • TRIGGERS INSTEAD OF SUR VUE 
                    
******************************************************************************/

/*
Un trigger est une action stockée dans la base de données et qui s’exécute 
suite à un événement. 
La suite d’instructions que constitue cette action est exécutée automatiquement 
par le système de gestion de base de données, chaque fois que l’événement 
auquel elle est associée se produit. 

Dans Oracle, un trigger peut être de plusieurs types : 
  •	Trigger LMD (langage de manipulation de données) sur une table
    INSERT, UPDATE, DELETE, SELECT, ...
  •	Trigger LDD (Langage de Définition des Données) sur un schéma ou une base de données
    CREATE, ALTER, DROP, RENAME, TRUNCATE, COMMENT, GRANT, REVOKE, ...
  •	Trigger INSTEAD OF sur une vue 
  •	Trigger événements systèmes sur la base de données (STARTUP, SHUTDOWN, 
    SERVERERROR, LOGON ou LOGOFF) 
*/

/*
  Points importants à retenir

  •	Triggers ne commite pas les transactions.
    Si une transaction est "annulée (rollback), les modifications faites
    par le trigger sont aussi annulées
  
  •	Commits, rollbacks and savepoints ne sont pas autorisés dans un trigger 
    Un commit/rollback affecte la totalité de la transaction, c'est tout ou rien
  
  • Exception levée dans un trigger entraine un rollback
    de la totalité de la transaction, pas uniquement du trigger
  
  • Si plus d'un trigger est défini sur un evenement
    l'ordre dans lequel ils sont traités n'est pas défini
    Si les triggers doivent être déclenchés dans un ordre précis, vous devez créer 
    un trigger qui exécute toutes les actions dans l'ordre désiré
  
  • Un trigger peut être à l'origine d'évenements qui déclencheront
    d'autres triggers
  
  • Un trigger ne peut pas modifier une table qui est en cours de lecture par le trigger  
    Erreur -> table en mutation

  Informations sur les triggers
  
  Les vues du dictionnaire concernées sont :
  •	USER_TRIGGERS pour les déclencheurs appartenant au schéma
  •	ALL_TRIGGERS pour les déclencheurs appartenant aux schémas accessibles
  •	DBA_TRIGGERS pour les déclencheurs appartenant à tous les schémas 

  •	Colonne BASE_OBJECT_TYPE permet de savoir si le déclencheur est basé sur une table, 
    une vue, un schéma ou la totalité de la base 
  •	Colonne TRIGGER_TYPE permet de savoir s'il s'agit d'un déclencheur BEFORE, 
    AFTER ou INSTEAD OF
    si son mode est FOR EACH ROW (trigger LIGNE) ou non (trigger TABLE)
    s'il s'agit d'un déclencheur évènementiel ou non 
  •	Colonne TRIGGERING_EVENT permet de connaître l'événement concerné par le déclencheur 
  •	Colonne TRIGGER_BODY contient le code du bloc PL/SQL 
*/

-- Liste des triggers de l'utilisateur connecté
SELECT * FROM USER_TRIGGERS;

-- Liste de tous les triggers posés sur des tables accessibles par l'utilisateur
-- connecté
SELECT * FROM ALL_TRIGGERS;

-- Liste de tous les triggers de la base de données (EN TANT QUE SYS)
SELECT * FROM DBA_TRIGGERS;

-- Suppression d'un trigger
DROP TRIGGER monTriggger;

-- Tout comme les fonctions ou procédures, un trigger peut se retrouver avec un 
-- statut invalide, il faut alors le recompiler
ALTER TRIGGER monTriggger COMPILE;

-- Désactiver un trigger (afin qu'il ne déclenche plus, mais reste présent en base)
ALTER TRIGGER monTriggger DISABLE;

-- Vous pouvez le réactiver par la commande
ALTER TRIGGER monTriggger ENABLE;

-- Compilation du trigger
ALTER TRIGGER SECURITE_TRIGGER COMPILE;

-- Informations sur un trigger
-- Trigger name - trigger type - trigger event -
SELECT * FROM user_triggers WHERE trigger_name ='nom_trigger';
-- Exemple
SELECT * FROM user_triggers WHERE trigger_name ='TR_COMMENTAIRE';

-- Informations relatives aux triggers sont accessibles via la vue USER_TRIGGERS
SELECT  object_name, status, object_type, created  FROM user_objects
WHERE object_name = 'nom_trigger';
-- Exemple
SELECT  object_name, status, object_type, created  FROM user_objects
WHERE object_name = 'TR_INSERT_VISITE';

-- Effectuer la commande ci-dessous pour connaitre les champs de la table user_objects
desc user_objects

-- Pour connaitre tous les triggers et leur état
SELECT object_name, status  FROM user_objects
WHERE object_type = 'TRIGGER';

-- Pour connaitre toutes les fonctions et leur état
SELECT  object_name, status  FROM user_objects
WHERE object_type = 'FUNCTION';

-- Pour connaitre toutes les procédures et leur état
SELECT  object_name, status  FROM user_objects
WHERE object_type = 'PROCEDURE';

-- Le code source d'un trigger(ou procedures, fonctions, packages) est accessible
-- via la vue du dictionnaire de données USER_SOURCE.
SELECT  text FROM user_source
WHERE name = 'TR_INSERT_VISITE'
AND   type = 'TRIGGER'

-- Creation de tables LOG_SYS & LOG_LMD pour exercice
-- Table LOG
DROP TABLE "LOG_SYS" CASCADE CONSTRAINTS;
DROP TABLE "LOG_LMD" CASCADE CONSTRAINTS;
CREATE TABLE LOG_SYS (
     UserName VARCHAR2(32),
     EventAction VARCHAR2(20),
     EventDate Date,
     IPAddress VARCHAR2(20),
     InstanceNum VARCHAR2(25)
);
CREATE TABLE LOG_LMD (
     TableName VARCHAR2(20), 
     EventDate Date,
     UserName VARCHAR2(32),
     Action VARCHAR2(25)
);

/******************************************************************************* 
                          TRIGGERS
                 Explication du fonctionnement avec
                      des exemples simples
*******************************************************************************/

CREATE TABLE "VILLE" 
(	"ID_VILLE" NUMBER, 
	"NOM" VARCHAR2(25 BYTE) NOT NULL ENABLE
);
ALTER TABLE VILLE
	ADD CONSTRAINT pk_ville PRIMARY KEY (ID_VILLE);
  
CREATE or REPLACE TRIGGER TR_VILLE_1
  BEFORE INSERT OR UPDATE OR DELETE ON VILLE
  -- FOR EACH ROW 
  BEGIN
  dbms_output.put_line('TRIGGER BEFORE EXECUTE');
END;

CREATE or REPLACE TRIGGER TR_VILLE_2
  AFTER INSERT ON VILLE
  -- FOR EACH ROW 
  BEGIN
  dbms_output.put_line('TRIGGER AFTER EXECUTE');
END;

DROP SEQUENCE SQ_VILLE;
CREATE SEQUENCE SQ_VILLE
	start with 1 increment by 1 nomaxvalue;
DELETE FROM VILLE;

INSERT INTO VILLE (ID_VILLE, NOM) VALUES (SQ_VILLE.nextval, 'LYON');
INSERT INTO VILLE (ID_VILLE, NOM) VALUES (SQ_VILLE.nextval, 'MARSEILLE');

UPDATE VILLE SET NOM='TOULOUSE' WHERE ID_VILLE = 2;
UPDATE VILLE SET NOM='TOULOUSE';

ALTER TRIGGER TR_VILLE_1 DISABLE;
ALTER TRIGGER TR_VILLE_4 DISABLE;

-- Lecture de :old et :new
CREATE or REPLACE TRIGGER TR_VILLE_3
  BEFORE INSERT OR UPDATE ON VILLE
  FOR EACH ROW 
  BEGIN
  :new.nom := 'LYON';
  dbms_output.put_line('NEW :' || :new.nom);
  dbms_output.put_line('OLD :' || :old.nom);
END;

UPDATE VILLE SET NOM='TOULOUSE';

ALTER TRIGGER TR_VILLE_3 DISABLE;

-- avec une condition -> WHEN
CREATE or REPLACE TRIGGER TR_VILLE_4
  BEFORE INSERT OR UPDATE ON VILLE
  FOR EACH ROW 
  WHEN (NEW.nom = 'TOULOUSE' OR NEW.nom = 'LYON')
  BEGIN
  dbms_output.put_line('TRIGGER TR_VILLE_4 DECLENCHE');
END;

UPDATE VILLE SET NOM='TOULOUSE';

/******************************************************************************* 
                          TRIGGERS LMD
                  Langage de Manipulation de Données
                  Trigger de type table (trigger global)
*******************************************************************************/

-- Suppression des triggers
DROP TRIGGER tr_insert_visite;
DROP TRIGGER tr_update_prixvisite;
DROP TRIGGER tr_update_prixvisite1;
DROP TRIGGER tr_update_medecin;

-- Enregistrement action dans une table LOG avant chaque insert dans la table VISITE
-- Trigger de type TABLE
CREATE or REPLACE TRIGGER tr_insert_visite
  BEFORE INSERT ON VISITE
  BEGIN
    INSERT INTO LOG_LMD(TableName, EventDate, UserName, Action)
    VALUES ('VISITE', sysdate, sys_context('USERENV','CURRENT_USER'), 'INSERT/UPDATE sur VISITE') ;
END;

DELETE FROM VISITE WHERE NUMEROVISITE = 'NUMEROVISITE10';
INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE10','NUMEROMED1', '164042561678250', 
TO_DATE('1998/05/31 12:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE1');

/******************************************************************************* 
                          TRIGGERS LMD
                  Langage de Manipulation de Données
                      Trigger de type ligne
            Trigger exécuté pour chaque ligne affectée par l'ordre LMD 
*******************************************************************************/
/*

Seules les colonnes de la ligne en cours de modification sont accessibles par 
l'intermédiaire de 2 variables de type enregistrement OLD et NEW

•	OLD représente la valeur avant modification
  OLD n'est renseignée que pour les ordres DELETE et UPDATE. 
  Elle n'a aucune signification pour un ordre INSERT, 
  puisqu'aucune ancienne valeur n'existe 

•	NEW représente la nouvelle valeur
  NEW n'est renseignée que pour les ordres INSERT et UPDATE. 
  Elle n'a aucune signification pour un ordre DELETE, 
  puisqu'aucune nouvelle valeur n'existe 
  
  Trigger d’insertion (INSERT) 
  NEW = nouvelle ligne à insérer
  
  Trigger de suppression (DELETE)
  OLD = ligne en cours de suppression   
      
  Trigger de modification (UPDATE)
  NEW = ligne après modification
  OLD = ligne avant modification
*/

-- Afficher message si prix visite à positionner est inférieur au prix courant
CREATE OR REPLACE TRIGGER tr_update_prixvisite
  AFTER UPDATE OF prixvisite
  ON TYPEVISITE
  FOR EACH ROW
    -- Ne pas mettre les : devant OLD et NEW
    WHEN (OLD.prixvisite > NEW.prixvisite)
  BEGIN
  -- Pas posssible car table en mutation
  -- UPDATE TYPEVISITE SET prixvisite = :NEW.prixvisite;
  DBMS_OUTPUT.PUT_LINE ('PRIX VISITE ' || To_char(:OLD.prixvisite) 
  || ' SUPERIEUR AU SEUIL ' || To_char(:NEW.prixvisite) );
END;

-- Test du trigger
UPDATE TYPEVISITE SET prixvisite = 9;

-- Afficher message si prix visite à positionner est inférieur au prix courant
-- Utilisation de REFERENCING
CREATE or REPLACE TRIGGER tr_update_prixvisite1
  AFTER UPDATE OF prixvisite
  ON TYPEVISITE
  REFERENCING OLD AS ancien NEW AS nouveau
  FOR EACH ROW
    WHEN (ancien.prixvisite > nouveau.prixvisite)
  BEGIN
  -- Pas possible car table en mutation
  -- UPDATE TYPEVISITE SET prixvisite = :NEW.prixvisite;
  DBMS_OUTPUT.PUT_LINE ('PRIX VISITE ' || To_char(:ancien.prixvisite) 
  || ' SUPERIEUR AU SEUIL ' || To_char(:nouveau.prixvisite) );
END;

-- Test du trigger
UPDATE TYPEVISITE SET prixvisite = 7;

-- Apres un INSERT dans la table VISITE
-- Modification du nombre de visites de la table MEDECIN
CREATE OR REPLACE TRIGGER tr_update_medecin
AFTER INSERT
ON visite
-- References NEW ou OLD interdites dans declencheurs niveau table
-- donc FOR EACH ROW
FOR EACH ROW
BEGIN
		UPDATE medecin SET NBVISITES=NBVISITES+1
		WHERE medecin.NumeroMed = :new.NumeroMed;
END;

-- Test du trigger
INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE12','NUMEROMED1', '164042561678250', 
TO_DATE('1998/05/31 12:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE1');

/******************************************************************************* 
                                TRIGGERS
                    Prédicats INSERTING, DELETING et UPDATING
*******************************************************************************/

-- Trigger sur plusieurs evenements
-- Utilisation des prédicats INSERTING, DELETING et UPDATING
DELETE FROM LOG_LMD;
CREATE OR REPLACE TRIGGER tr_espion_medecin
AFTER INSERT or UPDATE or DELETE
ON MEDECIN
FOR EACH ROW
BEGIN
  -- SI insertion dans la table MEDECIN
  IF INSERTING THEN
    INSERT INTO LOG_LMD
    VALUES ('MEDECIN', sysdate, sys_context('USERENV','CURRENT_USER'), 'INSERT sur MEDECIN');
  -- SI suppression enregistrement dans la table MEDECIN
  ELSIF DELETING THEN
    INSERT INTO LOG_LMD
    VALUES ('MEDECIN', sysdate, sys_context('USERENV','CURRENT_USER'), 'DELETE sur MEDECIN');
  -- SINON modification enregistrement dans la table MEDECIN
  ELSE
    INSERT INTO LOG_LMD
    VALUES ('MEDECIN', sysdate, sys_context('USERENV','CURRENT_USER'), 'UPDATE sur MEDECIN');
  END IF;
END;

-- Test du trigger
INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE, NBVISITES) 
VALUES ('MED12', 'NOM12', 'PRENOM12', 'ADRESSE12', 31200, 'VILLE12', 'CODESPECIALITE3',0);
DELETE FROM MEDECIN WHERE NUMEROMED = 'MED12';
INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE, NBVISITES) 
VALUES ('MED12', 'NOM12', 'PRENOM12', 'ADRESSE12', 31200, 'VILLE12', 'CODESPECIALITE3',0);
UPDATE MEDECIN SET PRENOM='MARCEL' WHERE NUMEROMED = 'MED12';


/******************************************************************************* 
                                      TRIGGERS
                                 TABLE EN MUTATION
*******************************************************************************/

-- AVEC AFTER ET SANS PRAGMA Pas d'affichage de V_NOM
-- AVEC BEFORE affichage de V_NOM
CREATE OR REPLACE trigger TR_TEST_MUTATION
AFTER INSERT OR DELETE OR UPDATE ON VILLE
FOR EACH ROW
DECLARE
V_NOM VARCHAR2(30);
-- PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
 -- INSERT INTO VILLE (ID_VILLE,NOM) VALUES (2,'MARSEILLE');
 SELECT NOM INTO V_NOM FROM VILLE WHERE ID_VILLE = 1;
 DBMS_OUTPUT.PUT_LINE ('V_NOM : ' || V_NOM); 
EXCEPTION
  WHEN OTHERS THEN NULL;
END;

DELETE FROM VILLE;
INSERT INTO VILLE (ID_VILLE,NOM) 
VALUES (1,'BEAUVAIS');
INSERT INTO VILLE (ID_VILLE,NOM) 
VALUES (2,'MARSEILLE');
INSERT INTO VILLE (ID_VILLE,NOM) 
VALUES (3,'TOULOUSE');

SELECT * FROM all_errors WHERE NAME LIKE 'TR_TEST_MUTATION';

/******************************************************************************* 
                    TRIGGERS COMPOSES (depuis ORACLE 11G)
*******************************************************************************/

-- Un trigger composé peut comporter jusqu'à 4 sections correspondant chacune à 
-- un instant de déclenchement
-- Avant instruction (BEFORE STATEMENT)
-- Avant chaque ligne (BEFORE EACH ROW)
-- Après instruction (AFTER STATEMENT)
-- Après chaque ligne (AFTER EACH ROW)

-- Par rapport à l'utilisation de plusieurs triggers séparés
-- les différentes sections peuvent partager des déclarations communes (variables,
-- types, curseurs,....).

-- Syntaxe
/* 
CREATE TRIGGER <trigger_name>
FOR <triggering_event> ON <table_name>
COMPOUND TRIGGER

-- Avant l'instruction
BEFORE STATEMENT IS
BEGIN
  ...
END BEFORE STATEMENT;

-- Avant chaque ligne
BEFORE EACH ROW IS
BEGIN
  ...
END BEFORE EACH ROW;

-- Après l'instruction
AFTER STATEMENT IS
BEGIN
  ...
END AFTER STATEMENT;

-- Après chaque ligne
AFTER EACH ROW IS
BEGIN
  ...
END AFTER EACH ROW;
END compound_trigger;
*/

-- Exemple

DROP TABLE TEST_COMPOUND_TRIGGER;
CREATE TABLE TEST_COMPOUND_TRIGGER AS
SELECT table_name, tablespace_name
FROM user_tables;

CREATE OR REPLACE TRIGGER compound_trigger
FOR INSERT ON TEST_COMPOUND_TRIGGER
COMPOUND TRIGGER
-------------------------------
BEFORE STATEMENT IS
BEGIN
  dbms_output.put_line('BEFORE STATEMENT LEVEL');
END BEFORE STATEMENT;
-------------------------------
BEFORE EACH ROW IS
BEGIN
  dbms_output.put_line('BEFORE ROW LEVEL');
END BEFORE EACH ROW;
-------------------------------
AFTER STATEMENT IS
BEGIN
  dbms_output.put_line('AFTER STATEMENT LEVEL');
END AFTER STATEMENT;
-------------------------------
AFTER EACH ROW IS
BEGIN
  dbms_output.put_line('AFTER ROW LEVEL');
END AFTER EACH ROW;
END;

-- Vérifier si trigger a été créé
SELECT trigger_name, trigger_type
FROM user_triggers;

-- Déclenchement sur un insert
INSERT INTO TEST_COMPOUND_TRIGGER (table_name, tablespace_name)
VALUES ('MORGAN', 'USERS');

/******************************************************************************* 
                              TRIGGERS
                          BEFORE - AFTER
                    raise_application_error()
*******************************************************************************/

-- La procédure raise_application_error (error_number,error_message)
--    error_number doit être un entier compris entre -20000 et -20999
--    error_message doit être une chaîne de 500 caractères maximum.
-- Quand cette procédure est appelée, elle termine le trigger, défait la 
-- transaction (ROLLBACK), renvoie un numéro d'erreur défini (error_number) 
-- et un message à l'application (error_message)

-- Créer le trigger de type BEFORE
CREATE OR REPLACE trigger tr_insert_before_ville
	BEFORE INSERT ON ville           -- -> pas d'insertion
	FOR EACH ROW
	BEGIN
    IF (:new.ID_VILLE = 1) THEN
      	raise_application_error(-20001,'TRIGGER tr_insert_before_ville', FALSE);
    END IF;  
END;

-- Désactiver le trigger
ALTER TRIGGER tr_insert_before_ville DISABLE;

-- Créer le trigger de type AFTER
CREATE OR REPLACE trigger tr_insert_after_ville
  AFTER INSERT ON ville               -- -> pas d'insertion
	FOR EACH ROW
	BEGIN
    IF (:new.ID_VILLE = 1) THEN
      	raise_application_error(-20001,'TRIGGER tr_insert_after_ville', FALSE);
    END IF;  
END;

TRUNCATE TABLE VILLE;
INSERT INTO VILLE (ID_VILLE, NOM) VALUES (1, 'LYON');
SELECT * FROM VILLE;

/******************************************************************************* 
                    TRIGGERS SUR EVENEMENTS SYSTEME
*******************************************************************************/

-- Trigger sur login
-- Suite à un login, enregistrement d'infos dans la table TABLE_LOG_SYS
CREATE OR REPLACE TRIGGER tr_logon 
AFTER LOGON
  ON DATABASE
  BEGIN
 	 INSERT INTO TABLE_LOG_SYS (UserName, EventAction, EventDate, IPAddress, InstanceNum) 
  	VALUES (ora_login_user, ora_sysevent, sysdate, ora_client_ip_address, ora_instance_num);
  END;

-- Pour tester le trigger -> se déconnecter et se reconnecter
-- Puis visualiser le contenu de la table TABLE_LOG_SYS

/******************************************************************************* 
                                TRIGGERS LDD 
                        Langage de Définition des Données 
                            sur DATABASE ou SCHEMA
*******************************************************************************/

-- Sur ajout d'un commentaire
CREATE OR REPLACE TRIGGER tr_commentaire
AFTER COMMENT
ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ajout d''un commentaire ' || ora_login_user || 
    'Evenement : ' || ora_sysevent);
END;
-- Test du trigger
COMMENT ON TABLE "MEDECIN" IS 'Commentaire sur la table MEDECIN'

-- Sur renommage d'une table
CREATE OR REPLACE TRIGGER tr_rename
BEFORE RENAME
ON DATABASE
BEGIN
  DBMS_OUTPUT.PUT_LINE('Changement de nom de table');   
END;
-- Test du trigger
RENAME MEDECIN TO TOUBIB
RENAME TOUBIB TO MEDECIN

-- Sur un ordre LDD (Langage de Définition des Données)
CREATE OR REPLACE TRIGGER tr_ldd
BEFORE DDL
ON DATABASE
BEGIN
  DBMS_OUTPUT.PUT_LINE('Ordre LDD sur la base de données. Evenement : ' || ora_sysevent);   
END;
-- Test du trigger
COMMENT ON TABLE "MEDECIN" IS 'Commentaire sur la table MEDECIN'

-- Sur un ordre LDD
CREATE OR REPLACE TRIGGER tr_drop
BEFORE DROP
ON SCHEMA
BEGIN
  DBMS_OUTPUT.PUT_LINE('Impossible de supprimer un objet');   
END;
-- Test du trigger
DROP trigger tr_ldd

/******************************************************************************* 
                          TRIGGERS INSTEAD OF  
                                SUR VUE 
                  Insérer des données dans des tables à travers une vue
*******************************************************************************/

-- Création de la vue                                        
CREATE OR REPLACE VIEW visite_info 
AS
SELECT m.numeromed, m.nom, m.prenom, m.adresse, m.codepostal, m.ville, 
      m.codespecialite, m.nbvisites, v.numerovisite, 
v.numeross, v.datevisite, v.codetypevisite
FROM medecin m, visite v
WHERE m.numeromed = v.numeromed ORDER BY m.numeromed;

-- Test de la vue
SELECT * FROM visite_info;

-- Normalement cette vue ne peut pas permettre des modifications
-- parce que la clé primaire de la table VISITE (NumeroVisite) n'est pas unique
-- dans le résultat obtenu à partir de la jointure. 
-- Pour permettre à cette vue de faire des modifications, il faut créer un 
-- trigger INSTEAD OF sur la vue pour exécuter des INSERT

CREATE OR REPLACE TRIGGER visite_info_insert
INSTEAD OF INSERT ON visite_info
DECLARE
  duplicate_info EXCEPTION;
  PRAGMA EXCEPTION_INIT (duplicate_info, -00001);
BEGIN
  INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE, NBVISITES) 
  VALUES (:new.NUMEROMED,:new.NOM,:new.PRENOM,:new.ADRESSE,:new.CODEPOSTAL,:new.VILLE,:new.CODESPECIALITE,:new.NBVISITES);
  INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
  VALUES (:new.NUMEROVISITE,:new.NUMEROMED,:new.NUMEROSS,:new.DATEVISITE,:new.CODETYPEVISITE);
EXCEPTION
  WHEN duplicate_info THEN
    RAISE_APPLICATION_ERROR(-20107,'Duplicate medecin ou visite');
END;

-- Insérer des données dans les tables MEDECIN et VISITE à travers la vue 
-- ATTENTION : toutes les colonnes doivent recevoir une valeur
INSERT INTO visite_info VALUES
('MED23', 'NOM23', 'PRENOM23', 'ADRESSE23', 31200, 'VILLE23', 'CODESPECIALITE1', 0, 
'NUMEROVISITE23','164042561678250',TO_DATE('1998/07/31 12:10:00', 
'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE2');
