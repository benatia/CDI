

  CREATE TABLE "BULLETIN" 
   (	"NUMMATRIC" NUMBER(4,0)NOT NULL ENABLE , 
	"NORUBRIQUE" NUMBER(4,0)NOT NULL ENABLE, 
	"DATEPAYE" DATE, 
	"MONTANT" NUMBER(6,0)
   ) ;
--------------------------------------------------------
--  DDL for Table RUBRIQUE
--------------------------------------------------------

  CREATE TABLE "RUBRIQUE" 
   (	"NORUBRIQUE" NUMBER(3,0)NOT NULL ENABLE , 
	"LIBELLE" VARCHAR2(40 BYTE), 
	"SENS" CHAR(1 BYTE)
   )

  CREATE TABLE "SALARIE" 
   (	"NUMMATRIC" NUMBER(4,0)NOT NULL ENABLE, 
	"NOM" VARCHAR2(20 BYTE), 
	"PRENOM" VARCHAR2(20 BYTE), 
	"ADR" VARCHAR2(40 BYTE), 
	"CODPOSTAL" NUMBER(5,0), 
	"VILLE" VARCHAR2(20 BYTE), 
	"CODSERVICE" CHAR(5 BYTE)NOT NULL ENABLE
   ) 

  CREATE TABLE "SERVICE" 
   (	"CODSERVICE" CHAR(5 BYTE)NOT NULL ENABLE, 
	"NOMSERVICE" VARCHAR2(40 BYTE)
   ) 
   
   -----------------------------------------------------------------------
   ----------------------CONTRAINTES -------------------------------------
   ALTER TABLE SALARIE
   ADD CONSTRAINT PK_SALARIE PRIMARY KEY (NUMMATRIC);
   ALTER TABLE SALARIE
   ADD CONSTRAINT FK_SALARIE_SERVICE FOREIGN KEY (CODSERVICE) REFERENCES SERVICE (CODSERVICE);
   
   ALTER TABLE SERVICE 
   ADD CONSTRAINT PK_SAERVIC PRIMARY KEY (CODSERVICE);
   
   ALTER TABLE BULLETIN
   ADD CONSTRAINT  PK_BULLETIN PRIMARY KEY (NUMMATRIC,NORUBRIQUE);
   ALTER TABLE BULLETIN
   ADD CONSTRAINT FK_BULLETIN_SALARIE FOREIGN KEY (NUMMATRIC) REFERENCES SALARIE (NUMMATRIC);
    ALTER TABLE BULLETIN
   ADD CONSTRAINT FK_BULLETIN_SERVICE FOREIGN KEY (CODSERVICE) REFERENCES SALARIE (CODSERVICE);
   
   ALTER TABLE RUBRIQUE
   ADD CONSTRAINT PK_RUBRIQUE PRIMARY KEY (NORUBRIQUE);
   
   


Insert into BULLETIN (NUMMATRIC,NORUBRIQUE,DATEPAYE,MONTANT) values ('1001','1',to_date('31/01/02','DD/MM/RR'),'15000');
Insert into BULLETIN (NUMMATRIC,NORUBRIQUE,DATEPAYE,MONTANT) values ('1001','4',to_date('31/01/02','DD/MM/RR'),'1000');
Insert into BULLETIN (NUMMATRIC,NORUBRIQUE,DATEPAYE,MONTANT) values ('1001','102',to_date('31/01/02','DD/MM/RR'),'1100');
Insert into BULLETIN (NUMMATRIC,NORUBRIQUE,DATEPAYE,MONTANT) values ('1002','1',to_date('31/01/02','DD/MM/RR'),'20000');
Insert into BULLETIN (NUMMATRIC,NORUBRIQUE,DATEPAYE,MONTANT) values ('1002','102',to_date('31/01/02','DD/MM/RR'),'2000');
Insert into SALAIRE.BULLETIN (NUMMATRIC,NORUBRIQUE,DATEPAYE,MONTANT) values ('1002','4',to_date('31/01/02','DD/MM/RR'),'2500');

Insert into RUBRIQUE (NORUBRIQUE,LIBELLE,SENS) values ('1','salaire de base','+');
Insert into RUBRIQUE (NORUBRIQUE,LIBELLE,SENS) values ('2','heures sup � 100%','+');
Insert into RUBRIQUE (NORUBRIQUE,LIBELLE,SENS) values ('3','heures sup � 125%','+');
Insert into RUBRIQUE (NORUBRIQUE,LIBELLE,SENS) values ('4','heures sup � 150%','+');
Insert into RUBRIQUE (NORUBRIQUE,LIBELLE,SENS) values ('102','retenue s�curit� sociale','-');
Insert into RUBRIQUE (NORUBRIQUE,LIBELLE,SENS) values ('200','retenue retraite','-');


Insert into SALARIE (NUMMATRIC,NOM,PRENOM,ADR,CODPOSTAL,VILLE,CODSERVICE) values ('1001','Durand','Paul','24 rue Tiers','92000','Nanterre','Fin01');
Insert into SALARIE (NUMMATRIC,NOM,PRENOM,ADR,CODPOSTAL,VILLE,CODSERVICE) values ('1002','Blaise','Pascal','5 rue des pens�es  ','92000','Nanterre','Pro10');
Insert into SALARIE (NUMMATRIC,NOM,PRENOM,ADR,CODPOSTAL,VILLE,CODSERVICE) values ('1003','Blaise','Pascal','12 rue des troubadours','31800','Toulouse','Pro10');



Insert into SERVICE (CODSERVICE,NOMSERVICE) values ('Fin01','Direction financi�re');
Insert into SERVICE (CODSERVICE,NOMSERVICE) values ('Pro10','Production');

Insert into SERVICE (CODSERVICE,NOMSERVICE) 
values 
('Can10','Can10');
Insert into SERVICE (CODSERVICE,NOMSERVICE) 
values 
('Can11','Can11');
Insert into SERVICE (CODSERVICE,NOMSERVICE) 
values 
('Can12','Can12');

