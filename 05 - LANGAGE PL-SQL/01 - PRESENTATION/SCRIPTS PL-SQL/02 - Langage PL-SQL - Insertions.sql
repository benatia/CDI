-- Suppression des enregistrements : TRUNCATE et DELETE

-- � TRUNCATE est plus rapide que DELETE
--   DELETE : copie des donn�es dans le Tablespace ROLLBACK
-- � TRUNCATE : pas de rollback possible
--              pas de d�clenchement de trigger 
--              pas de condition WHERE
-- � DELETE : rollback possible
--            d�clenchement de trigger
--            condition WHERE possible
--

-- Suppression des enregistrements avec TRUNCATE

TRUNCATE TABLE VILLE;
TRUNCATE TABLE VISITE;

-- D�sactiver la contrainte avant de vider la table
ALTER TABLE MEDECIN DISABLE constraint FK_MEDECIN_SPECIALITE;
-- Vider la table
TRUNCATE TABLE SPECIALITE;

-- D�sactiver la contrainte avant de vider la table
ALTER TABLE VISITE DISABLE constraint FK_VISITE_TYPEVISITE;
-- Vider la table
TRUNCATE TABLE TYPEVISITE;

-- D�sactiver la contrainte avant de vider la table
ALTER TABLE VISITE DISABLE constraint FK_VISITE_MEDECIN;
-- Vider la table
TRUNCATE TABLE MEDECIN;

-- D�sactiver la contrainte avant de vider la table
ALTER TABLE VISITE DISABLE constraint FK_VISITE_MALADE;
-- Vider la table
TRUNCATE TABLE MALADE;

-- Activer les contraintes
ALTER TABLE MEDECIN ENABLE constraint FK_MEDECIN_SPECIALITE;
ALTER TABLE VISITE ENABLE constraint FK_VISITE_TYPEVISITE;
ALTER TABLE VISITE ENABLE constraint FK_VISITE_MEDECIN;
ALTER TABLE VISITE ENABLE constraint FK_VISITE_MALADE;

-- Insertion des donn�es

INSERT INTO SPECIALITE (CODESPECIALITE, NOMSPECIALITE) 
VALUES ('CODESPECIALITE1', 'Libelle Specialite 1');
INSERT INTO SPECIALITE (CODESPECIALITE, NOMSPECIALITE) 
VALUES ('CODESPECIALITE2', 'Libelle Specialite 2');
INSERT INTO SPECIALITE (CODESPECIALITE, NOMSPECIALITE) 
VALUES ('CODESPECIALITE3', 'Libelle Specialite 3');

INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE, NBVISITES) 
VALUES ('NUMEROMED1', 'NOM1', 'PRENOM1', 'ADRESSE1', 31100, 'VILLE1', 'CODESPECIALITE1',0);
INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE, NBVISITES) 
VALUES ('NUMEROMED2', 'NOM2', 'PRENOM2', 'ADRESSE2', 31200, 'VILLE2', 'CODESPECIALITE2',0);
INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE, NBVISITES) 
VALUES ('NUMEROMED3', 'NOM3', 'PRENOM3', 'ADRESSE3', 31200, 'VILLE3', 'CODESPECIALITE2',0);
INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE, NBVISITES) 
VALUES ('NUMEROMED4', 'NOM4', 'PRENOM4', 'ADRESSE4', 31200, 'VILLE4', 'CODESPECIALITE3',0);
INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE) 
VALUES ('CURSMED1', 'NOM1', 'PRENOM1', 'ADRESSE1', 31100, 'VILLE1', 'CODESPECIALITE1');
INSERT INTO MEDECIN (NUMEROMED, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE, CODESPECIALITE) 
VALUES ('CURSMED2', 'NOM1', 'PRENOM1', 'ADRESSE1', 31100, 'VILLE1', 'CODESPECIALITE1');

INSERT INTO MALADE (NUMEROSS, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE) 
VALUES ('164042561678250', 'NOM1', 'PRENOM1', 'ADRESSE1', 31200, 'VILLE1');
INSERT INTO MALADE (NUMEROSS, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE) 
VALUES ('164042561678251', 'NOM2', 'PRENOM2', 'ADRESSE2', 31200, 'VILLE2');
INSERT INTO MALADE (NUMEROSS, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE) 
VALUES ('164042561678252', 'NOM3', 'PRENOM3', 'ADRESSE3', 31200, 'VILLE3');
INSERT INTO MALADE (NUMEROSS, NOM, PRENOM, ADRESSE, CODEPOSTAL, VILLE) 
VALUES ('164042561678253', 'NOM4', 'PRENOM4', 'ADRESSE4', 31200, 'VILLE4');

INSERT INTO TYPEVISITE (CODETYPEVISITE, LIBELLE, PRIXVISITE) 
VALUES ('CODETYPEVISITE1', 'LIBELLE1', 90);
INSERT INTO TYPEVISITE (CODETYPEVISITE, LIBELLE, PRIXVISITE) 
VALUES ('CODETYPEVISITE2', 'LIBELLE2', 70);
INSERT INTO TYPEVISITE (CODETYPEVISITE, LIBELLE, PRIXVISITE) 
VALUES ('CODETYPEVISITE3', 'LIBELLE2', 110);
INSERT INTO TYPEVISITE (CODETYPEVISITE, LIBELLE, PRIXVISITE) 
VALUES ('CODETYPEVISITE4', 'LIBELLE2', 20);
INSERT INTO TYPEVISITE (CODETYPEVISITE, LIBELLE, PRIXVISITE) 
VALUES ('CODETYPEVISITE5', 'LIBELLE5', 20);

INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE1','NUMEROMED1', '164042561678250', TO_DATE('1998/05/31 12:00:00', 
'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE1');
INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE2','NUMEROMED2', '164042561678250', TO_DATE('1998/07/31 12:10:00', 
'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE2');
INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE3','NUMEROMED3', '164042561678250', TO_DATE('1998/07/31 12:10:00', 
'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE2');
INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE4','NUMEROMED3', '164042561678251', TO_DATE('1998/07/31 12:10:00', 
'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE2');
INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE5','NUMEROMED3', '164042561678252', TO_DATE('1998/07/31 12:10:00', 
'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE2');
INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE6','NUMEROMED3', '164042561678253', TO_DATE('1998/07/31 12:10:00', 
'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE2');
INSERT INTO VISITE (NUMEROVISITE, NUMEROMED, NUMEROSS, DATEVISITE, CODETYPEVISITE) 
VALUES ('NUMEROVISITE7','NUMEROMED4', '164042561678253', TO_DATE('1998/07/31 12:10:00', 
'YYYY/MM/DD HH24:MI:SS'), 'CODETYPEVISITE4');

-- V�rification des insertions
select * from MEDECIN;
select * from SPECIALITE;
select * from MALADE;
select * from TYPEVISITE;
select * from VISITE;
select * from VILLE;