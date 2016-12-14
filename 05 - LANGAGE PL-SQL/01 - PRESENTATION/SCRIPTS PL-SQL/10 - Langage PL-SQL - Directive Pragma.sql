/******************************************************************************* 
                           Directive PRAGMA
                            
                   �  PRAGMA EXCEPTION_INIT
                   �  PRAGMA AUTONOMOUS_TRANSACTION dans une proc�dure
                   �  PRAGMA AUTONOMOUS_TRANSACTION dans un trigger
                   �  PRAGMA AUTONOMOUS_TRANSACTION pour r�soudre probl�me de
                      table en mutation
*******************************************************************************/

-- PRAGMA est une directive de compilation qui est trait�e au moment 
-- de la compilation.
 
--------------------------------------------------------------------------------
-- PRAGMA EXCEPTION_INIT
-- Dire au compilateur d'associer le num�ro d'erreur sp�cifi�
-- avec un identifiant d'une exception qui a �t� d�clar� dans le programme

-- Gestion de l'exception 2292 avec lien avec un code d'erreur : EXCEPTION_INIT
-- Exemple : entre les tables MEDECIN et SPECIALITE, il existe une contrainte 
-- de cl� �trang�re (un m�decin a une sp�cialit�). 
-- Lorsqu�on veut supprimer une sp�cialit� qui est rattach�e � au moins 
-- un m�decin, on obtient l�erreur : ORA-02292: violation de 
-- contrainte (HR.FK_MEDECIN_SPECIALITE) d�int�grit� - enregistrement fils existant.
--------------------------------------------------------------------------------

CREATE or REPLACE PROCEDURE supprimerSpecialite
IS
  exSpecialite EXCEPTION;
  -- Associer l'erreur ORA-02292 � exSpecialite
  PRAGMA EXCEPTION_INIT(exSpecialite, -2292);
BEGIN
  DELETE FROM SPECIALITE WHERE CodeSpecialite = 'CODESPECIALITE1';
EXCEPTION
WHEN exSpecialite THEN
  DBMS_OUTPUT.PUT_LINE ('SUPPRESSION IMPOSSIBLE DE LA SPECIALITE');
END;

-- Ex�cution de la proc�dure
EXECUTE supprimerSpecialite;

--------------------------------------------------------------------------------
-- PRAGMA AUTONOMOUS_TRANSACTION
--
-- Dire au compilateur que la fonction, la proc�dure, le trigger, le boc
-- anonyme s'ex�cute dans son propre espace de transaction
--------------------------------------------------------------------------------

DROP TABLE t_message1;
CREATE TABLE t_message1 ( 
  msg varchar2(64) 
);

-- Proc�dure AVEC PRAGMA AUTONOMOUS_TRANSACTION
CREATE OR REPLACE PROCEDURE Autonomous_Insert
AS
  -- Proc�dure dans une transaction autonome
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_message1 VALUES ('Message - Autonomous Insert');
  COMMIT;
END;

-- Proc�dure SANS PRAGMA AUTONOMOUS_TRANSACTION
CREATE OR REPLACE PROCEDURE NonAutonomous_Insert
AS
BEGIN
  INSERT INTO t_message1 VALUES ('Message - NonAutonomous Insert');
  -- Valider la transaction
  COMMIT;
END;

-- Appel de la proc�dure NonAutonomous_Insert
BEGIN
  INSERT INTO t_message1 VALUES ('Message - Bloc Anonyme');
  NonAutonomous_Insert;
  -- Annuler la transaction
  ROLLBACK;
END;

SELECT * FROM t_message1;

--> R�sultat obtenu : les 2 insert ont eu lieu. Le rollback n'a pas eu d'effet
-- MSG                                                          
---------------------------------
-- Message - Bloc Anonyme                                          
-- Message - NonAutonomous Insert 

DELETE from t_message1;

-- Appel de la proc�dure Autonomous_Insert
BEGIN
  INSERT INTO t_message1 VALUES ('Message - Bloc Anonyme');
  Autonomous_Insert;
  ROLLBACK;
END;

SELECT * FROM t_message1;

--> R�sultat obtenu : l'insert de 
-- MSG                                                            
---------------------------------                                       
-- Message - Autonomous Insert 

--------------------------------------------------------------------------------
-- Trigger AVEC PRAGMA AUTONOMOUS_TRANSACTION
--------------------------------------------------------------------------------

DROP TABLE t_message2;
CREATE TABLE t_message2 ( 
  msg varchar2(64) 
);

DELETE from t_message1;

CREATE OR REPLACE TRIGGER tr_autonomous_tx
  BEFORE INSERT
  ON t_message1
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_message2 VALUES ('Message - Trigger');
  COMMIT; 
END;

-- Message trop long pour insertion dans t_message1
INSERT INTO t_message1 VALUES ('Message Insert - Bloc Anonyme - - 
Bloc Anonyme - Bloc Anonyme - Bloc Anonyme - Bloc Anonyme');

SELECT * FROM t_message1;
SELECT * FROM t_message2;

-- Sans PRAGMA AUTONOMOUS_TRANSACTION
-- --> table t_message2 est vide

-- Avec PRAGMA AUTONOMOUS_TRANSACTION
-- --> table t_message2 contient le message 'Message - Trigger'


-------------------------------------------------------------------------------
-- Probl�me de table en mutation
-- Probl�me r�solu en utilisant PRAGMA AUTONOMOUS_TRANSACTION
-------------------------------------------------------------------------------

CREATE TABLE t_table1 (val int);
CREATE TABLE t_table2 (val int);

INSERT INTO t_table1 VALUES (1);

SELECT * FROM t_table1;
SELECT * FROM t_table2;

CREATE OR REPLACE TRIGGER t_trigger
 AFTER INSERT
 ON t_table1
 FOR EACH ROW
DECLARE
  -- PRAGMA AUTONOMOUS_TRANSACTION;
  nb PLS_INTEGER;
BEGIN
   SELECT COUNT(*) INTO nb
   FROM t_table1;

   INSERT INTO t_table2
   VALUES (nb);
   
  -- COMMIT;
END;

-- Effectuer un insert dans t_table1 pour d�clencher t_trigger
INSERT INTO t_table1 VALUES (2);

--> R�sultat obtenu SANS PRAGMA AUTONOMOUS_TRANSACTION et COMMIT
-- Erreur SQL : ORA-04091: la table EXEMPLES.T_TABLE1 est en mutation ; 
-- le d�clencheur ou la fonction ne peut la voir

--> R�sultat obtenu AVEC PRAGMA AUTONOMOUS_TRANSACTION et COMMIT
-- Pas d'erreur
-- Insertion dans t_table1 s'est effectu�e correctement
-- Insertion dans t_table2 s'est effectu�e correctement 

SELECT COUNT(*) FROM t_table1;
SELECT COUNT(*) FROM t_table2;
