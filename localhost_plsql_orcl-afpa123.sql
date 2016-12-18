


create user plsql identified by 1234;
grant connect to plsql;
grant resource to plsql;

DROP TABLE RESULTAT;
DROP TABLE AEROPORT;
DROP TABLE VOL;
DROP TABLE AVION;
DROP TABLE VOYAGE;


CREATE TABLE "AEROPORT"
(	"COD_AER" CHAR(3) NOT NULL ENABLE, 
	"LIB_AER" VARCHAR2(40) NOT NULL ENABLE, 
	"VIL_AER" VARCHAR2(20) NOT NULL ENABLE,
	 CONSTRAINT "AEROPORT_PK" PRIMARY KEY ("COD_AER")
);

CREATE TABLE "VOL"
(	"NUM_VOL" CHAR(6) NOT NULL ENABLE, 
	"COD_AER_DEP" CHAR(3) NOT NULL ENABLE, 
	"COD_AER_ARR" CHAR(3) NOT NULL ENABLE,
	 CONSTRAINT "VOL_PK" PRIMARY KEY ("NUM_VOL")
);

CREATE TABLE "AVION"
(	"NUM_AVI" CHAR(5) NOT NULL ENABLE, 
	"TYP_AVI" CHAR(10) NOT NULL ENABLE, 
	"CAP_AVI" NUMBER(3,0) NOT NULL ENABLE,
	 CONSTRAINT "AVION_PK" PRIMARY KEY ("NUM_AVI")
);

CREATE TABLE "VOYAGE"
(	"NUM_VOY" CHAR(6) NOT NULL ENABLE, 
	"NUM_VOL" CHAR(6) NOT NULL ENABLE, 
	"DAT_VOY" DATE NOT NULL ENABLE,
	"NUM_AVI" CHAR(5) NOT NULL ENABLE,
	"NOM_COM" CHAR(15) NOT NULL ENABLE,
	"PLA_RES" NUMBER(3,0) NOT NULL ENABLE,
	CONSTRAINT "VOYAGE_PK" PRIMARY KEY ("NUM_VOY"),
	CONSTRAINT "FK_VOYAGE_VOL" FOREIGN KEY ("NUM_VOL")
	REFERENCES "VOL" ("NUM_VOL"),
	CONSTRAINT "FK_VOYAGE_AVION" FOREIGN KEY ("NUM_AVI")
	REFERENCES "AVION" ("NUM_AVI")
);

CREATE TABLE "RESULTAT"
(	"NO" NUMBER(2), 
	"LIBELLE" VARCHAR2(100), 
	"VALEUR" NUMBER(9,2)
);


INSERT INTO AEROPORT (COD_AER, LIB_AER, VIL_AER) 
VALUES ('CDG', 'A�roport Charles de Gaulle', 'Capitaine1');
INSERT INTO AEROPORT (COD_AER, LIB_AER, VIL_AER) 
VALUES ('ABL', 'A�roport de Blagnac', 'Blagnac');
INSERT INTO AEROPORT (COD_AER, LIB_AER, VIL_AER) 
VALUES ('AMG', 'A�roport de M�rignac', 'M�rignac');

INSERT INTO VOL (NUM_VOL, COD_AER_DEP, COD_AER_ARR) 
VALUES ('VOL001', 'CDG', 'ABL');
INSERT INTO VOL (NUM_VOL, COD_AER_DEP, COD_AER_ARR) 
VALUES ('VOL002', 'ABL', 'CDG');
INSERT INTO VOL (NUM_VOL, COD_AER_DEP, COD_AER_ARR) 
VALUES ('VOL003', 'AMG', 'CDG');

INSERT INTO AVION (NUM_AVI, TYP_AVI, CAP_AVI) 
VALUES ('AV001', 'CONCORDE', 250);
INSERT INTO AVION (NUM_AVI, TYP_AVI, CAP_AVI) 
VALUES ('AV002', 'AIRBUS', 250);
INSERT INTO AVION (NUM_AVI, TYP_AVI, CAP_AVI) 
VALUES ('AV003', 'BOEING', 350);

