
/******************************************************************************* 
										TRANSACTIONS  
								TRANSACTION AUTONOME 
*******************************************************************************/

-- AUTONOMOUS_TRANSACTION
-- Tells the compiler that the function, procedure, top-level anonymous PL/SQL block, object method, or database
-- trigger executes in its own transaction space. 

-- Autonomous transactions execute within a block of code as separate transactions from the outer (main) transaction.
-- Changes can be committed or rolled back in an autonomous transaction without committing or rolling back the main transaction. 
-- Changes committed in an autonomous transaction are visible to the main transaction, even though they
-- occur after the start of the main transaction. 
-- Those changes committed in an autonomous transaction are visible to other transactions as well. 
-- The database suspends the main transaction while the autonomous transaction executes:

-- PROCEDURE main IS
-- BEGIN
-- UPDATE ... -- Main transaction begins here.
-- DELETE ...
-- at_proc; -- Call the autonomous transaction.
-- SELECT ...
-- INSERT ...
-- COMMIT; -- Main transaction ends here.
-- END;

-- PROCEDURE at_proc IS
-- PRAGMA AUTONOMOUS_TRANSACTION;
-- BEGIN -- Main transaction suspends here.
-- SELECT ...
-- INSERT ... -- Autonomous transaction begins here.
-- UPDATE ...
-- DELETE ...
-- COMMIT; -- Autonomous transaction ends here.
-- END; -- Main transaction resumes here.


-------------------------------------------------------------------------------------
-- 			EXEMPLES
-------------------------------------------------------------------------------------

CREATE TABLE COURS 
( CODECOURS CHAR(25 BYTE) NOT NULL ENABLE, 
	NOMCOURS VARCHAR2(25 BYTE),
  CONSTRAINT PK_COURS PRIMARY KEY (CODECOURS)
);

INSERT INTO COURS (CODECOURS, NOMCOURS) VALUES ('CODECOURS1', 'Libelle Cours 1');
INSERT INTO COURS (CODECOURS, NOMCOURS) VALUES ('CODECOURS2', 'Libelle Cours 2');
INSERT INTO COURS (CODECOURS, NOMCOURS) VALUES ('CODECOURS3', 'Libelle Cours 3');

-- 1ER EXEMPLE

-- AVEC AUTONOMOUS_TRANSACTION, la modification est réalisée
-- SANS AUTONOMOUS_TRANSACTION, la modification n'est pas réalisée
CREATE or REPLACE PROCEDURE nom_correct
AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    -- Mettre CODECOURS en lettres minuscules
    UPDATE COURS set CODECOURS=initcap(CODECOURS);
    --UPDATE COURS set CODECOURS=upper(CODECOURS);
    COMMIT;
END;

SELECT * FROM COURS;

-- Bloc anonyme
BEGIN
  -- Appel de la procédure
  nom_correct();
  -- Annulation des modifications avec ROLLBACK -> pris en compte si 
  -- AUTONOMOUS_TRANSACTION n'est pas présent dans la procédure
  ROLLBACK;
END;

SELECT * FROM COURS;

-- 2EME EXEMPLE

CREATE or REPLACE PROCEDURE nom_correct_initcap
AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    UPDATE COURS set CODECOURS=initcap(CODECOURS);
    COMMIT;
END;

CREATE or REPLACE PROCEDURE nom_correct_upper
AS
--PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    UPDATE COURS set CODECOURS=upper(CODECOURS);
    --COMMIT;
END;

DECLARE
  v_cours cours%ROWTYPE;
  CURSOR c1 IS SELECT * FROM cours;
BEGIN
  nom_correct_initcap();
  FOR v_cours IN c1 LOOP
    DBMS_OUTPUT.PUT_LINE ('Code du cours : ' || v_cours.codecours || '   ' || v_cours.nomcours);
  END LOOP;
  
  nom_correct_upper();
  /* 08177. 00000 -  "can't serialize access for this transaction"
    *Cause:    Encountered data changed by an operation that occurred after
           the start of this serializable transaction.*/
  ROLLBACK;
  FOR v_cours IN c1 LOOP
    DBMS_OUTPUT.PUT_LINE ('Code du cours : ' || v_cours.codecours || '   ' || v_cours.nomcours);
  END LOOP;
END;

