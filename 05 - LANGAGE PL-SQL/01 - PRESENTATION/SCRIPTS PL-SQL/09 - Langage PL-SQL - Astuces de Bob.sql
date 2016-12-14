/****************************************************************************** 
          SOMMAIRE

                    � PSEUDO COLONNES : ROWID, USER, SYSDATE, ROWNUM
                    � Pour poursuivre le traitement apr�s qu�une exception soit lev�e
                    � Utilisation d�une variable pour localiser l�exception
                    � Essayer de nouveau une transaction.
                    � Suppression de toutes les tables d'un schema
                    � Utilisation d'un trigger pour insertion cle primaire avec s�quence
                    � R�cup�rer le nom des colonnes d'une table
                    
******************************************************************************/

/******************************************************************************* 
                            PSEUDO COLONNES
                      ROWID, USER, SYSDATE, ROWNUM
*******************************************************************************/

/*
A chaque table Oracle est associ�e un ensemble de
colonnes implicites. Ces colonnes sont aussi
appel�es Pseudo Colonnes. Citons par exemple les
colonnes ROWID, USER, SYSDATE, ROWNUM,

� ROWID
� L'adresse d'un tuple, compos� de quatre champs:
� Le num�ro de bloc dans le fichier,
� Le num�ro de tuple dans le bloc et
� Le num�ro de fichier,
� Le num�ro de segment
� USER : L'utilisateur actuellement connect�
� SYSDATE : la date syst�me
� ROWNUM : Num�ro des lignes r�sultats d'une requ�te SQL
 */
 
SELECT  ROWID, USER, SYSDATE, ROWNUM 
FROM MEDECIN;

-- ASTUCE 1
-- Pour poursuivre le traitement apr�s qu�une exception soit lev�e, 
-- vous devez d�finir des sous blocs
DECLARE
  BEGIN
    -- Sous bloc
    BEGIN
      DBMS_OUTPUT.PUT_LINE ('AVANT DELETE');
      DELETE FROM SPECIALITE WHERE CodeSpecialite = 'CODESPECIALITE1';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE ('TRAITEMENT EXCEPTION');
    -- Fin sous bloc
    END;
    DBMS_OUTPUT.PUT_LINE ('TRAITEMENT SUIVANT');
END;

-- ASTUCE 2
-- Utilisation d�une variable pour localiser l�exception.
-- L�utilisation d�un traitement d�exceptions pour une s�quence de requ�tes, 
-- telles que INSERT, DELETE, UPDATE ou SELECT, peut masquer la requ�te qui est
-- � l�origine de l�erreur.
-- Si vous avez besoin de conna�tre quelle requ�te �choue, vous pouvez utiliser 
-- une variable qui permet de localiser la requ�te � l�origine de l�exception.

DECLARE
 	no_stmt INTEGER;
 	name VARCHAR2(100);
BEGIN
  no_stmt:= 1;  -- D�signe le 1er SELECT
  SELECT table_name INTO name FROM user_tables WHERE table_name LIKE 'MEDES%';
  no_stmt:= 2;  -- D�signe le 2�me SELECT
  SELECT table_name INTO name FROM user_tables WHERE table_name LIKE 'MEDEC%';
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('NOM DE TABLE NON TROUVEE DANS LA REQUETE N� : ' || no_stmt);
END;

-- ASTUCE 3
-- Essayer de nouveau une transaction.
-- Apr�s qu�une exception soit lev�e, soit vous abandonnez la transaction, 
-- soit vous effectuez une nouvelle tentative. 
-- La technique est la suivante :
--    �	Mettre la transaction dans un sous bloc
--    �	Placer le sous bloc � l�int�rieur d�une boucle que r�p�te dans la transaction 
--    �	Avant de d�marrer la transaction, placer un savepoint. Si la transaction r�ussie,  
--      effectuez un commit et quittez la boucle. Si la transaction �choue, 
--      le contr�le est transf�r� au handler d�exception, dans lequel vous 
--      effectuez un rollback � partir du savepoint, puis essayez de fixer le probl�me.

DECLARE
   numeromed VARCHAR2(12) := 'NUMEROMED4';
   nom VARCHAR2(25) :=  'NOM4';
   prenom VARCHAR2(25) := 'PRENOM4';
   adresse VARCHAR2(25) := 'ADRESSE4';
   codepostal NUMBER(5,0) := 31200;
   ville CHAR(25) := 'VILLE4';
   codespecialite CHAR(25) := 'CODESPECIALITE3';
   nbvisites NUMBER(5,0) := 0;
   suffix NUMBER := 1;
