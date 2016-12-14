DROP TABLE VOYAGE;
DROP TABLE AEROPORT;
DROP TABLE VOL;
DROP TABLE AVION;

DROP TABLE RESULTAT;

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
	"LIBELLE" VARCHAR2(60), 
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
