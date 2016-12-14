--
--      Erreur "ORA-04091 mutating table error
--

-- L'erreur de table en mutation apparait quand un trigger essaye 
-- de lire une table qui est en cours de changement
-- 
-- La solution envisag�e � l'erreur "ORA-04091 mutating table error" utilise
-- un package contenant 3 proc�dures ainsi que 3 triggers 

-- Dans l'exemple ci-dessous, un trigger essaye d'acc�der � une table (EMP)
-- qui est en cours de modification par un INSERT

DROP TABLE EMP;
DROP TABLE DEPT;

CREATE TABLE DEPT ( 
  deptNo     NUMBER(10,0) NOT NULL,
  deptName   VARCHAR2(50) NOT NULL,
  empCount   NUMBER(5,0) 
);
   
CREATE TABLE EMP ( 
  empNo      NUMBER(10,0) NOT NULL,
  deptNo     NUMBER(10,0) NOT NULL,
  empName    VARCHAR2(50) NOT NULL 
);

-- trigger qui permet de mettre � jour empCount de la table DEPT
-- d�s qu'un insert, update ou delete est effectu� sur la table EMP
CREATE OR REPLACE TRIGGER tr_ar_updateEmpCount
 AFTER INSERT OR UPDATE OR DELETE ON EMP
 FOR EACH ROW
 DECLARE
   -- Proc�dure de modification de empCount de la table DEPT
   PROCEDURE updateDept(p_deptNo IN NUMBER) IS
   BEGIN
     UPDATE DEPT
        SET empCount = (SELECT COUNT(*)
                           FROM EMP
                          WHERE deptNo = p_deptNo)
      WHERE deptNo = p_deptNo;
   END updateDept;
   
 BEGIN
   IF INSERTING THEN
     updateDept(:NEW.deptNo);
   ELSIF UPDATING THEN
     updateDept(:OLD.deptNo);
     updateDept(:NEW.deptNo);
   ELSIF DELETING THEN
     updateDept(:OLD.deptNo);
   END IF;
 END;

