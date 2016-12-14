
/****************************************************************************** 
          SOMMAIRE
                         
                    • CURSEURS EXPLICITES
                    • CURSEURS : CURRENT OF (Mise à jour de données)
                    • CURSEURS IMPLICITES
                    • CREER DES TYPES : TABLE - REF CURSOR
                    • CURSEURS IMBRIQUES
                      
******************************************************************************/


/******************************************************************************* 
                            CURSEURS EXPLICITES
*******************************************************************************/

-- Un curseur explicite est créé par l’utilisateur pour pouvoir traiter 
-- le résultat d’une requête SELECT retournant plusieurs lignes. 
-- Les informations liées à son exécution sont disponibles grâce aux 
-- attributs de curseur

-- Statuts d’un curseur
-- %FOUND    Vrai si le dernier FETCH a pu obtenir une nouvelle ligne résultat
-- %NOTFOUND Vrai si le dernier FETCH n’a pas pu obtenir une nouvelle ligne résultat
-- %ISOPEN   Vrai si le curseur est ouvert
-- %ROWCOUNT renvoie le nombre de lignes traitées par l'ordre SQL
--           il évolue à chaque ligne distribuée
-- Un statut est associé à un curseur
-- curseur implicite   SQL%...
-- curseur explicite   nom_curseur%...

-- Bloc anonyme avec boucle LOOP - END LOOP
-- Création d'un curseur
-- Parcours du curseur : FETCH
DECLARE
  -- Déclaration d'une variable correspondant au type du champ nom
  -- de la table medecin
  v_nommedecin medecin.nom%TYPE;
  -- Déclaration du curseur
  -- Cette déclaration doit se faire dans la section de déclaration (DECLARE) d’un bloc PL/SQL.
  CURSOR c1 IS SELECT nom FROM medecin;
BEGIN
  -- Ouverture du curseur
  -- -> L’allocation mémoire du curseur.
  -- -> L’analyse syntaxique et sémantique de l’ordre SELECT.
  -- -> L’exécution de la requête associée.
  OPEN c1; 
  
  -- Boucle pour traiter le résultat = plusieurs lignes
  LOOP
    -- Récupération de la ligne suivante
    FETCH c1 INTO v_nommedecin;
    -- Sortir de la boucle si plus de ligne à lire
    EXIT WHEN c1%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE ('Nom du médecin : ' || v_nommedecin);
  END LOOP;
  -- Fermeture du curseur --> libération de l'espace mémoire utilisé
  -- par le curseur
  -- Remarque : Après la fermeture d’un curseur, il n’est plus
  -- possible de l’utiliser
  CLOSE c1;
END;

-- Bloc anonyme avec boucle WHILE - END LOOP
-- Création d'un curseur
-- Parcours du curseur : FETCH
DECLARE
  -- Déclaration d'une variable correspondant au type du champ nom
  -- de la table medecin
  v_nommedecin medecin.nom%TYPE;
  
  -- Déclaration du curseur
  -- Instruction SELECT retroune plus d'un enregistrement 
  -- --> utilisation d'un curseur
  CURSOR c_medecin IS SELECT nom FROM medecin;
BEGIN
  -- Ouverture du curseur
  OPEN c_medecin;
  
  -- Récupération de la 1ère ligne du curseur
  FETCH c_medecin INTO v_nommedecin;
  
  -- TANT QU'il existe des lignes
  WHILE c_medecin%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE ('Nom du médecin : ' || v_nommedecin);
    
    -- Récupération de la ligne suivante
    FETCH c_medecin INTO v_nommedecin;
  -- FIN TANT QUE
  END LOOP;
  
  -- Fermeture du curseur --> libération de l'espace mémoire utilisée
  -- par le curseur
  CLOSE c_medecin;
END;

-- Parcours du curseur : FETCH
-- Nombre de lignes : %ROWCOUNT
-- Tester l'ouverture avec %ISOPEN
DECLARE
  -- Déclaration d'une variable correspondant au type du champ nom
  -- de la table medecin
  v_medecin medecin.nom%TYPE;
  
  -- Déclaration du curseur
  CURSOR c_medecin IS SELECT nom FROM medecin;
