/****************************************************************************** 
          SOMMAIRE                 
                    • PACKAGES
                    
******************************************************************************/

-- Packages encapsule des fonctionnalités relatives à une unité bien définie 
-- (ex : gestion de fichiers, encryption de données, gestion de la console dbms, ...)
-- Packages sont constitués de 2 composants : une spécification et un corps.
--      La specification contient des informations sur le package.
--      La specification liste les procédures et les fonctions disponibles.
--      La specification ne contient pas le code.
--      Le corps du package contient le code.

-- Compiler un package : spécification et corps
ALTER PACKAGE pkg_test compile package

-- Compiler un package : uniquement le corps
ALTER PACKAGE pkg_test compile body

-- Supprimer un package
DROP PACKAGE pkg_test

-- Donner accès à un package
GRANT EXECUTE ON PAPYRUS.PKG_TEST TO MEDECIN

-- Supprimer accès à un package
REVOKE EXECUTE ON PKG_TEST FROM MEDECIN

-- Exemple de création d'une fonction et d'une procédure
-- au sein d'un package nommé pkg_test

-- Spécification du package : 1 fonction et 1 procédure
CREATE OR REPLACE PACKAGE pkg_test
AS
FUNCTION obtenirAire (p_rad NUMBER) return NUMBER;
PROCEDURE afficherMessage (p_str1 VARCHAR2 :='Salut',
                  p_str2 VARCHAR2 :='les jeunes',
                  p_end VARCHAR2  :='!' );
END;

-- Corps du package : mot clé BODY
-- Création du code de la fonction et de la procédure
CREATE OR REPLACE PACKAGE BODY pkg_test
AS
  FUNCTION obtenirAire (p_rad NUMBER)
  RETURN NUMBER
  IS
  v_pi NUMBER:=3.14;
  BEGIN
    -- Aire cercle = rayon au carré * PI
    RETURN v_pi * (p_rad ** 2);
  END;
  
  PROCEDURE afficherMessage(p_str1 VARCHAR2 :='Salut',
                    p_str2 VARCHAR2 :='les jeunes',
                    p_end VARCHAR2  :='!' )
  IS
  BEGIN
    DBMS_OUTPUT.put_line(p_str1||p_str2||p_end);
  END;
END;
 
BEGIN
-- Appel de la procédure afficherMessage du package pkg_test sans paramètre
PKG_TEST.AFFICHERMESSAGE;
END;

BEGIN
-- Appel de la procédure afficherMessage du package pkg_test avec des paramètres
PKG_TEST.AFFICHERMESSAGE('Vive', ' le Jazz', ' !!!');
END;

DECLARE 
  v_aire NUMBER;
  v_rayon NUMBER:=10;
BEGIN
  -- Appel de la fonction obtenirAire du package pkg_test
  v_aire := pkg_test.obtenirAire(v_rayon);
  DBMS_OUTPUT.put_line('Rayon : ' || v_rayon || ' -> Aire : ' || v_aire);
END;