

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


Insert into SALAIRE.SALARIE (NUMMATRIC,NOM,PRENOM,ADR,CODPOSTAL,VILLE,CODSERVICE) values ('1001','Durand','Paul','24 rue Tiers','92000','Nanterre','Fin01');
Insert into SALAIRE.SALARIE (NUMMATRIC,NOM,PRENOM,ADR,CODPOSTAL,VILLE,CODSERVICE) values ('1002','Blaise','Pascal','5 rue des pens�es  ','92000','Nanterre','Pro10');
Insert into SALAIRE.SALARIE (NUMMATRIC,NOM,PRENOM,ADR,CODPOSTAL,VILLE,CODSERVICE) values ('1003','Blaise','Pascal','12 rue des troubadours','31800','Toulouse','Pro10');



Insert into SALAIRE.SERVICE (CODSERVICE,NOMSERVICE) values ('Fin01','Direction financi�re');
Insert into SALAIRE.SERVICE (CODSERVICE,NOMSERVICE) values ('Pro10','Production');

Insert into SALAIRE.SERVICE (CODSERVICE,NOMSERVICE) 
values 
('Can10','Can10'),
('Can11','Can11'),
('Can12','Can12');


--  Constraints for Table RUBRIQUE
--------------------------------------------------------

  ALTER TABLE "RUBRIQUE" ADD CONSTRAINT "RIBRIQUE_PK" PRIMARY KEY ("NORUBRIQUE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "SALAIRE"."RUBRIQUE" MODIFY ("SENS" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."RUBRIQUE" MODIFY ("LIBELLE" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."RUBRIQUE" MODIFY ("NORUBRIQUE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SALARIE
--------------------------------------------------------

  ALTER TABLE "SALARIE" ADD CONSTRAINT "SALARIE_PK" PRIMARY KEY ("NUMMATRIC")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "SALAIRE"."SALARIE" MODIFY ("CODSERVICE" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."SALARIE" MODIFY ("VILLE" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."SALARIE" MODIFY ("CODPOSTAL" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."SALARIE" MODIFY ("ADR" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."SALARIE" MODIFY ("PRENOM" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."SALARIE" MODIFY ("NOM" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."SALARIE" MODIFY ("NUMMATRIC" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SERVICE
--------------------------------------------------------

  ALTER TABLE "SALAIRE"."SERVICE" ADD CONSTRAINT "SERVICE_PK" PRIMARY KEY ("CODSERVICE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "SALAIRE"."SERVICE" MODIFY ("NOMSERVICE" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."SERVICE" MODIFY ("CODSERVICE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table BULLETIN
--------------------------------------------------------

  ALTER TABLE "SALAIRE"."BULLETIN" MODIFY ("MONTANT" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."BULLETIN" MODIFY ("DATEPAYE" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."BULLETIN" MODIFY ("NORUBRIQUE" NOT NULL ENABLE);
  ALTER TABLE "SALAIRE"."BULLETIN" MODIFY ("NUMMATRIC" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table BULLETIN
--------------------------------------------------------

  ALTER TABLE "SALAIRE"."BULLETIN" ADD CONSTRAINT "BULLETIN_FK1" FOREIGN KEY ("NUMMATRIC")
	  REFERENCES "SALAIRE"."SALARIE" ("NUMMATRIC") ENABLE;
  ALTER TABLE "SALAIRE"."BULLETIN" ADD CONSTRAINT "BULLETIN_FK2" FOREIGN KEY ("NORUBRIQUE")
	  REFERENCES "SALAIRE"."RUBRIQUE" ("NORUBRIQUE") ENABLE;