BEGIN
-- Essayer 10 fois
FOR i IN 1..10 LOOP
  -- Sous bloc BEGIN
  BEGIN 
    -- Placer un savepoint
    SAVEPOINT start_transaction; 
    -- Supprimer un enregistrement de la table TYPEVISITE
    DELETE FROM TYPEVISITE WHERE CODETYPEVISITE = 'CODETYPEVISITE5';
    -- Ajouter un medecin 
    INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE, NBVISITES) 
      VALUES (numeromed, nom, prenom, adresse, codepostal, ville, codespecialite,nbvisites);
    --	raises DUP_VAL_ON_INDEX Si 2 medecins ont le meme numero
    -- Si ok alors valider les modifications (DELETE et INSERT) avec COMMIT
    COMMIT;
    -- Quitter la boucle
    EXIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX  THEN
              -- Annuler les modifications notamment le DELETE
              ROLLBACK TO start_transaction;
              -- Ajouter un suffixe pour essayer de r�soudre le probleme 
              suffix := suffix + 1; 
               DBMS_OUTPUT.PUT_LINE ('Nom du m�decin : ' || suffix);
              numeromed := numeromed || TO_CHAR(suffix);
              DBMS_OUTPUT.PUT_LINE ('Nom du m�decin : ' || numeromed);
    -- Fin du sous bloc
    END;  
END LOOP;
END;

-- Suppression de toutes les tables d'un schema
CREATE or REPLACE PROCEDURE dropAllTables
IS
  CURSOR c1 IS SELECT table_name FROM user_tables;
BEGIN
  FOR v_name IN c1 LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || v_name.table_name;
    -- DBMS_OUTPUT.PUT_LINE ('Nom de la table : '||v_name.table_name);
  END LOOP;
END;

-- Utilisation d'un trigger pour insertion cle primaire avec s�quence

-- Cr�ation de la table
CREATE TABLE "VILLE" 
(	"ID_VILLE" NUMBER, 
	"NOM" VARCHAR2(25 BYTE) NOT NULL ENABLE,
  "CODEPOSTAL" CHAR(5 BYTE) NOT NULL ENABLE
);

DROP SEQUENCE SQ_VILLE;
CREATE SEQUENCE SQ_VILLE
START WITH 1 INCREMENT BY 1 NOMAXVALUE;

-- Rappel : insertion enregistrement avec cl� primaire = valeur s�quence 
INSERT INTO VILLE (ID_VILLE, NOM, CODEPOSTAL) 
VALUES (SQ_VILLE.nextval, 'LYON', '69000');

-- Trigger permettant d'ins�rer automatiquement sur une requ�te insert la 
-- cl� primaire
CREATE OR REPLACE trigger tr_sq_ville
  -- Vous devez utiliser BEFORE car il y a une modification de new.ID_VILLE
  -- Pas possible de modifier new.ID_VILLE avec AFTER
	BEFORE INSERT ON ville
	FOR EACH ROW
	BEGIN
    -- Affecter � ID_VILLE (cl� primaire) la prochaine valeur de la s�quence
    -- SQ_VILLE
		SELECT SQ_VILLE.nextval INTO :new.ID_VILLE 
		FROM dual;
    -- ou
    -- :new.ID_VILLE := SQ_VILLE.nextval; 
END;

-- Tests 
INSERT INTO VILLE (ID_VILLE, NOM, CODEPOSTAL) 
VALUES ('', 'LYON', '69000');
INSERT INTO VILLE (ID_VILLE, NOM, CODEPOSTAL) 
VALUES ('', 'TOULOUSE', '31000');
INSERT INTO VILLE (ID_VILLE, NOM, CODEPOSTAL) 
VALUES ('', 'BORDEAUX', '33000');

INSERT INTO VILLE (NOM, CODEPOSTAL) 
VALUES ('BEAUVAIS', '60000');

INSERT INTO VILLE
VALUES ('', 'BEAUVAIS','60000');

-- Tester les valeurs de :new et :old sur INSERT OR DELETE OR UPDATE
CREATE OR REPLACE trigger tr_ville
AFTER INSERT OR DELETE OR UPDATE ON VILLE
	FOR EACH ROW
	BEGIN
  
    DBMS_OUTPUT.PUT_LINE ('Valeur :new de ID_VILLE -> '||:new.ID_VILLE);
    DBMS_OUTPUT.PUT_LINE ('Valeur :old de ID_VILLE -> '||:old.ID_VILLE);
    
    DBMS_OUTPUT.PUT_LINE ('Valeur :new de NOM -> '||:new.NOM);
    DBMS_OUTPUT.PUT_LINE ('Valeur :old de NOM -> '||:old.NOM);
    
    DBMS_OUTPUT.PUT_LINE ('Valeur :new de CODEPOSTAL -> '||:new.CODEPOSTAL);
    DBMS_OUTPUT.PUT_LINE ('Valeur :old de CODEPOSTAL -> '||:old.CODEPOSTAL);
END;

INSERT INTO VILLE (NOM, CODEPOSTAL) 
VALUES ('BEAUVAIS', '60000');

UPDATE VILLE set nom = 'LILLE' where ID_VILLE =1;

DELETE VILLE where ID_VILLE =1;

-- ASTUCE 4
-- R�cup�rer le nom des colonnes d'une table
-- Utilisation de la table user_tab_columns

DECLARE
  -- D�claration du curseur
  CURSOR c1 IS SELECT column_name FROM user_tab_columns WHERE table_name ='AVION';
BEGIN
  -- Ouverture implicite du curseur par le FOR
  -- Ex�cution du FETCH par le FOR
  FOR v_column_name IN c1 LOOP
    DBMS_OUTPUT.PUT_LINE ('Nom de la colonne : ' || v_column_name.column_name);
  END LOOP;
END;