INSERT INTO VOYAGE (NUM_VOY, NUM_VOL, DAT_VOY,NUM_AVI,NOM_COM,PLA_RES) 
VALUES ('VOY001', 'VOL001', sysdate,'AV001','CAPITAINE1',100);
INSERT INTO VOYAGE (NUM_VOY, NUM_VOL, DAT_VOY,NUM_AVI,NOM_COM,PLA_RES) 
VALUES ('VOY002', 'VOL002', TO_DATE('2010/04/12 12:00:00', 'YYYY/MM/DD  HH24:MI:SS'),'AV002','CAPITAINE2',200);
INSERT INTO VOYAGE (NUM_VOY, NUM_VOL, DAT_VOY,NUM_AVI,NOM_COM,PLA_RES) 
VALUES ('VOY003', 'VOL003', TO_DATE('2010/06/12 12:00:00', 'YYYY/MM/DD  HH24:MI:SS'),'AV002','CAPITAINE3',250);
INSERT INTO VOYAGE (NUM_VOY, NUM_VOL, DAT_VOY,NUM_AVI,NOM_COM,PLA_RES) 
VALUES ('VOY004', 'VOL003', TO_DATE('2010/08/12 12:00:00', 'YYYY/MM/DD  HH24:MI:SS'),'AV003','CAPITAINE4',250);

---------------------------------------------------------------------------------------------------------------
----------------------------------VISUALISER LES STRUCTURES DES TABLES -----------------------------------------


desc aeroport;

desc vol;
desc avion;
desc voyage;
desc resultat;

-------------------------Contenu des tables utilisées----------
select * from aeroport ;
select * from vol;
select * from avion;
select * from voyage;


-------------------------------Exercice 1 : multiplication--------------------------
------------------------Exercice 1.1
--Codez un bloc anonyme PL/SQL qui permet de calculer et d�afficher une table de multiplication.
--La table de multiplication � utiliser est demand�e � l�utilisateur suite �
--l'ex�cution du bloc anonyme. Utilisez la table RESULTAT pour stocker les valeurs.


---------------------TEST---------------------------------
DECLARE 
  nombre NUMBER ;
  nombre1 Number;
BEGIN
   
  nombre:= &nombre1;
  nombre1:=&nombre;

   DBMS_OUTPUT.PUT_LINE('vous aver entrer   ' ||(nombre+nombre1));
END;



DECLARE 
  V_VALEUR NUMBER ;
  V_COMPTEUR NUMBER ;
BEGIN
 
  V_VALEUR :=&VALEUR;
  V_COMPTEUR :=1;
  FOR V_COMPTEUR IN 1..10 LOOP
  INSERT INTO RESULTAT VALUES (NULL,V_COMPTEUR ||'*'||V_VALEUR,V_COMPTEUR * V_VALEUR);
  END LOOP;
END;


SELECT LIBELLE,VALEUR FROM RESULTAT;


-----------------------------------Exercice 1.2
--Codez un bloc anonyme PL/SQL qui permet d’effectuer une multiplication entre un
--multiplicande et un multiplicateur et d’afficher le résultat obtenu. Exécutez le bloc anonyme.

DECLARE 
  V_NOMBRE1 NUMBER ;
  V_NOMBRE2 NUMBER ;
BEGIN
  V_NOMBRE1 :=&V_NOMBRE1;
  V_NOMBRE2 :=&V_NOMBRE2;
  DBMS_OUTPUT.PUT_LINE('LA MULTIPLICATION   ' ||(V_NOMBRE1*V_NOMBRE2));
 
END;
/

------------------------------Exercice 1.3---------------------------------------
--Transformez le bloc anonyme PL/SQL en une procédure sans paramètre. Exécutez la
--procédure à l’aide d’un bloc anonyme.

CREATE OR REPLACE PROCEDURE ma_procedure1
  IS
    V_NOMBRE1 NUMBER ;
    V_NOMBRE2 NUMBER ;
  BEGIN
    V_NOMBRE1 :=&V_NOMBRE1;
    V_NOMBRE2 :=&V_NOMBRE2;
     DBMS_OUTPUT.PUT_LINE('LA MULTIPLICATION   ' ||(V_NOMBRE1*V_NOMBRE2));
END;




BEGIN 
ma_procedure1;
END;

EXECUTE ma_procedure1;


--------------------------Exercice 1.4----------------------------------------------------
--Transformez la proc�dure sans param�tre en une proc�dure avec 2 
--param�tres en entr�e (multiplicande et multiplicateur). Ex�cutez la proc�dure � l�aide d�un bloc anonyme.


CREATE OR REPLACE PROCEDURE ma_procedure2(multiplicande NUMBER ,multiplicateur NUMBER )
  IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('LA MULTIPLICATION   ' ||(multiplicande*multiplicateur));
END;


BEGIN 
ma_procedure2(6 ,6 );
END;

-------------------------------------------Exercice 1.5----------------------------------
--Transformez la proc�dure avec 2 param�tres en entr�e (multiplicande et multiplicateur) en une proc�dure avec 2 param�tres en entr�e 
--(multiplicande et multiplicateur) et 1 param�tre en sortie (r�sultat de la multiplication). Ex�cutez la proc�dure � l�aide d�un bloc anonyme.