BEGIN
  -- Ouverture du curseur
  -- -> L’allocation mémoire du curseur.
  -- -> L’analyse syntaxique et sémantique de l’ordre SELECT.
  -- -> L’exécution de la requête associée.
  OPEN c_medecin; 
  
  -- Boucle pour lire les lignes résultantes de la requête
  LOOP
    -- Lecture de la ligne suivante et mémorisation dans la variable v_medecin
    FETCH c_medecin INTO v_medecin;  
    
    -- Sortir de la boucle si plus de ligne à lire
    EXIT WHEN c_medecin%NOTFOUND;
    
    -- Affichage du contenu de la variable
    DBMS_OUTPUT.PUT_LINE ('Nom du medecin : ' || v_medecin);
    
  -- FIN DE Boucle
  END LOOP;
  
  -- Affichage du nombre de médecins
  DBMS_OUTPUT.PUT_LINE ('Nombre de medecins : ' || c1%ROWCOUNT);
  
  -- SI curseur ouvert
  IF c_medecin%ISOPEN THEN
  
    -- Fermeture du curseur --> libération de l'espace mémoire utilisée
    -- par le curseur
    CLOSE c_medecin;
    
  -- FINSI curseur ouvert
  END IF;
END;

-- Bloc anonyme
-- Création d'un curseur
-- Parcours du curseur : FOR
DECLARE
  -- Déclaration d'une variable équivalente à un enregistrement de la 
  -- table medecin --> inutile avec un FOR (il le fait !!!)
  -- v_medecin medecin%ROWTYPE;
  
  -- Déclaration du curseur
  CURSOR c1 IS SELECT * FROM medecin;
  
BEGIN
  -- Ouverture implicite du curseur par le FOR
  -- Exécution du FETCH par le FOR
  FOR v_medecin IN c1 LOOP
    DBMS_OUTPUT.PUT_LINE ('Nom du médecin : ' || v_medecin.prenom || ' ' 
                          || v_medecin.nom);
    -- Nouvelle ligne
    DBMS_OUTPUT.NEW_LINE;
    
    -- Nombre de ligne traitées
    DBMS_OUTPUT.PUT_LINE ('Nombre : ' || c1%ROWCOUNT);
    
  -- Fermeture implicite du curseur par le END LOOP
  END LOOP;
END;

-- Bloc anonyme
-- Parcours du curseur : FOR 
-- avec requête dans le FOR
DECLARE
  -- Déclaration d'une variable équivalente à un enregistrement de la 
  -- table medecin --> inutile avec un FOR (il le fait !!!)
  -- v_medecin medecin%ROWTYPE;
BEGIN
  -- Requête intégrée directement dans le FOR
  FOR v_medecin IN (SELECT * FROM medecin) LOOP
    DBMS_OUTPUT.PUT_LINE ('Nom du médecin : ' || v_medecin.prenom || ' ' || v_medecin.nom);
  END LOOP;
END;

/******************************************************************************* 
                            CURSEURS PARAMETRES
                            CHAUD DEVANT !!!!
*******************************************************************************/

/*
Objectif : utiliser un même curseur avec des valeurs différentes, 
dans un même bloc PL/SQL

Syntaxe : 
DECLARE CURSOR nom_c (par1 type, par2 type,…) IS ordre_select;
BEGIN 
OPEN nom_c(val1, val2,…) ;

Type : char, number, date, boolean SANS spécifier la longueur.
Passage des valeurs des paramètres à l'ouverture du curseur.
*/

DECLARE
  CURSOR c_medecins IS select distinct numeromed from medecin;
  CURSOR c_visites(pmed varchar2) IS select numerovisite, numeross, datevisite 
  from visite where numeromed = pmed;
BEGIN
  FOR v_med IN c_medecins LOOP
    DBMS_OUTPUT.PUT_LINE ('Medecin : ' || v_med.numeromed);
    FOR v_visite IN c_visites(v_med.numeromed) LOOP
     DBMS_OUTPUT.PUT_LINE ('   Numéro visite : ' || v_visite.numerovisite);
     DBMS_OUTPUT.PUT_LINE ('   Date visite : ' || v_visite.datevisite);
    END LOOP;
  END LOOP;
END;

/******************************************************************************* 
                              CURSEURS
                            FOR UPDATE OF
                             CURRENT OF
                        Mise à jour de données 
*******************************************************************************/

