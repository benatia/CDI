/****************************************************************************** 
          SOMMAIRE
          � COMMANDES SQL*Plus
          � EXEMPLES DE PACKAGES 
            � PACKAGE DBMS_OUTPUT
            � PACKAGE UTL_FILE
            � PACKAGE DBMS_OBFUSCATION_TOOLKIT

          � BLOCS ANONYMES PL/SQL       
          � BLOCS PL/SQL : Op�rateurs 
          � BLOCS PL/SQL : Structures de controle
              Branchements conditionnels : IF... ELSIF... END IF
              Structures de controle : Boucles FOR...LOOP....END LOOP
              Structures de controle : CASE
              Boucle WHILE ... LOOP
          � FONCTIONS DE TRAITEMENT DES CHAINES DE CARACTERES
              LENGTH - INSTR - SUBSTR
                        
          � PROCEDURES
					� FONCTIONS
          � OBTENIR DES INFOS QUAND IL Y A ERREUR
          � PROCEDURES ET FONCTIONS : LES PARAMETRES
					� PROCEDURES ET FONCTIONS : SAISIE DE PARAMETRES 
          
          � PROCEDURES ET FONCTIONS : RECAPITULATIF
              Cr�er une proc�dure/fonction
              Supprimer une proc�dure/fonction
              Compiler une fonction/proc�dure
              Ex�cuter une proc�dure/fonction
              Afficher les erreurs de compilation 
              Afficher la liste des PROCEDURES/FONCTIONS/TRIGGERS
              Afficher le code source des PROCEDURES/FONCTIONS/TRIGGERS
              
          � GESTION DES EXCEPTIONS
          
          � TYPES IMPLICITES : ROWTYPE & TYPE
                      
******************************************************************************/


/****************************************************************************** 
                          COMMANDES SQL*Plus
                          qui fonctionnent avec SQL Developer
******************************************************************************/

-- Liste des champs de la table en param�tre (avec le bouton Execute statement 
-- ou le bouton run script(ex�cuter un script))
desc medecin

-- Effacer la fen�tre Script output (avec le bouton run script(ex�cuter un script))
clear screen

/****************************************************************************** 
                          PACKAGE DBMS_OUTPUT 
******************************************************************************/
/* PL/SQL n�est pas un langage avec des fonctionalit�s d�entrees sorties evoluees 
(ce n�est pas son but!). Toutefois, vous pouvez imprimer des messages et 
des valeurs de variables de plusieurs manieres differentes. 
Le plus pratique est de faire appel a un package predefini : DBMS output.

Les proc�dures de ce paquetage vous permettent d'�crire des lignes dans un 
tampon depuis un bloc PL/SQL anonyme, une proc�dure ou un d�clencheur. 
Le contenu de ce tampon est affich� � l'�cran lorsque le sous-programme ou 
le d�clencheur est termin�. 
L'utilit� principale est d'afficher � l'�cran des informations de trace ou de d�bogage 
La taille maximum du tampon est de un million de caract�res
La taille maximum d'une ligne est de 255 caract�res */

-- POUR EXCUTER LES FONCTIONS EN DEHORS D'UN BLOC PL/SQL, IL FAUT FAIRE
-- PRECEDER LA COMMANDE DE EXECUTE 

-- Permet de rendre actives les fonctions du paquetage DBMS_OUTPUT
SET SERVEROUTPUT ON

-- Permet de rendre inactives les fonctions du paquetage DBMS_OUTPUT
SET SERVEROUTPUT OFF

-- Initialiser le tampon d'�criture et d'accepter les commandes de lecture 
-- et d'�criture dans ce tampon.
EXECUTE DBMS_OUTPUT.ENABLE (taille_tampon IN INTEGER DEFAULT 20000)
-- � taille_buffer	:	Taille allou�e au buffer.
--    Taille maximum du buffer : 1.000.000 d'octets (par d�faut 2000).
--    Taille maximum d'une ligne : 255 octets
EXECUTE DBMS_OUTPUT.ENABLE (40000)
EXECUTE DBMS_OUTPUT.ENABLE

-- D�sactiver les appels de lecture et �criture dans le tampon et purge ce dernier
EXECUTE DBMS_OUTPUT.DISABLE

-- Ajouter des informations dans la ligne en cours du tampon
EXECUTE DBMS_OUTPUT.PUT (�l�ment IN NUMBER | VARCHAR2 | DATE )

-- G�n�rer une ligne enti�re dans le tampon. Un caract�re fin de ligne est 
-- automatiquement ajout� en fin de ligne 
DBMS_OUTPUT.PUT_LINE (�l�ment IN NUMBER | VARCHAR2 | DATE )

EXECUTE DBMS_OUTPUT.PUT_LINE('MILES')
EXECUTE DBMS_OUTPUT.PUT_LINE(11)
EXECUTE DBMS_OUTPUT.PUT_LINE(SYSDATE)

--  Ajouter au tampon un caract�re fin de ligne 
EXECUTE DBMS_OUTPUT.NEW_LINE

-- La proc�dure GETLINE lit une ligne. Celle-ci est plac�e dans la variable ligne.
DBMS_OUTPUT.GETLINE (ligne OUT VARCHAR2, �tat OUT INTEGER)

-- La proc�dure GETLINES lit une nb_lignes lignes. Celles-ci sont plac�es dans 
-- un tableau de chaines de caract�res.
DBMS_OUTPUT.GETLINES (lignes OUT tab_char, nb_lignes OUT INTEGER)

/****************************************************************************** 
                        PACKAGE UTL_FILE 
******************************************************************************/

/* Les proc�dures de ce package permettent de lire et d'�crire dans un fichier texte, 
situ� dans un r�pertoire du syst�me d'exploitation. 
Le r�pertoire doit �tre point� par un DIRECTORY oracle. */

-- Permet d'ouvrir le fichier texte. La valeur retourn�e est l'identifiant 
-- d'ouverture (pointeur). Il doit �tre r�cup�r� dans une variable 
-- de type UTL_FILE.FILE_TYPE.
UTL_FILE.FOPEN ( directory    IN VARCHAR2,
                 fichier      IN VARCHAR2,
                 mode         IN VARCHAR2,
                 taille_ligne IN BINARY_INTEGER)
/*
�	directory	:	Directory associ� au r�pertoire dans lequel le fichier est situ�.
�	fichier	  :	Nom du fichier.
�	mode	    :	Type d'ouverture du fichier.
  �	R	:	Fichier ouvert en lecture.
  �	W	:	Fichier ouvert en �criture.
  �	A	:	Fichier ouvert en ajout.
�	taille_ligne	:	Taille maxi d'une ligne du fichier 
  (entre 1 et 32767 octets, par d�faut : 1000).
*/