CREATE OR REPLACE PROCEDURE ma_procedure3(
multiplicande IN INTEGER ,
multiplicateur IN INTEGER,
resultat  OUT INTEGER)
 IS 
BEGIN
resultat:=multiplicande*multiplicateur;
DBMS_OUTPUT.PUT_LINE(resultat);
END;
--------------------------execution-----------------------------

DECLARE 
multiplicande INTEGER ; multiplicateur INTEGER; resultat INTEGER;
BEGIN 
multiplicande:=8;
multiplicateur :=8;
resultat := multiplicande*multiplicateur;
ma_procedure3(multiplicande,multiplicateur,resultat);
END;

--------------------------------------Exercice 1.6------------------------------
--Transformez la proc�dure pr�c�dente en une fonction avec 2 param�tres en entr�e 
--(multiplicande et multiplicateur) et une valeur de retour (r�sultat de la multiplication).
--Ex�cutez la fonction � l�aide d�un bloc anonyme.

CREATE OR REPLACE FUNCTION MA_FONCTION1(
              multiplicande INTEGER ,
              multiplicateur INTEGER
              )RETURN INTEGER
 IS 
 resultat INTEGER;
BEGIN
    resultat := (multiplicande*multiplicateur);
    RETURN (resultat);
END;


----------------------------Ex�cutez la fonction � l�aide d�un bloc anonyme.------------


BEGIN
DBMS_OUTPUT.PUT_LINE(MA_FONCTION1(5,9));
END;

--------------------------------------------Exercice 2------------------------------
------------------------------------------------------------------------------------
DECLARE 
v_num_voy CHAR(6);
v_typ_avi CHAR(10);
v_num_avi CHAR (5);
BEGIN
---------------SAISIR  LE CODE ENTRE PAR L'UTILISATEUR --------------------
v_num_voy := '&VALEUR';
--------------STOCKER LE RESULTAT DE LA REQ DANS LA VARIABLE ---------
SELECT TYP_AVI INTO v_typ_avi  FROM AVION INNER JOIN VOYAGE 
ON AVION.NUM_AVI=VOYAGE.NUM_AVI

 AND NUM_VOY LIKE v_num_voy;
      CASE (v_typ_av :=)
             WHEN  'CONCORDE'
             THEN   UPDATE VOYAGE SET PLA_RES = PLA_RES +50;
    
             WHEN  v_typ_avi LIKE 'AIRBUS'
             THEN   UPDATE VOYAGE SET PLA_RES =PLA_RES +1
WHERE  NUM_VOY LIKE v_num_voy;
--------------STOCKER LE RESULTAT DE LA REQ DANS LA VARIABLE ---------
SELECT NUM_AVI INTO v_num_avi FROM AVION 
WHERE TYP_AVI LIKE v_typ_avi;
-------------------------ETUDE CAS PAR CAS TYPE D'AVION ---------------
   CASE V_TYP_AVI
         WHEN   'CONCORDE'
         THEN
                UPDATE VOYAGE SET PLA_RES = PLA_RES +50
                WHERE NUM_AVI=(v_num_avI);
         
              INSERT INTO RESULTAT VALUES (1,'VOYAGE N  '|| v_num_voy||' AUGMENTE DE 50 PLACES',
              (SELECT PLA_RES FROM VOYAGE WHERE NUM_VOY LIKE v_num_voy));
          
          WHEN 'AIRBUS'
          THEN   
                 UPDATE VOYAGE SET PLA_RES =PLA_RES +100
                 WHERE NUM_AVI=(v_num_avI);
          
                 INSERT INTO RESULTAT VALUES (1,'VOYAGE N '||v_num_voy||' AUGMENTE DE 100 PLACES',
                (SELECT PLA_RES FROM VOYAGE WHERE NUM_VOY LIKE v_num_voy));
          ELSE  
               UPDATE VOYAGE SET PLA_RES =PLA_RES +100
               WHERE NUM_AVI=(v_num_avI);

              
                INSERT INTO RESULTAT VALUES (1,'VOYAGE N '||v_num_voy||' AVION '||v_typ_avi ||
                'AUGMENTE DE 100 PLACES',(SELECT PLA_RES FROM VOYAGE WHERE NUM_VOY LIKE v_num_voy));
    END CASE;
------------------------------EXECEPTION  EN CAS D'UN CODE DE VOYAGE INCORRECTE-------------------
EXCEPTION
     WHEN others THEN
      dbms_output.put_line('erreur');
END;



----------------------------------------------------------------------------------------------------------
----------------------------------------curseurs----------------------------------------------------