-- Lorsqu’une ligne stockée dans un curseur est lue par un FETCH, 
-- il est possible de mettre à jour directement cette ligne dans la table. 
-- Pour cela, il faut utiliser FOR UPDATE OF et CURRENT OF.

-- CURRENT OF
-- La clause CURRENT OF permet d’accéder directement en modification ou 
-- en suppression à la ligne que vient de ramener l’ordre FETCH.
-- Donc, possibilité de l'utiliser avec UPDATE ou DELETE

-- FOR UPDATE OF
-- Il faut au préalable réserver les lignes lors de la déclaration du curseur 
-- par un verrou d’intention (FOR UPDATE OF nom_colonne). 
-- Avec ce verrou, les données ne peuvent pas être modifiées par un autre 
-- utilisateur, entre le moment ou les données sont lues et le moment où 
-- les données sont modifiées.

SELECT * FROM typevisite;

DECLARE
  -- Déclarer un curseur qui permettra de mettre à jour le champ 
  -- prixvisite de la table typevisite
  CURSOR c1 IS SELECT prixvisite FROM typevisite FOR UPDATE OF prixvisite;
  
  -- Variable pour compter le nombre de modification
  nb_update NUMBER :=0;
BEGIN
  FOR v_typevisite IN c1 LOOP
      -- SI le prix de visite < 80 ALORS augmentation de 10%
      IF v_typevisite.prixvisite < 80 THEN
      
        -- Utilisation du curseur pour augmenter le prix de la visite de 10%
        UPDATE typevisite SET prixvisite = prixvisite * 1.10
        WHERE CURRENT OF c1;
        
        -- Incrémenter le nombre de modifications
        nb_update := nb_update + 1;
      END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('Nombre de prix modifiés : ' || nb_update);
END;

-- Pour vérifier les modifications apportées
SELECT * FROM typevisite;

/******************************************************************************* 
                            CURSEURS IMPLICITES
*******************************************************************************/

-- Un curseur implicite est créé automatiquement par Oracle pour ses propres traitements. 
-- Il est cependant possible de manipuler certaines informations liées à son 
-- exécution grâce aux attributs de curseur.      

-- SQL%FOUND 	TRUE si la dernière instruction INSERT, UPDATE ou DELETE a traité 
--            au moins 1 ligne 
--            TRUE si le dernier SELECT … INTO a ramené une et une seule ligne.
-- SQL%NOTFOUND	TRUE si la dernière instruction INSERT, UPDATE ou DELETE n’a traité aucune ligne.
--              TRUE si le dernier SELECT … INTO n’a pas ramené de ligne.
-- SQL%ISOPEN	  Toujours à FALSE car ORACLE ferme les curseurs après utilisation.
-- SQL%ROWCOUNT	Nombre de lignes traitées par le dernier ordre SQL (INSERT, UPDATE ou DELETE).
--              0 si le dernier SELECT… INTO n’a ramené aucune ligne.
--              1 si le dernier SELECT… INTO a ramené exactement 1 ligne.
--              2 si le dernier SELECT… INTO a ramené plus d’1 ligne.

-- Bloc anonyme
BEGIN
  -- Suppression des medecins dont le numero commence par CURS
  DELETE FROM MEDECIN 
  WHERE numeromed LIKE 'CURS%';
  
  --  SQL%ROWCOUNT = Nombre de lignes traitées par l'ordre SQL DELETE.
  DBMS_OUTPUT.PUT_LINE ('NOMBRE DE MEDECINS SUPPRIMES : ' || SQL%ROWCOUNT); 
  
  -- SQL%FOUND :
  --    TRUE si la dernière instruction INSERT, UPDATE ou DELETE a traité au moins 1 ligne 
  --    TRUE si le dernier SELECT … INTO a ramené une et une seule ligne.
  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('MEDECINS SUPPRIMES' || SQL%ROWCOUNT);
  END IF;

  -- SQL%NOTFOUND
  --    TRUE si la dernière instruction INSERT, UPDATE ou DELETE n’a  traité aucune ligne.
  --    TRUE si le dernier SELECT … INTO n’a pas ramené de ligne
  IF SQL%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE ('AUCUN MEDECIN SUPPRIME' );
  END IF;

  -- SQL%ISOPEN est toujours à FALSE pour un curseur implicite
  -- car ORACLE ferme les curseurs après utilisation.
  IF SQL%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE ('CURSEUR OUVERT');
  END IF;