-- La table EMP est reli�e � la table DEPT via la colonne deptNo 
-- La colonne DEPT.empCount m�morise le nombre d'employ�s pour le d�partement 
-- concern� (pour l'exemple)
-- Le trigger modifie la colonne DEPT.empCount d�s que la table EMP change

-- Cr�ation des d�partements
INSERT INTO DEPT (deptNo, deptname, empCount)
VALUES (1,'Departement1',0);
INSERT INTO DEPT (deptNo, deptname, empCount)
VALUES (2,'Departement2',0);

-- Insertion d'un employ� --> d�clenchement du trigger
-- Erreur SQL : ORA-04091: la table ALGEBRE.EMP est en mutation
-- La table est utlis�e dans le trigger
INSERT INTO EMP (empNo, deptNo, empName)
VALUES (1, 1, 'Bob Marley');

--
-- Solution propos�e
-- 1 package avec :
--  3 proc�dures :
--    initialise;
--    updateDept(p_deptNo IN NUMBER);
--    finalise;
--  +
--  3 triggers : 
--    tr_bs_updateEmpCount
--    tr_ar_updateEmpCount
--    tr_as_updateEmpCount

--
-- Accrochez-vous !!!
--

-- Cr�ation d'un package qui stocke les valeurs de depNo pour chaque transaction
-- A la fin de la transaction, les colonnes sont modifi�es par un trigger 
-- de type AFTER qui peut lire la table

-- Ent�te du package : pour d�finir un package, vous devez tout d'abord d�finir
-- son ent�te qui contient juste la signature des proc�dures
CREATE OR REPLACE PACKAGE pk_updateEmpCount IS
   PROCEDURE initialise;
   PROCEDURE updateDept(p_deptNo IN NUMBER);
   PROCEDURE finalise;
END;

-- Corps du package : le corps contient le code de chaque proc�dure d�clar�e
-- dans l'ent�te
-- La proc�dure initialise est en charge d'initialiser les variables
-- La proc�dure updateDept prend en param�tre le num�ro de d�partement (deptNo). 
-- Ce num�ro est ajout� � la table g_dept table si il n'existe pas d�ja dans la table.
-- La proc�dure finalise modifie toutes les colonnes dept.empCount qui ont �t� modifi�es.
CREATE OR REPLACE PACKAGE BODY pk_updateEmpCount IS
   
   -- D�claration d'un TYPE t_int qui est une table d'entiers
   -- PLS_INTEGER : Nombre entier compris entre -2 147 483 647 et +2 147 483 647
   -- Plus rapide que BINARY_INTEGER car il utilise les registres du processeur 
   TYPE t_int IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
   
   -- D�claration de la variable g_dept qui est de type t_int
   g_dept t_int;
   -- D�claration de la variable g_idx qui est de type t_int
   g_idx t_int;
   g_count PLS_INTEGER := 0;
   
   -- Proc�dure d'initialisation des variables
   PROCEDURE initialise IS
   BEGIN
     DBMS_OUTPUT.PUT_LINE('initialise');
     g_dept.DELETE;
     g_idx.DELETE;
     g_count := 0;
   END initialise;
   
   PROCEDURE updateDept(p_deptNo IN NUMBER) IS
   BEGIN
     DBMS_OUTPUT.PUT_LINE('updateDept');
     IF g_dept(p_deptNo) IS NULL THEN
       -- ne rien faire
       NULL;
     END IF;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     g_count := g_count + 1;
     g_dept(p_deptNo) := 1;
     g_idx(g_count) := p_deptNo;
   END updateDept;
   
   PROCEDURE finalise IS
   BEGIN
     DBMS_OUTPUT.PUT_LINE('finalise');
     FOR i IN 1..g_count LOOP
       UPDATE dept
          SET empCount = (SELECT COUNT(*)
                             FROM emp
                            WHERE deptNo = g_idx(i))
        WHERE deptNo = g_idx(i);
     END LOOP;
     initialise;
   END finalise;
END;


-- Ce trigger de type before initialise le package pour les enregistrements
-- qui seront trait�es
-- Pour ce faire, ce trigger appelle la proc�dure initialise du package pk_updateEmpCount

CREATE OR REPLACE TRIGGER tr_bs_updateEmpCount
BEFORE INSERT OR UPDATE OR DELETE ON emp
BEGIN
  DBMS_OUTPUT.PUT_LINE('tr_bs_updateEmpCount');
  -- NonPackage.Nonproc�dure
  pk_updateEmpCount.initialise;
END;

-- Ce trigger de type AFTER/EACH ROW  passe chaque valeur de deptNo affect�e
-- au package
CREATE OR REPLACE TRIGGER tr_ar_updateEmpCount
AFTER INSERT OR UPDATE OF deptNo OR DELETE ON EMP
FOR EACH ROW
BEGIN
   DBMS_OUTPUT.PUT_LINE('tr_ar_updateEmpCount');
   IF INSERTING THEN
     pk_updateEmpCount.updateDept(:NEW.deptNo);
   ELSIF UPDATING THEN
     pk_updateEmpCount.updateDept(:OLD.deptNo);
     pk_updateEmpCount.updateDept(:NEW.deptNo);
   ELSIF DELETING THEN
     pk_updateEmpCount.updateDept(:OLD.deptNo);
   END IF;
END;

-- Ce trigger de type AFTER appelle la proc�dure qui traite la modification
-- de la table DEPT
CREATE OR REPLACE TRIGGER tr_as_updateEmpCount
AFTER INSERT OR UPDATE OR DELETE ON EMP
BEGIN
  DBMS_OUTPUT.PUT_LINE('tr_as_updateEmpCount');
  pk_updateEmpCount.finalise;
END;


-- SI vous ins�rez des enregistrements dans EMP
-- Vous voyez que le contenu de empCount de DEPT a �t� modifi�
-- ET plus d'erreur "ORA-04091 mutating table error" !!!!
-- Good job !!

INSERT INTO emp (empNo, deptNo, empName)
VALUES (1, 1, 'Bob Marley');

INSERT INTO emp (empNo, deptNo, empName)
VALUES (2, 1, 'Stevie Wonder');

INSERT INTO emp (empNo, deptNo, empName)
VALUES (3, 2, 'Miles Davis');

INSERT INTO emp (empNo, deptNo, empName)
VALUES (4, 2, 'John Coltrane');

INSERT INTO emp (empNo, deptNo, empName)
VALUES (5, 2, 'Charlie Parker');