-- Permet de v�rifier si le fichier est ouvert. 
-- Elle retourne un bool�en (TRUE si le fichier est ouvert et FALSE s'il est ferm�.
UTL_FILE.IS_OPEN (pointeur IN FILE_TYPE)
/*
�	pointeur	:	Variable contenant l'identifiant d'ouverture obtenu par la fonction FOPEN.
*/

-- Permet de fermer le fichier.
UTL_FILE.FCLOSE (pointeur IN FILE_TYPE)
/*
�	pointeur	:	Variable contenant l'identifiant d'ouverture obtenu par la fonction FOPEN.
*/
 
-- Permet d'�crire des donn�es dans le fichier, sans caract�re de fin de ligne (PUT)
-- ou avec caract�re de fin de ligne (PUT_LINE).
UTL_FILE.PUT      (pointeur IN FILE_TYPE, cha�ne IN VARCHAR2)
UTL_FILE.PUT_LINE (pointeur IN FILE_TYPE, cha�ne IN VARCHAR2)
/*
�	pointeur  :	Variable contenant l'identifiant d'ouverture obtenu par la fonction FOPEN.
�	cha�ne    :	Variable contenant les donn�es � �crire.
*/

-- Permet de lire une ligne dans le fichier.
UTL_FILE.GET_LINE (pointeur IN FILE_TYPE, cha�ne OUT VARCHAR2, taille IN NUMBER)
/*
�	pointeur	:	Variable contenant l'identifiant d'ouverture obtenu par la fonction FOPEN.
�	cha�ne	  :	Variable recevant les donn�es lues.
�	taille	  :	Taille de la ligne.
*/

/****************************************************************************** 
                        PACKAGE DBMS_OBFUSCATION_TOOLKIT
******************************************************************************/

/*
DBMS_OBFUSCATION_TOOLKIT permet le cryptage (chiffrement) de donn�es.
Le cryptage consiste � convertir des donn�es de texte simple en texte crypt� 
afin de les rendre incompr�hensibles par un tiers non autoris�. 
Ce proc�d� se fait par le biais d'une cl� de cryptage. 

DBMS_OBFUSCATION_TOOLKIT utilise trois types de cryptages standards : 
�	DES - Data Encryption Standard. Bas� sur une cl� de 56 bytes. 
�	Triple DES - Bas� sur une cl� de 128 bytes et est plus robuste qu'un simple DES 
�	MD5
*/

CREATE OR REPLACE FUNCTION md5(v_in VARCHAR2)
RETURN VARCHAR2
IS
  result VARCHAR2(4000);
BEGIN
  result := dbms_obfuscation_toolkit.md5(input_string=>v_in);
RETURN result;
END;

SELECT md5('toto') from dual;

-- Encryptage DES3 du mot BOBMARLEY avec la cl� ABCDEFGHIJKLMNOP 
-- key_string doit �tre un multiple de 8
DECLARE
	   val_crypt VARCHAR2(200);
BEGIN
	val_crypt := DBMS_OBFUSCATION_TOOLKIT.des3encrypt(input_string=>'BOBMARLE',key_string=>'ABCDEFGHIJKLMNOP');
	DBMS_OUTPUT.put_line('Valeur chiffr�e = '|| val_crypt);
END;

-- Resultat -> 4�>=����

-- Decryptrage DES de 4�>=���� avec la cl� ABCDEFGHIJKLMNOP 
DECLARE
	   val_crypt VARCHAR2(200);
BEGIN
	val_crypt := DBMS_OBFUSCATION_TOOLKIT.des3decrypt(input_string=>'4�>=����',key_string=>'ABCDEFGHIJKLMNOP');
	DBMS_OUTPUT.put_line('Valeur chiffr�e = '|| val_crypt);
END;

-- Resultat -> BOBMARLE

/******************************************************************************* 
                                 BLOCS ANONYMES PL/SQL
*******************************************************************************/

--
-- BLOC ANONYME MINIMAL
--

-- Pour voir le  message -> Fen�tre Sortie SGBD : vous devez activer DBMS_OUTPUT 
-- pour une connexion (bouton + vert)  
BEGIN
  DBMS_OUTPUT.PUT_LINE('Vive le Jazz');
END;

--
-- BLOCS ANONYMES AVEC DECLARATION DE VARIABLES
--

DECLARE
  -- D�claration de 2 variables de type NUMBER
  var1 NUMBER;
  var2 NUMBER;
BEGIN
  -- Affectation ->  :=
  var1:=2;
  var2:=4;
  -- Ajouter les 2 valeurs
  var1:=var1+var2;
  -- Affichage du r�sultat : || -> concat�nation
  DBMS_OUTPUT.PUT_LINE('Resultat : ' || var1);
END;

DECLARE
  var1 VARCHAR2(20);
  --var1 := 'Formation AFPA';
BEGIN
  -- Affectation ->  :=
  var1 := 'Formation AFPA';
  DBMS_OUTPUT.PUT_LINE(var1);
END;

-- Bloc anonyme incluant une requ�te SQL
/* Ce dernier exemple donne comme valeur � la variable var le resultat de la requete
(qui doit etre du meme type). Il est imperatif que la requete ne renvoie qu�un et un
seul resultat (c�est a dire qu�il n�y ait qu�un seul fournisseur numero 1). 
Autrement,une erreur se produit. */
DECLARE
  var VARCHAR(12);
BEGIN
  SELECT nomfou INTO var
    FROM FOURNISSEUR
    WHERE numfou=9120;
    
  DBMS_OUTPUT.PUT_LINE('Nom du fournisseur : ' || var);
END;

/******************************************************************************* 
                                 BLOCS PL/SQL
                              Op�rateurs + - / *
*******************************************************************************/
DECLARE
	v_nom VARCHAR(10);
  v_numero integer;  -- par d�faut, v_numero est NULL
BEGIN
  v_nom := 'Bob';
  DBMS_OUTPUT.PUT_LINE ('v_numero : ' || v_nom);
  v_numero := 10;
  DBMS_OUTPUT.PUT_LINE ('v_numero : ' || v_numero);
  v_numero := v_numero + 10;
  DBMS_OUTPUT.PUT_LINE ('v_numero apr�s addition : ' || v_numero);
  v_numero := v_numero - 1;
  DBMS_OUTPUT.PUT_LINE ('v_numero apr�s sosutraction : ' || v_numero);
  v_numero := v_numero * 4;
  DBMS_OUTPUT.PUT_LINE ('v_numero apr�s multiplication : ' || v_numero);
  v_numero := v_numero / 2;
  DBMS_OUTPUT.PUT_LINE ('v_numero apr�s division : ' || v_numero);
END;

/******************************************************************************* 
                                 BLOCS PL/SQL - Structures de controle
							 Branchements conditionnels : IF... ELSIF... END IF
							 Structures de controle : Boucles FOR...LOOP....END LOOP
							 Structures de controle : CASE
							 Structures de controle : Boucle WHILE ... LOOP
*******************************************************************************/

-- BLOC ANONYME
-- structure SI ... ALORS ... SIFIN
-- Branchements conditionnels : IF... ELSIF... END IF

DECLARE
  v_nom VARCHAR(10);
  v_nom2 VARCHAR(10);
  v_numero integer;  -- par d�faut, v_numero est NULL
BEGIN
  v_nom := 'Bob';
  v_nom2 := 'Steve';
  v_numero := 10;
  v_numero := v_numero + 10;
  v_numero := v_numero - 1;
  v_numero := v_numero * 4;
  v_numero := v_numero / 2;
  IF v_numero = 0 THEN
    DBMS_OUTPUT.PUT_LINE ('v_numero est �gal � 0');
  ELSIF v_numero > 1 THEN
    DBMS_OUTPUT.PUT_LINE ('v_numero est sup�rieur � 1');
  END IF;  
  IF v_numero IS NULL THEN
    DBMS_OUTPUT.PUT_LINE ('v_numero est NULL');
  END IF;
  IF v_numero BETWEEN 2 AND 44 THEN
    DBMS_OUTPUT.PUT_LINE ('v_numero est entre 2 et 44 : ' || v_numero);
  END IF;
  IF v_nom LIKE 'Bob' THEN
    DBMS_OUTPUT.PUT_LINE ('v_nom est Bob');
  END IF;
  IF v_nom2 NOT LIKE 'Bob' THEN
    DBMS_OUTPUT.PUT_LINE ('v_nom2 n''est pas Bob');
  END IF;
  IF v_nom2 NOT LIKE 'Bob' AND v_nom LIKE 'Bob' THEN
    DBMS_OUTPUT.PUT_LINE ('v_nom2 n''est pas Bob et v_nom est Bob');
  END IF;
  DBMS_OUTPUT.PUT_LINE ('NOM DU MEDECIN :  ' || v_nom);
END;

-- BLOC ANONYME
-- structure POUR ... FINPOUR
-- Structures de controle : Boucles FOR...LOOP....END LOOP

BEGIN
    -- Boucle FOR
    -- Ne pas d�clarer indice
    -- DE 10..9..8.....1
    DBMS_OUTPUT.PUT_LINE ('1ere boucle --------------------------------------');
  	FOR indice IN REVERSE 1..10 LOOP
    		DBMS_OUTPUT.PUT_LINE ('BOUCLE FOR -> Valeur de l''indice : ' 
        || indice);
        -- Pour sortir de la boucle
        -- EXIT WHEN indice = 3;
  	END LOOP;
    DBMS_OUTPUT.PUT_LINE ('2eme boucle --------------------------------------');
    -- DE 1...10
    FOR indice IN 1..10 LOOP
    		DBMS_OUTPUT.PUT_LINE ('BOUCLE FOR -> Valeur de l''indice : ' 
        || indice);
  	END LOOP;
    DBMS_OUTPUT.PUT_LINE ('3eme boucle --------------------------------------');
    
     -- Aucune boucle
    FOR indice IN 10..1 LOOP
    		DBMS_OUTPUT.PUT_LINE ('BOUCLE FOR -> Valeur de l''indice : ' 
        || indice);
  	END LOOP;
    DBMS_OUTPUT.PUT_LINE ('4eme boucle --------------------------------------');
    
    -- Aucune boucle
    FOR indice IN REVERSE 10..1 LOOP
    		DBMS_OUTPUT.PUT_LINE ('BOUCLE FOR -> Valeur de l''indice : ' 
        || indice);
  	END LOOP;
END;

-- BLOC ANONYME
-- structure SELONQUE ... FINSELONQUE
-- Structures de controle : CASE- avec integer sur le CASE

DECLARE
  v_indice integer;  -- par d�faut, v_numero est NULL
BEGIN
    v_indice := 1;
    CASE v_indice
        WHEN 1 THEN 
          DBMS_OUTPUT.PUT_LINE('1er WHEN : ');
          DBMS_OUTPUT.PUT_LINE('Valeur de v_indice : ' || v_indice);
        WHEN 2 THEN
          DBMS_OUTPUT.PUT_LINE('2eme WHEN : ');
          DBMS_OUTPUT.PUT_LINE('Valeur de v_indice : ' || v_indice);
        WHEN 3 THEN
          DBMS_OUTPUT.PUT_LINE('3eme WHEN : ');
          DBMS_OUTPUT.PUT_LINE('Valeur de v_indice :' || v_indice);
        -- ELSE est facultatif
        ELSE DBMS_OUTPUT.PUT_LINE ('Valeur non trait�e : ' || v_indice);
    END CASE;
END;

-- BLOC ANONYME
-- structure SELONQUE ... FINSELONQUE
-- Structures de controle : CASE - avec chaine sur le CASE

DECLARE
  var_cp VARCHAR2(5) := '83000';
BEGIN
       var_cp := SUBSTR(var_cp,1,2);
       CASE var_cp
         WHEN '78' THEN DBMS_OUTPUT.PUT_LINE ('D�partement Yvelines');
         WHEN '94' THEN DBMS_OUTPUT.PUT_LINE ('D�partement Val de Marne');
         WHEN '83' THEN DBMS_OUTPUT.PUT_LINE ('D�partement Var');
         ELSE           DBMS_OUTPUT.PUT_LINE ('D�partement Autre');
       END CASE;
END;

-- BLOC ANONYME
-- Structures de controle : CASE : autre syntaxe

DECLARE
  v_indice integer;  -- par d�faut, v_numero est NULL
BEGIN
    v_indice := 1;
    CASE
        WHEN v_indice BETWEEN 1 AND 2 THEN 
          DBMS_OUTPUT.PUT_LINE('1er WHEN : ');
          DBMS_OUTPUT.PUT_LINE('Valeur de v_indice : ' || v_indice);
        WHEN v_indice = 3 THEN
          DBMS_OUTPUT.PUT_LINE('2eme WHEN : ');
          DBMS_OUTPUT.PUT_LINE('Valeur de v_indice : ' || v_indice);
        WHEN v_indice = 4 THEN
          DBMS_OUTPUT.PUT_LINE('3eme WHEN : ');
          DBMS_OUTPUT.PUT_LINE('Valeur de v_indice :' || v_indice);
        -- ELSE est facultatif
        ELSE DBMS_OUTPUT.PUT_LINE ('Valeur non trait�e : ' || v_indice);
    END CASE;
END;

-- BLOC ANONYME
-- structure TANTQUE .... FINTANTQUE
-- Boucle WHILE ... LOOP

DECLARE
  	v_indice integer;
BEGIN
  	v_indice := 1; 
    -- Boucle WHILE
    WHILE v_indice < 31 LOOP
    		DBMS_OUTPUT.PUT_LINE ('BOUCLE WHILE -> Valeur de l''indice : ' || v_indice);
        v_indice := v_indice+1;
  	END LOOP;
END;

-- BLOC ANONYME
-- structure FAIRE .... TANTQUE
-- Boucle LOOP ... END LOOP

DECLARE
  	v_indice integer;
BEGIN
    v_indice := 1;
    LOOP
    		EXIT WHEN v_indice = 31;
        DBMS_OUTPUT.PUT_LINE ('BOUCLE LOOP -> Valeur de l''indice : ' || v_indice);
        v_indice := v_indice+1;
  	END LOOP;
END;

-- BLOC ANONYME
-- Boucle LOOP... END LOOP
DECLARE
    v_CodeTypeVisite typevisite.CodeTypeVisite%TYPE;
    CURSOR c1 IS SELECT CodeTypeVisite FROM typevisite;
BEGIN  
    OPEN c1;
    LOOP
      FETCH c1 INTO v_CodeTypeVisite;         
      EXIT WHEN c1%NOTFOUND;
      CASE v_CodeTypeVisite
        WHEN 'CODETYPEVISITE1' THEN DBMS_OUTPUT.PUT_LINE 
        ('Type de visite tres honereuse : ' || v_CodeTypeVisite);
        WHEN 'CODETYPEVISITE2' THEN DBMS_OUTPUT.PUT_LINE 
        ('Type de visite honereuse : ' || v_CodeTypeVisite);
        WHEN 'CODETYPEVISITE3' THEN DBMS_OUTPUT.PUT_LINE 
        ('Type de visite peu honereuse :' || v_CodeTypeVisite);
        -- ELSE est facultatif
        ELSE DBMS_OUTPUT.PUT_LINE ('Type de visite honereuse : ' || v_CodeTypeVisite);
      END CASE;
    END LOOP;
    CLOSE c1;
END;

/******************************************************************************* 
                    FONCTIONS DE TRAITEMENT DES CHAINES
                            DE CARACTERES
                        LENGTH - INSTR - SUBSTR
*******************************************************************************/

-- Proc�dure retourne le sigle d'un intitul� de formation
-- = 1�re lettre de chaque mot
DECLARE
  -- Chaine qui contiendra le sigle
  var1 VARCHAR2(30);
  len integer;
  pos integer;
  -- Chaine � traiter
  chaine VARCHAR2(100) := 'Concepteur Developpeur Informatique';
BEGIN
  -- Longueur de la chaine
  len := length(chaine);
  -- Extraire un caract�re � partir de la position 1
  var1 := substr(chaine, 1, 1);
  -- TANT QUE il existe des espaces
  LOOP   	
    -- Recherche du 1er caract�re espace
    pos := INSTR(chaine, ' ');
    -- Fin de boucle si plus d'espace
    EXIT WHEN pos = 0;
    -- Extraire un caract�re � partir du prochain caract�re espace + 1
    -- Ajouter ce caract�re � var1 (concatener)
    var1 := var1 || substr(chaine, pos+1, 1); 
    -- Red�finir la chaine
    chaine := substr(chaine, pos+1, len - pos);
  -- FIN TANTQUE
  END LOOP;
  -- Afficher le sigle
  DBMS_OUTPUT.PUT_LINE ('Mon sigle : ' || var1);
END;

-- r�sultat -> CDI

/******************************************************************************* 
									PROCEDURE
*******************************************************************************/

--
-- PROCEDURE -> DECLARE a disparu. Il est remplac� par IS ou AS
--

CREATE or REPLACE PROCEDURE ma_proc1
IS
  x VARCHAR2(20);
  -- Non autoris�
  -- variable1, variable2 NUMBER;
BEGIN
  -- Affectation ->  :=
  x := 'Formation AFPA';
  DBMS_OUTPUT.PUT_LINE('Valeur de x : ' || x);
END;

-- Execution proc�dure via EXECUTE
EXECUTE ma_proc1

-- Execution proc�dure via bloc anonyme
BEGIN
ma_proc1;
END;

-- Ex�cution avec une pseudo requ�te (possible uniquement pour appel de fonctions)
-- Erreur car ma_proc1 est une proc�dure
SELECT ma_proc1 FROM dual;

/******************************************************************************* 
									FONCTION
*******************************************************************************/

-- FONCTION sans param�tre qui retourne un VARCHAR2
CREATE or REPLACE FUNCTION ma_fonc1
RETURN VARCHAR2
AS
  x VARCHAR2(20);
BEGIN
  -- Affectation ->  :=
  x := 'Formation AFPA';
  RETURN x;
END;

-- Ex�cution de la fonction ma_fonc1 avec une pseudo requ�te
SELECT ma_fonc1 FROM dual;

-- Execution fonction ma_fonc1 � partir d'un bloc anonyme
DECLARE
  nom_variable VARCHAR2(20);
BEGIN
  -- Appel de la fonction
  nom_variable := ma_fonc1;
  DBMS_OUTPUT.PUT_LINE('TEXTE A AFFICHER : ' || nom_variable);
    -- OU
  DBMS_OUTPUT.PUT_LINE('TEXTE A AFFICHER : ' || ma_fonc1);
END;

/****************************************************************************** 
                                DEBUGGER
              POUR OBTENIR LES INFOS QUAND IL Y A DES ERREURS
******************************************************************************/

-- Proc�dure avec erreur
CREATE or REPLACE PROCEDURE proc_with_errors
IS
  x VARCHAR2(20);
BEGIN
  -- Affectation ->  :=
  x := 'Formation AFPA';
  DBMS_OUTPUT.PUT_LINE(y);
END;

-- Erreurs sur les objets stock�s par l'utilisateur courant
-- (proc�dures, fonctions, triggers, packages)
SELECT * FROM user_errors;

-- Erreurs de compilation sur tous les objets accessibles 
-- par l'utilisateur courant
SELECT * FROM all_errors;

-- Pour visualiser les erreurs de compilation de la fonction PROC_WITH_ERRORS
-- Attention : nom de la fonction en lettres majuscules
SELECT * FROM all_errors WHERE NAME LIKE 'PROC_WITH_ERRORS';

-- Commande PL*SQL
SHOW ERRORS FUNCTION proc_with_errors

-- Visualiser le code source des fonctions, procedures et triggers
-- Utilisation de la table user_source
SELECT text, name FROM user_source where name LIKE 'PROC_WITH_ERRORS';

-- Pour visualiser les champs de la table user_source (commande PL*SQL)
DESC user_source

-- R�sultat ci-dessous
-- NAME        VARCHAR2(30)                                                                                                                                                                                  
-- TYPE        VARCHAR2(12)                                                                                                                                                                                  
-- LINE        NUMBER                                                                                                                                                                                        
-- TEXT        VARCHAR2(4000)   

/******************************************************************************* 
                    FONCTIONS / PROCEDURES AVEC PARAMETRES
*******************************************************************************/

-- PROCEDURE avec param�tres IN, OUT et IN OUT
-- Un param�tre IN ne pas �tre modifi� par la procedure
-- Un param�tre OUT est initialement � NULL.
-- Un param�tre IN OUT peut �tre initialis� par l'appelant 
-- et modifi� par la procedure.
-- Par d�faut, un param�tre est IN

-- CF documentation ORACLE page 8-9

-- PROCEDURE avec param�tres IN (par d�faut)
-- Proc�dure retourne le sigle d'un intitul� de formation
-- = 1�re lettre de chaque mot

-- CREATE or REPLACE PROCEDURE TraiterChaine (chaine IN VARCHAR2)
-- OU
CREATE or REPLACE PROCEDURE TraiterChaine (chaine VARCHAR2)
IS
  var1 VARCHAR2(30);
  var2 VARCHAR2(100);
  len integer;
  pos integer;
BEGIN
  len := length(chaine);
  var1 := substr(chaine, 1, 1);
  var2 := chaine;
  LOOP   	
    -- Recherche du 1er caract�re espace
    pos := INSTR(var2, ' ');
    EXIT WHEN pos = 0;
    var1 := var1 || SUBSTR(var2, pos+1, 1);
    var2 := SUBSTR(var2, pos+1, len - pos);
    -- Fin de boucle si plus d'espace
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('Mon sigle : ' || var1);
END;

-- Ex�cution de la proc�dure TraiterChaine()
EXECUTE TraiterChaine ('Concepteur Developpeur Informatique');

-- Execution proc�dure via bloc anonyme
BEGIN
TraiterChaine;
END;

-------------------------------
-- PROCEDURE avec param�tres IN
-- Erreur de compilation car modification param�tre p_index
-- qui est d�clar� en IN

CREATE or REPLACE PROCEDURE ObtenirValeur_IN(p_index IN integer)
IS
BEGIN
  -- p_index := 1;
  p_index := p_index+5;
END;

-- Afficher les erreurs de compilation de ma proc�dure
SELECT * FROM all_errors WHERE NAME LIKE 'OBTENIRVALEUR_IN';


-- COMMENT FAIRE ???
-- Avec une proc�dure : 1 param�tre en IN (p_index) et 
--                      1 param�tre en OUT (p_sortie)
CREATE or REPLACE PROCEDURE P_ObtenirValeur_IN_OK(p_index IN integer, 
                                                  p_sortie OUT integer)
IS
BEGIN
  p_sortie := p_index + 5;
END;

-- Test de la procedure P_ObtenirValeur_IN_OK
DECLARE
  variable_sortie integer;
  nom_constant constant number := 5;
BEGIN
  P_ObtenirValeur_IN_OK(nom_constant, variable_sortie);
  DBMS_OUTPUT.PUT_LINE('TEST IN OK - NOUVELLE VALEUR : ' || variable_sortie);
END;

-- Avec une fonction :  1 param�tre en IN (p_index) et 
--                      1 param�tre en RETURN (v_sortie)
CREATE or REPLACE FUNCTION F_ObtenirValeur_IN_OK(p_index IN integer)
RETURN INTEGER
IS
  v_sortie integer;
BEGIN
  -- v_sortie =  valeur de p_index + 5
  v_sortie := p_index + 5;
  
  -- Retourner la valeur
  return v_sortie;
END;

-- Test de la procedure F_ObtenirValeur_IN_OK avec un bloc anonyme
DECLARE
  variable_sortie integer;
  nom_constant constant number := 5;
BEGIN
  variable_sortie := F_ObtenirValeur_IN_OK(nom_constant);
  DBMS_OUTPUT.PUT_LINE('TEST IN OK - NOUVELLE VALEUR : ' || variable_sortie);
END;

-- Test de la procedure F_ObtenirValeur_IN_OK avec un SELECT
select F_ObtenirValeur_IN_OK(1) from dual;

SELECT * FROM all_errors WHERE NAME LIKE 'OBTENIRVALEUR_INOUT';

-------------------------------
-- PROCEDURE avec param�tre OUT
CREATE or REPLACE PROCEDURE P_ObtenirValeur_OUT(p_index OUT integer)
IS
BEGIN
  -- Pas ok car p_index est OUT
  -- Un param�tre OUT est initialement � NULL : pas possible de lire sa valeur
  -- p_index := p_index + 5; 
  
  p_index := 5;
END;

-- Test de la procedure P_ObtenirValeur_OUT
DECLARE
  nom_variable integer;
BEGIN
  -- nom_variable := 5;
  P_ObtenirValeur_OUT(nom_variable);
  DBMS_OUTPUT.PUT_LINE('TEST OUT - NOUVELLE VALEUR : ' || nom_variable);
END;

SELECT * FROM all_errors WHERE NAME LIKE 'OBTENIRVALEURINOUT';

-----------------------------------
-- PROCEDURE avec param�tres IN OUT
CREATE or REPLACE PROCEDURE ObtenirValeurINOUT(p_index IN OUT integer)
IS
BEGIN
  -- Possible de lire la valeur de p_index en entr�e car IN OUT
  p_index := p_index + 5;
END;

-- Appel de la procedure ObtenirValeurINOUT
DECLARE
  -- nom_variable est initialis�e --> retour fonction = 10
  nom_variable integer:=5;
  
  -- nom_variable n'est pas initialis�e --> retour fonction = 0
  -- nom_variable integer;
BEGIN
  ObtenirValeurINOUT(nom_variable);
  DBMS_OUTPUT.PUT_LINE('TEST IN OUT - NOUVELLE VALEUR : ' || nom_variable);
END;

--
-- Exemple de proc�dure avec param�tres IN OUT
--

-- Cr�ation de la proc�dure
CREATE or REPLACE PROCEDURE ObtenirNomMedecin1(p_code IN VARCHAR2, p_nom OUT VARCHAR2)
-- CREATE or REPLACE PROCEDURE ObtenirNomMedecin1(p_code IN VARCHAR2, p_nom OUT VARCHAR2)
IS
BEGIN
  SELECT nom INTO p_nom FROM MEDECIN WHERE NUMEROMED like p_code;
END;
 
-- Ex�cution de la proc�dure
DECLARE
  v_nom VARCHAR2(20);
BEGIN
  ObtenirNomMedecin1('NUMEROMED1', v_nom);
  DBMS_OUTPUT.PUT_LINE('Nom du m�decin NUMEROMED1 : ' || v_nom);
END;

-- Nok
-- EXECUTE ObtenirNomMedecin1('NUMEROMED1', v_nom);

--
-- Exemple de proc�dure avec un param�tre IN initialis� par d�faut 
-- et un param�tre OUT
-- Attention : Il faut mettre en 1er les variables sans valeur par d�faut
--

-- Cr�ation de la proc�dure
CREATE or REPLACE PROCEDURE ObtenirNomMedecin2(p_nom OUT VARCHAR2,
          p_code IN VARCHAR2 := 'NUMEROMED2')
IS
BEGIN
  SELECT nom INTO p_nom FROM MEDECIN WHERE NumeroMed = p_code;
  EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE ('ERREUR');
END;

-- Ex�cution de la proc�dure
DECLARE
  nom_variable VARCHAR2(20);
BEGIN
  ObtenirNomMedecin2(nom_variable);
  DBMS_OUTPUT.PUT_LINE('TEXTE A AFFICHER : ' || nom_variable);
  ObtenirNomMedecin2(nom_variable,'NUMEROMED1');
  DBMS_OUTPUT.PUT_LINE('TEXTE A AFFICHER : ' || nom_variable);
END;

/****************************************************************************** 
					SAISIE DE PARAMETRES
						Comment faire saisir des valeurs � l'utilisateur 
						dans une proc�dure PL/SQL ? 
******************************************************************************/

CREATE OR REPLACE PROCEDURE TEST_SAISIE(param1 IN varchar2,param2 IN varchar2)
IS
BEGIN
     dbms_output.put_line('Le param�tre 1 vaut ' || param1);
     dbms_output.put_line('Le param�tre 2 vaut ' || param2);
EXCEPTION
     WHEN others THEN
      dbms_output.put_line('erreur');
END;

-- Appel de la procedure en pr�fixant les param�tres par &
-- Permet de demander la saisie des valeurs
DECLARE
  v_test VARCHAR2(200);
BEGIN
  v_test := '&v_val1&v_val2';
  dbms_output.put_line(v_test);
END;

accept v_texte1 NUM prompt 'Premier param�tre ?'
accept v_texte2 NUM prompt 'Deuxi�me param�tre ?'
DECLARE
  v_test VARCHAR2(200);
BEGIN
  v_test := '&v_texte1&v_texte2';
  dbms_output.put_line(v_test);
END;


-- Ex�cuter la proc�dure en pr�fixant les param�tres par &
-- Permet de demander la saisie des valeurs
EXECUTE TEST_SAISIE('&param1','&param2');

/*****************************************************
             FONCTIONS / PROCEDURES 
             RECAPITULATIF
    -- Cr�er une proc�dure/fonction
    -- Supprimer une proc�dure/fonction
    -- Compiler une fonction/proc�dure
    -- Ex�cuter une proc�dure/fonction
    -- Afficher les erreurs de compilation 
    -- Afficher la liste des PROCEDURES/FONCTIONS/TRIGGERS
    -- Afficher le code source des PROCEDURES/FONCTIONS/TRIGGERS
*****************************************************/

--
-- CREATION
--
-- Attention :  vous ne pouvez pas cr�er une fonction avec un nom d�j� attribu� 
--              � une proc�dure et inversement

-- Cr�er une proc�dure
CREATE OR REPLACE PROCEDURE MAPROCEDURE
AS
BEGIN   
    dbms_output.put_line('Proc�dure qui ne fait rien. Quelle chance !!!');
END;

-- Cr�er une fonction
CREATE OR REPLACE FUNCTION MAFONCTION
RETURN VARCHAR2 
AS
BEGIN   
    dbms_output.put_line('Fonction qui ne fait rien. Quelle chance !!!');
    return 'Cool';
END;

--
-- SUPPRESSION
--

-- Supprimer une proc�dure (en tant que papyrus)
DROP PROCEDURE nom_procedure;

-- Supprimer une fonction (en tant que papyrus)
DROP FUNCTION nom_fonction;

-- Supprimer une proc�dure (en tant que sys)
DROP PROCEDURE papyrus.nom_procedure;

-- Supprimer une fonction (en tant que sys)
DROP FUNCTION papyrus.nom_fonction;

--
-- COMPILATION
--

-- Compiler la proc�dure MAPROCEDURE
ALTER PROCEDURE MAPROCEDURE COMPILE;

-- Compiler la fonction MAFONCTION
ALTER FUNCTION MAFONCTION COMPILE;

--
-- EXECUTION
--

-- Execution proc�dure via EXECUTE
EXECUTE MAPROCEDURE

-- Execution proc�dure via bloc anonyme
BEGIN
MAPROCEDURE;
END;

-- Ex�cution fonction avec une pseudo requ�te
SELECT MAFONCTION FROM dual;

-- Execution fonction via un bloc anonyme
DECLARE
  nom_variable VARCHAR2(20);
BEGIN
  -- Appel de la fonction
  nom_variable := MAFONCTION;
  DBMS_OUTPUT.PUT_LINE('TEXTE A AFFICHER : ' || nom_variable);
    -- OU
  DBMS_OUTPUT.PUT_LINE('TEXTE A AFFICHER : ' || MAFONCTION);
END;

--
-- AFFICHER LES ERREURS DE COMPILATION
--

-- Pour afficher les erreurs de compilation des fonctions/proc�dures
-- de l'utilisateur connect�
SELECT * FROM user_errors;
SELECT * FROM all_errors;

-- Pour afficher les erreurs de compilation de la fonction MAFONCTIONERREUR
SELECT * FROM all_errors WHERE NAME LIKE 'MAFONCTIONERREUR';

-- Proc�dure avec erreur de compilation
CREATE OR REPLACE PROCEDURE MAFONCTIONERREUR
AS
    dbms_output.put_line('Fonction qui ne fait rien')  -- Il manque le ;
    return 'Cool';
END;

--
-- AFFICHER LA LISTE DES PROCEDURES/FONCTIONS/TRIGGERS
--
-- Champ status -> indique si compilation avec ou sans erreur

-- Executer en tant que SYSTEM 
SELECT owner, object_name, object_type, status from dba_objects
WHERE object_type in ('PROCEDURE','FUNCTION','TRIGGER','PACKAGE')
AND owner in ('PAPYRUS')
ORDER BY owner, object_name;

--
-- AFFICHER LE CODE SOURCE DES PROCEDURES/FONCTIONS/TRIGGERS
--

-- Visualiser le code source des fonctions, procedures et triggers
SELECT text, name FROM user_source where name LIKE 'NOM_PROCEDURE';

-- Pour visualiser les champs de la table user_source (commande PL*SQL)
DESC user_source

-- R�sultat ci-dessous
-- NAME        VARCHAR2(30)                                                                                                                                                                                  
-- TYPE        VARCHAR2(12)                                                                                                                                                                                  
-- LINE        NUMBER                                                                                                                                                                                        
-- TEXT        VARCHAR2(4000) 

/******************************************************************************* 
                           REQUETES DYNAMIQUES
                            EXECUTE IMMEDIATE
*******************************************************************************/

-- Diff�rentes syntaxes
-- execute immediate 'sql-statement';
-- execute immediate 'select-statement' into returned_1, returned_2..., returned_n;
-- execute immediate 'sql-statement' using [in|out|in out] bind_var_1, [in|out|in out] bind_var_2 ... [in|out|in out] bind_var_n;
-- execute immediate 'select-statement' into returned_1, returned_2..., returned_n  using [in|out|in out] bind_var_1, [in|out|in out] bind_var_2 ... [in|out|in out] bind_var_n;
-- execute immediate 'sql-statement' returning into var_1;
-- execute immediate 'sql-statement' bulk collect into index-by-var;

-- Ne fonctionne pas
BEGIN
select * from fournisseur;
END;

-- Fonctionne mais pas d'affichage
BEGIN
execute immediate 'select * from fournisseur';
END;

/*
* tbl : nom de la table
*/
CREATE OR REPLACE FUNCTION COUNT_IN_TABLE(tbl IN varchar2)
RETURN number
IS
  -- Nombre de lignes dans la table
  cnt number;
BEGIN
  EXECUTE IMMEDIATE 'select count(*) from ' || tbl into cnt;
  RETURN cnt;
END;

DECLARE
  v_count number;
BEGIN
  v_count:=COUNT_IN_TABLE('FOURNISSEUR');
  dbms_output.put_line('Nombre de lignes : ' || v_count);
  
  v_count:=COUNT_IN_TABLE('PRODUIT');
  dbms_output.put_line('Nombre de lignes : ' || v_count);
END;


/*
* tbl : nom de la table
* attr : Nom de la colonne dans la table qui devra contenir attrval
* attrval : Valeur compar�e avec le contenu de attr
*/
CREATE OR REPLACE FUNCTION COUNT_IN_TABLE_2(tbl in varchar2,
                                            attr in varchar2, 
                                            attrval in varchar2)
RETURN number
IS
  -- Variable contenant le nombre de lignes dans la table
  cnt number;
BEGIN
  EXECUTE IMMEDIATE 'select count(*) from ' || tbl || ' where ' || attr || ' = :a' into cnt using attrval;
  -- Retourne le nombre de lignes
  RETURN cnt;
END;

DECLARE
  v_count number;
BEGIN
  v_count:=COUNT_IN_TABLE_2('LIGCOM','numcom', '70010');
  dbms_output.put_line('Nombre de lignes : ' || v_count);
END;
-- Ex�cution de requ�tes et de code PL/SQL avec EXECUTE IMMEDIATE

DECLARE
  sqlString VARCHAR2(200);
  codeBlock VARCHAR2(200);
BEGIN
  -- Cr�ation de la table execute_table
  EXECUTE IMMEDIATE 'CREATE TABLE execute_table (col1 VARCHAR(10))';
  
  -- Insertion des donn�es dans la table execute_table
  FOR v_Counter IN 1..10 LOOP
    sqlString :='INSERT INTO execute_table VALUES (''Row ' || v_Counter || ''')';
    EXECUTE IMMEDIATE sqlString;
  END LOOP;

  -- Cr�ation du bloc de code
  codeBlock :=
  'BEGIN
  FOR v_Rec IN (SELECT * FROM execute_table) LOOP
  DBMS_OUTPUT.PUT_LINE(v_Rec.col1);
  END LOOP;
  END;';

  -- Ex�cution du bloc de code
  EXECUTE IMMEDIATE codeBlock;
  
  -- Suppression de la table
  EXECUTE IMMEDIATE 'DROP TABLE execute_table';
END;

/******************************************************************************* 
                            GESTION DES EXCEPTIONS
*******************************************************************************/

-- BLOC ANONYME
-- Affichage de SQLCODE & SQLERRM
-- Utilisation de INTO pour plusieurs enregistrements
DECLARE
  v_codetype VARCHAR2(25);
BEGIN
  SELECT codetypevisite INTO v_codetype FROM visite WHERE NumeroMed =
         'NUMEROMED3';
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE ('Code : ' || TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE ('Message : ' || SQLERRM);
  WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE ('AUTRE ERREUR');
END;

-- BLOC ANONYME
-- Traitement d'une exception PREDEFINIE
-- Utilisation de INTO pour plusieurs enregistrements
DECLARE
  v_codetypevisite VARCHAR2(20);
BEGIN
  SELECT codetypevisite INTO v_codetypevisite
  FROM visite
  WHERE NumeroMed = 'NUMEROMED13';
EXCEPTION -- exception handlers begin
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE ('DONNEE NON TROUVEE');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE ('PLUS D''UNE LIGNE SELECTIONNEE');
END;

-- Exception lev�e car NUMEROMED13 n'existe pas
CREATE OR REPLACE PROCEDURE TESTEXCEPTION
IS
  v_codetypevisite VARCHAR2(20);
BEGIN
  SELECT codetypevisite INTO v_codetypevisite
  FROM visite
  WHERE NumeroMed = 'NUMEROMED13';
EXCEPTION -- exception handlers begin
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE ('DONNEES NON TROUVEES');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE ('PLUS D''UNE LIGNE SELECTIONNEE');
END;

BEGIN
TESTEXCEPTION();
END;

-- BLOC ANONYME
-- D�clenchement d'une exception : RAISE
-- D�claration d'une exception : EXCEPTION
DECLARE
  MonException EXCEPTION;
  vprix TYPEVISITE.PRIXVISITE%TYPE;
  -- Exception utilisateur
  -- vcode VARCHAR2(20) := 'CODETYPEVISITE1';
  -- Exception NO_DATA_FOUND
  vcode VARCHAR2(20) := 'CODETYPEVISITE1';
BEGIN
  SELECT prixvisite
  INTO vprix
  FROM TYPEVISITE WHERE CODETYPEVISITE = vcode;
  IF vprix > 50
    THEN RAISE MonException; 
  END IF;
  DBMS_OUTPUT.PUT_LINE (vcode || ' OK');
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('CODE TYPE VISITE INCONNU');
  WHEN MonException THEN
    DBMS_OUTPUT.PUT_LINE(vcode || ' PRIX VISITE > 50');
END;

-- PROCEDURE
-- SANS GESTION DE L'EXCEPTION
-- -> erreur 2292
CREATE or REPLACE PROCEDURE supprimerSpecialite
IS
BEGIN
  DELETE FROM SPECIALITE WHERE CodeSpecialite = 'CODESPECIALITE1';
END;
-- Ex�cution de la proc�dure
EXECUTE supprimerSpecialite;

-- PROCEDURE
-- Gestion de l'exception 2292 avec lien avec un code d'erreur : EXCEPTION_INIT
CREATE or REPLACE PROCEDURE supprimerSpecialiteEx
IS
  resteMedecin EXCEPTION;
  PRAGMA EXCEPTION_INIT(resteMedecin, -2292);
BEGIN
  DELETE FROM SPECIALITE WHERE CodeSpecialite = 'CODESPECIALITE1';
EXCEPTION
WHEN resteMedecin THEN
  DBMS_OUTPUT.PUT_LINE ('SUPPRESSION IMPOSSIBLE DU CODE SPECIALITE');
END;
-- Ex�cution de la proc�dure
EXECUTE supprimerSpecialiteEx;

-- PROCEDURE
-- Gestion exception avec lien avec un code d'erreur : PRAGMA EXCEPTION_INIT
-- PRAGMA est une directive de compilation 
CREATE or REPLACE PROCEDURE supprimerSpecialiteEx1(ma_specia VARCHAR2)
IS
  resteMedecin EXCEPTION;
  PRAGMA EXCEPTION_INIT(resteMedecin, -2292);
  specialiteInexistante EXCEPTION; -- ce n'est pas n�cessaire de la lier � un code d'erreur
BEGIN
  DELETE FROM SPECIALITE WHERE CodeSpecialite = ma_specia;
  IF SQL%NOTFOUND THEN
    RAISE specialiteInexistante;
  END IF;
EXCEPTION
  WHEN resteMedecin THEN
    DBMS_OUTPUT.PUT_LINE ('SUPPRESSION IMPOSSIBLE DU CODE SPECIALITE');
  WHEN specialiteInexistante THEN
    DBMS_OUTPUT.PUT_LINE ('CODE SPECIALITE N''EXISTE PAS');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('AUTRE ERREUR');
END;

-- Ex�cution de la proc�dure
EXECUTE supprimerSpecialiteEx1('CODESPECIALITE1');
EXECUTE supprimerSpecialiteEx1('CODESPECIALITE12');

-- PROCEDURE
-- Gestion exception avec lien avec un code d'erreur : SQL%NOTFOUND
CREATE or REPLACE PROCEDURE ObtenirNomMedecin(p_code VARCHAR2, p_nom OUT VARCHAR2)
IS
  medecinInexistant EXCEPTION;
BEGIN
  SELECT nom INTO p_nom FROM MEDECIN WHERE NumeroMed = p_code;
  -- SQL%NOTFOUND est ignor� car pr�c�d� par exception NO_DATA_FOUND 
  IF SQL%NOTFOUND THEN
    RAISE medecinInexistant;
  END IF;
EXCEPTION
  WHEN medecinInexistant THEN
    DBMS_OUTPUT.PUT_LINE ('CODE SPECIALITE N''EXISTE PAS');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('ERREUR NO_DATA_FOUND');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('AUTRE ERREUR');
    DBMS_OUTPUT.PUT_LINE ('Code : ' || TO_CHAR(SQLCODE));
    DBMS_OUTPUT.PUT_LINE ('Message : ' || SQLERRM);
END;

-- Ex�cution de la proc�dure dans un bloc anonyme
DECLARE
  nom_variable VARCHAR2(20);
BEGIN
  -- Medecin existe dans la base
  ObtenirNomMedecin('NUMEROMED1', nom_variable);
  DBMS_OUTPUT.PUT_LINE('TEXTE A AFFICHER : ' || nom_variable);
  
  -- Medecin n'existe pas dans la base
  ObtenirNomMedecin('NUMEROMED8', nom_variable);
  DBMS_OUTPUT.PUT_LINE('TEXTE A AFFICHER : ' || nom_variable);
END;

-- BLOC ANONYME
-- D�finition de ma propre exception : RAISE_APPLICATION_ERROR
INSERT INTO SPECIALITE (CODESPECIALITE, NOMSPECIALITE) 
VALUES ('CODESPECIALITE12', 'Libelle Specialite 3');

BEGIN
  DELETE FROM SPECIALITE WHERE CodeSpecialite = 'CODESPECIALITE13';
  -- Traitement erreur sur curseur implicite
  DBMS_OUTPUT.PUT_LINE('APRES DELETE');
  -- SQL%NOTFOUND renvoie TRUE lorsque l'ordre SQL pr�c�dent n'a affect� aucune ligne. 
  IF SQL%NOTFOUND THEN
    		RAISE_APPLICATION_ERROR(-20101, 'Suppression impossible', FALSE);
        --RAISE_APPLICATION_ERROR(-20101, 'Suppression impossible', TRUE);
  END IF;
END;

-- RAISE_APPLICATION_ERROR(Numero_erreur, Message, {TRUE|FALSE});
-- �	Numero_erreur : repr�sente le num�ro de l�erreur utilisateur. 
--    Ce num�ro doit �tre compris entre �20000 et �20999.
-- �	Message : cha�ne de caract�res d�une longueur maximale de 2048 octets 
--    qui contient le message associ� � l�erreur.
-- �	Le troisi�me param�tre, qui est optionnel, permet de savoir si l�erreur 
--    doit �tre plac�e sur la pile des erreurs (TRUE) ou bien si l�erreur doit 
--    remplacer toutes les autres erreurs. TRUE par d�faut.

-- Si plusieurs commandes PL/SQL peuvent d�clencher la m�me exception, il faut
-- cr�er des sous-bloc PL/SQL
DECLARE
  v_codetypevisite VARCHAR2(20);
  v_codetypevisite1 VARCHAR2(30);
BEGIN
  BEGIN
    SELECT codetypevisite INTO v_codetypevisite
    FROM typevisite;
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE ('PLUS D''UNE LIGNE SELECTIONNEE DANS TYPEVISTE');
  END;
  BEGIN
    SELECT codetypevisite INTO v_codetypevisite1
    FROM visite
    WHERE NumeroMed = 'NUMEROMED4';
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE ('PLUS D''UNE LIGNE SELECTIONNEE DANS VISITE');
  END;
END;

-- Pas possible de catcher une exception lev�e dans la zone DECLARE
DECLARE
   var CONSTANT NUMBER(3) := 5000;  -- raises an exception
BEGIN
   NULL;
EXCEPTION
   WHEN OTHERS THEN
      -- Cannot catch the exception. This handler is never called.
      dbms_output.put_line('Can''t handle an exception in a declaration.');
END;


/******************************************************************************* 
                            TYPES IMPLICITES
                                %ROWTYPE
                                %TYPE
*******************************************************************************/

-- BLOC ANONYME
-- UTILISATION DE %ROWTYPE
-- SELECT ... INTO dans une seule variable
DECLARE
  -- Variable v_medecin est du type de l'enregistrement de la table MEDECIN
  v_medecin medecin%ROWTYPE;
BEGIN
  -- R�sultat de la requ�te est m�moris� dans la variable v_medecin
  -- v_medecin contient une ligne de la table MEDECIN
  SELECT * INTO v_medecin
  FROM MEDECIN WHERE NumeroMed = 'NUMEROMED1';
  
  DBMS_OUTPUT.PUT_LINE ('NOM DU MEDECIN : ' || v_medecin.nom);
  DBMS_OUTPUT.PUT_LINE ('PRENOM DU MEDECIN : ' || v_medecin.prenom);
  DBMS_OUTPUT.PUT_LINE ('ADRESSE DU MEDECIN : ' || v_medecin.adresse || ' ' 
  || v_medecin.codepostal || ' ' || v_medecin.ville);
END;

-- SELECT ... INTO dans plusieurs variables
-- UTILISATION DE %TYPE
DECLARE
  -- La variable v_non est du m�me type que le champ nom de la table MEDECIN
  v_nom medecin.nom%TYPE;
  -- La variable v_prenom est du m�me type que le champ prenom de la table MEDECIN
  v_prenom medecin.prenom%TYPE;
  v_adresse medecin.adresse%TYPE;
  v_codepostal medecin.codepostal%TYPE;
  v_ville medecin.ville%TYPE;
BEGIN
  SELECT nom,prenom,adresse,codepostal,ville INTO v_nom,v_prenom,
  v_adresse,v_codepostal,v_ville
  FROM MEDECIN WHERE NumeroMed = 'NUMEROMED1';
  DBMS_OUTPUT.PUT_LINE ('NOM DU MEDECIN : ' || v_nom);
  DBMS_OUTPUT.PUT_LINE ('PRENOM DU MEDECIN : ' || v_prenom);
  DBMS_OUTPUT.PUT_LINE ('ADRESSE DU MEDECIN : ' || v_adresse);
  DBMS_OUTPUT.PUT_LINE ('CODE POSTAL/VILLE : ' ||  v_codepostal || ' ' || v_ville);
END;

DECLARE
  v_medecin medecin%ROWTYPE;
BEGIN
  SELECT * INTO v_medecin
  FROM MEDECIN WHERE NumeroMed = 'NUMEROMED1';
  -- L�ve une exception
  DBMS_OUTPUT.PUT_LINE ('NOM DU MEDECIN : ' || v_medecin);
END;