DECLARE  CURSOR C_MACURSOR 
IS 
SELECT NUM_VOY,DAT_VOY FROM VOYAGE ;
V_LIGNE  C_MACURSOR%ROWTYPE;
VI INTEGER;
BEGIN
VI:=12;
    OPEN C_MACURSOR;
        LOOP 
          FETCH C_MACURSOR INTO V_LIGNE ;
          EXIT WHEN C_MACURSOR%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE(V_LIGNE.NUM_VOY||'   '||V_LIGNE.DAT_VOY);
          --DBMS_OUTPUT.PUT_LINE(V_LIGNE.NUM_VOY||'   '||V_LIGNE.DAT_VOY);
          VI:=VI+1;
        END LOOP;
   CLOSE C_MACURSOR;
    DBMS_OUTPUT.PUT_LINE(VI);
END;

------------------------------------------------------------------------------------
----------------------CURSOR AVEC BOCLE FOR--------------------------


DECLARE  CURSOR C_MACURSOR1
IS 
SELECT NUM_VOY,DAT_VOY FROM VOYAGE ;

VI INTEGER;
BEGIN
    V:3;
    FOR  LINE IN  C_MACURSOR1    LOOP
      DBMS_OUTPUT.PUT_LINE(LINE.NUM_VOY||'   '||LINE.DAT_VOY);
      DBMS_OUTPUT.PUT_LINE(%ROWCOUNT);
    END LOOP;
END;


---------------------------------------------------------------------------------------
-----------------------------EXERCICE  3--------------------------------------------

-----------------------------------------------------------------------------------------
-------------------------------GESTION DES LINE A AFFCHER--------------------------------
DECLARE  CURSOR C_MACURSOR1
IS 
SELECT NUM_VOY,DAT_VOY FROM VOYAGE ;

VI INTEGER;
BEGIN
    VI:=&NUMERO_LINE;
    FOR  LINE IN  C_MACURSOR1    LOOP
     -- DBMS_OUTPUT.PUT_LINE(LINE.NUM_VOY||'   '||LINE.DAT_VOY);
        IF (C_MACURSOR1%ROWCOUNT= VI OR C_MACURSOR1%ROWCOUNT= (VI+1)) THEN
              DBMS_OUTPUT.PUT_LINE(LINE.NUM_VOY||'   '||LINE.DAT_VOY);
        END IF;
    END LOOP;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('SAISI INCORRECT');

END;

------------------------------------------------------------------------------------------------
-------------------------------EXERCICE 4------------------------------------------------------

----------------------ETAPE 1------------------------------------------------------------
 DECLARE 
 compteur int;
 
 TYPE type_aeroport IS TABLE OF AEROPORT%ROWTYPE INDEX BY BINARY_INTEGER ;
  tableau_aeroport type_aeroport;
 CURSOR C_MACURSOR IS
 SELECT * FROM  AEROPORT;
 BEGIN 
 compteur:=0;
 
      FOR  LINE IN  C_MACURSOR    LOOP
          tableau_aeroport(compteur) :=LINE;
          DBMS_OUTPUT.PUT_LINE (tableau_aeroport(compteur).lib_aer||' '
          ||tableau_aeroport(compteur).vil_aer);
      END LOOP;
      
--      j := tableau_aeroport.lib_aer.FIRST;
--      WHILE i IS NOT NULL LOOP
--      DBMS_OUTPUT.PUT_LINE (tableau_aeroport(compteur).lib_aer||' '
--      ||tableau_aeroport(compteur).vil_aer);
--       i := lib_aer.NEXT(i);
--     END LOOP;
END;


----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

---------------------EXERCICE 5--------------------------------------------------
--Codez un bloc anonyme PL/SQL qui permet de stocker dans un tableau les numéros de
--voyage, de vol, le type d’avion et l’aéroport de départ.
--Affichez dans un second temps le contenu du tableau.


 DECLARE 
 compteur int;
 
 
 CURSOR C_MACURSOR IS
 SELECT num_voy,num_vol,typ_avion FROM  AEROPORT;
 TYPE type_aeroport IS TABLE OF AEROPORT%ROWTYPE INDEX BY BINARY_INTEGER ;
  tableau_aeroport type_aeroport;
 BEGIN 
 compteur:=0;
 
      FOR  LINE IN  C_MACURSOR    LOOP
          tableau_aeroport(compteur) :=LINE;
          DBMS_OUTPUT.PUT_LINE (tableau_aeroport(compteur).lib_aer||' '
          ||tableau_aeroport(compteur).vil_aer);
      END LOOP;
      
--      j := tableau_aeroport.lib_aer.FIRST;
--      WHILE i IS NOT NULL LOOP
--      DBMS_OUTPUT.PUT_LINE (tableau_aeroport(compteur).lib_aer||' '
--      ||tableau_aeroport(compteur).vil_aer);
--       i := lib_aer.NEXT(i);
--     END LOOP;
END;




