END;

-- Fonction pour convertir un booleen en varchar
CREATE or REPLACE FUNCTION BOOLEAN_TO_VARCHAR(p_bool in boolean)
RETURN varchar2
is
v_bool varchar2(5);
BEGIN
  CASE
    WHEN p_bool THEN 
      v_bool:='TRUE';
    WHEN not p_bool THEN 
      v_bool:='FALSE';
    ELSE 
      v_bool:='NULL';
   END CASE;
  RETURN v_bool;
END;

-- Affichage des attributs d'un curseur implicite
DECLARE
  v_nom VARCHAR2(20);
BEGIN
  -- Sélection d'un médecin qui existe
  SELECT nom INTO v_nom
  FROM medecin
  WHERE NumeroMed = 'NUMEROMED1';

  DBMS_OUTPUT.PUT_LINE ('SQL%FOUND  : ' || BOOLEAN_TO_VARCHAR(SQL%FOUND));
  DBMS_OUTPUT.PUT_LINE ('SQL%NOTFOUND  : ' || BOOLEAN_TO_VARCHAR(SQL%NOTFOUND));
  DBMS_OUTPUT.PUT_LINE ('SQL%ROWCOUNT  : ' || SQL%ROWCOUNT);
  
  -- Sélection d'un médecin qui n'existe pas
  SELECT nom INTO v_nom
  FROM medecin
  WHERE NumeroMed = 'NUMEROMED1111';

EXCEPTION
  WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('SQL%FOUND  : ' || BOOLEAN_TO_VARCHAR(SQL%FOUND));
  DBMS_OUTPUT.PUT_LINE ('SQL%NOTFOUND  : ' || BOOLEAN_TO_VARCHAR(SQL%NOTFOUND));
  DBMS_OUTPUT.PUT_LINE ('SQL%ROWCOUNT  : ' || SQL%ROWCOUNT);
END;

/******************************************************************************* 
                                TYPES
                                TABLES
*******************************************************************************/

-- Syntaxe
CREATE OR REPLACE TYPE <type_name> AS OBJECT (
<column_name> <data_type>,
...,
<column_name> <data_type>
);

-- Création d'un type : Exemple
CREATE OR REPLACE TYPE VarCharTable IS TABLE OF VARCHAR2(4000);

-- Utilisation du type déclaré
DECLARE
  ma_table VarCharTable := VarCharTable(2);
BEGIN
  ma_table(1) := 'valeur1';
  DBMS_OUTPUT.PUT_LINE('ma_table(1) est '||ma_table(1));
END;

CREATE OR REPLACE TYPE t_medecin AS OBJECT(
    nom VARCHAR2(15),
    prenom VARCHAR2(20)
);

-- Création d'un type dans un bloc : exemple
DECLARE
     TYPE table_type_number IS TABLE OF NUMBER;
     -- Initialisation obligatoire sinon erreur
     ma_table table_type_number := table_type_number (100);
BEGIN
     ma_table(1) := 21;
     DBMS_OUTPUT.PUT_LINE('ma_table(1) is '||ma_table(1));
END;
  
/******************************************************************************* 
                                TYPES
                               CURSEURS
                              REF CURSOR
*******************************************************************************/

-- REF CURSOR est un type basic.
-- Une variable basée sur un tel type est appelée un curseur variable.
-- Un curseur variable peut être associé à différentes requêtes. 
-- Le principal avantage d'utiliser un curseur variable est sa capacité à passer 
-- les résultats entre sous programmes (procédures, fonctions).

-- Creation d'un TYPE REF CURSOR dans un package
CREATE OR REPLACE PACKAGE Pk_refCursType
AS
  TYPE REFCURSTYPE IS REF CURSOR;
END;

-- Création d'une fonction qui utilise le curseur variable
-- pour retourner les données
CREATE OR REPLACE FUNCTION getListeMedecins2
  RETURN Pk_refCursType.REFCURSTYPE 
IS
  -- Création d'une variable de type REFCURSTYPE
  -- qui se trouve dans le package Pk_refCursType
  cursListMed Pk_refCursType.REFCURSTYPE;
BEGIN
  -- Associer le curseur variable à la requête
  OPEN cursListMed FOR SELECT * FROM MEDECIN;
  
  -- Retourner la liste des médecins
  RETURN cursListMed;
