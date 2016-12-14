/******************************************************************************* 
                            TYPES COMPOSES
                            RECORD - TABLE
*******************************************************************************/
--
-- Utilisation d'un type composé RECORD
--

DECLARE

	-- Déclaration du type RECORD nomme t_medecin
	TYPE t_medecin IS RECORD(
		nom VARCHAR2(15),
		prenom VARCHAR2(20)
	);
  
	-- Déclaration de la variable nommées v_medecin du type RECORD t_medecin
	v_medecin t_medecin;
BEGIN
  SELECT NOM, PRENOM
  INTO v_medecin.nom, v_medecin.prenom
  FROM MEDECIN WHERE NUMEROMED = 'NUMEROMED1';

  DBMS_OUTPUT.PUT_LINE ('NOM DU MEDECIN : ' || v_medecin.nom);
  DBMS_OUTPUT.PUT_LINE ('PRENOM DU MEDECIN : ' || v_medecin.prenom);
END;

--
-- Utilisation d'un type composé INDEX-BY TABLE
-- Couple clé/valeur
-- Chaque clé est unique 
-- Une clé peut être un entier ou une chaine

-- Syntaxe :
--  TYPE type_name IS TABLE OF element_type [NOT NULL] INDEX BY subscript_type;
--  table_name type_name;

DECLARE
  -- Déclaration du type TABLE nommé t_nommedecin
  TYPE t_nommedecin IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
  
  -- Déclaration de la variable nommée v_nom du type TABLE t_nommedecin
  v_nom t_nommedecin;
  
  -- Index de la table v_nom
  v_index integer;
BEGIN
  v_nom(5):='Bob';
  
  v_index:=2;
  v_nom(v_index):='Steve';
  
  DBMS_OUTPUT.PUT_LINE ('NOM DU MEDECIN : ' || v_nom(5));
  DBMS_OUTPUT.PUT_LINE ('PRENOM DU MEDECIN : ' || v_nom(v_index));
  
END;

-- 
-- Utilisation d'un type composé TABLE contenant des enregistrements
-- Affectation champ par champ
--

DECLARE
  CURSOR c1 IS SELECT * FROM COMMANDE;
  TYPE rec_comm IS TABLE OF COMMANDE%ROWTYPE INDEX BY BINARY_INTEGER;
  test_row rec_comm;
BEGIN 
  FOR cur IN c1 LOOP 
    test_row(C1%rowcount).numcom := cur.numcom;
    test_row(C1%rowcount).datecom := cur.datecom;
    dbms_output.put_line(' Numero commande ' || test_row(C1%rowcount).numcom 
    || '   Date commande ' || test_row(C1%rowcount).datecom);
  END LOOP;
END;

--
-- Utilisation d'un type composé TABLE contenant des enregistrements (ROWTYPE)
-- Affectation enregistrement par enregistrement
--

DECLARE
  CURSOR c_comm IS SELECT * FROM COMMANDE;
  TYPE t_comm IS TABLE OF COMMANDE%ROWTYPE INDEX BY BINARY_INTEGER;
  table_comm t_comm;
BEGIN
  FOR enr_cur IN c_comm
    LOOP
      table_comm(c_comm%rowcount-1) := enr_cur;
      dbms_output.put_line(to_char(table_comm(c_comm%rowcount-1).numcom));
    END LOOP;
END;

--
-- Utilisation d'un type composé TABLE à 2 dimensions
--

DECLARE
  TYPE TYP_TAB IS TABLE OF VARCHAR2(100) INDEX BY binary_integer;
  TYPE TYP_TAB_TAB IS TABLE of TYP_TAB INDEX BY binary_integer;
  
  tab TYP_TAB_TAB;
  i integer := 1;
  j integer := 1;
BEGIN
  -- remplissage du tableau
  FOR i IN 1..10 LOOP
    FOR j IN 1..10 LOOP 
      tab(i)(j) := to_char(i) || '-' || to_char(j);
    END LOOP;
  END LOOP;
  -- Affichage du contenu du tableau
  FOR i IN 1..10 LOOP
    FOR j IN 1..10 LOOP 
      dbms_output.put_line(tab(i)(j));
    END LOOP;
  END LOOP;
END;

--
-- Utilisation d'un type composé NESTED TABLE
--
-- A nested table is like a one-dimensional array with an arbitrary number of elements. 
-- However, a nested table differs from an array in the following aspects:
--    - An array has a declared number of elements, but a nested table does not. 
--      The size of a nested table can increase dynamically.
--    - An array is always dense, i.e., it always has consecutive subscripts. 
--      A nested array is dense initially, but it can become sparse when elements are deleted from it.

-- A nested table can be stored in a database column and so it could be used for 
-- simplifying SQL operations where you join a single-column table with a larger table. 

-- Syntaxe : This declaration is similar to declaration of an index-by table, 
--           but there is no INDEX BY clause.
--  TYPE type_name IS TABLE OF element_type [NOT NULL];
--  table_name type_name;

DECLARE
   TYPE table_name IS TABLE OF VARCHAR2(10);
   names table_name;
   total integer;
BEGIN
   names := table_name('Bob', 'Steve', 'Keith', 'Charlie', 'Miles');
   total := names.count;
   dbms_output.put_line('Total '|| total || ' Jazzmen');
   FOR i IN 1 .. total LOOP
      dbms_output.put_line('Jazzman : '||names(i));
   end loop;
END;