END;

-- Test de la procédure getListeMedecins2 avec FETCH
DECLARE
  -- Création d'une variable de type REFCURSTYPE
  cursListMed Pk_refCursType.REFCURSTYPE;
  unMedecin medecin%rowtype;
BEGIN
  cursListMed := getListeMedecins2;
  LOOP
    FETCH cursListMed INTO unMedecin;
    EXIT WHEN cursListMed%notfound;
    dbms_output.put_line('num medecin = '||unMedecin.NUMEROMED);
  END LOOP;
END;


-- Test de la procédure getListeMedecins2 avec FOR
DECLARE
  cursListMed Pk_refCursType.REFCURSTYPE;
  unMedecin medecin%rowtype;
BEGIN
  cursListMed :=getListeMedecins2;
  FOR unMedecin IN cursListMed LOOP
    dbms_output.put_line('num medecin = '||unMedecin.NUMEROMED);
  END LOOP;
END;

-- Creation d'un TYPE REF CURSOR dans un package
CREATE OR REPLACE PACKAGE Pk_refCursType1
AS
  TYPE STRONG_REF_CURSOR IS REF CURSOR RETURN MEDECIN%ROWTYPE;
END;

-- Création d'une procédure qui utilise le curseur variable
CREATE OR REPLACE PROCEDURE getListeMedecins3(p_cursor OUT Pk_refCursType1.STRONG_REF_CURSOR)
IS
BEGIN
  OPEN p_cursor
  FOR SELECT * FROM MEDECIN;
END;

SET serveroutput on
-- Test de la procédure getListeMedecins3
DECLARE
  cursListMed Pk_refCursType1.STRONG_REF_CURSOR;
  unMedecin medecin%rowtype;
BEGIN
  getListeMedecins3(cursListMed);
LOOP
  FETCH cursListMed INTO unMedecin;
  EXIT WHEN cursListMed%notfound;
  dbms_output.put_line('num medecin = '||unMedecin.NUMEROMED);
  END LOOP;
END;

/* 
    %ROWTYPE avec REF CURSOR
*/

-- Dans l'exemple précédent, vous avez récupéré une seule colonne en 
-- utilisant REF CURSOR
-- Dans l'exemple ci-dessous, vous allez récupérer un enregistrement complet

DECLARE
  TYPE r_cursor IS REF CURSOR;
  c_medecin r_cursor;
  v_medecin medecin%rowtype;
BEGIN
  OPEN c_medecin FOR SELECT * FROM MEDECIN;
  LOOP
      FETCH c_medecin INTO v_medecin;
      EXIT WHEN c_medecin%notfound;
        dbms_output.put_line(v_medecin.numeromed || ' - ' || v_medecin.nom 
        || ' - ' || v_medecin.prenom);
        dbms_output.put_line(v_medecin.adresse || ' - ' || v_medecin.codepostal 
        || ' - ' || v_medecin.ville);
        dbms_output.put_line(v_medecin.codespecialite || ' - ' 
        || v_medecin.nbvisites);
  END LOOP;
  CLOSE c_medecin;
END;

/******************************************************************************* 
                                CURSEURS
                            CURSEURS IMBRIQUES
*******************************************************************************/

-- 2 curseurs imbriques
-- Obtenir les visites pour chaque médecin
DECLARE
  v_numeromed medecin.numeromed%TYPE;
  v_medecin_flag CHAR;
  
  CURSOR c_medecin IS
  SELECT numeromed, nom, prenom
  FROM medecin;
  
  CURSOR c_visite IS
  SELECT numerovisite, numeross
  FROM VISITE
  WHERE numeromed = v_numeromed;
  
BEGIN
  FOR r_medecin IN c_medecin LOOP
    v_medecin_flag := 'N';
    v_numeromed := r_medecin.numeromed;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Médecin : '|| r_medecin.nom);
    FOR r_visite in c_visite LOOP
      DBMS_OUTPUT.PUT_LINE('Numéro de visite : ' || r_visite.numerovisite || 
      ' Numéro du malade : ' ||r_visite.numeross);
      v_medecin_flag := 'Y';
    END LOOP;
    IF v_medecin_flag = 'N' THEN
      DBMS_OUTPUT.PUT_LINE ('Aucune visite pour ce medecin.');
    END IF;
END LOOP;
END;
