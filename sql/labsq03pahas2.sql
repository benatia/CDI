------------------------------------------------------------------------------------------------------------
--------------------------------------III LES BESOIN D4AFFICHAGE

------------les commandes du fournisseur 09120
SELECT COMMANDE.NUMCOM ,COMMANDE.OBSCOM
FROM PAPYRUS.COMMANDE INNER JOIN PAPYRUS.FOURNISSEUR
ON COMMANDE.NUMFOU=FOURNISSEUR.NUMFOU
WHERE FOURNISSEUR.NUMFOU=1;

------2 EME METHODE 
SELECT NUMCOM,OBSCOM
FROM PAPYRUS.COMMANDE
WHERE NUMFOU=1;

--------code des fournisseurs pour lesquels des commandes ont été passées
SELECT NUMFOU FROM COMMANDE
WHERE NUMCOM !=0;

----------2 em methode 
select FOURNISSEUR.NUMFOU
FROM PAPYRUS.FOURNISSEUR INNER JOIN PAPYRUS.COMMANDE ON 
FOURNISSEUR.NUMFOU=COMMANDE.NUMFOU
WHERE COMMANDE.NUMFOU !=0;

------nombre de commandes fournisseurs passées, et le nombre de fournisseur concernés.

SELECT  COUNT(COMMANDE.NUMCOM) AS nbre_commande,count (DISTINCT(NUMFOU)) AS nbre_fournisseur
FROM PAPYRUS.COMMANDE;



------les produits ayant un stock inférieur ou égal au stock d'alerte
------et dont la quantité annuelle est inférieure à 1000.
SELECT *  FROM PAPYRUS.PRODUIT 
WHERE STKPHY <= STKALE AND  QTEANN <1000;

----Quels sont les fournisseurs situés dans les départements 75 78 92 77
SELECT POSFOU ,NOMFOU 
FROM PAPYRUS.FOURNISSEUR
WHERE POSFOU LIKE '75%' OR POSFOU LIKE '78%' 
OR POSFOU LIKE '92%' OR POSFOU LIKE '77%'
ORDER BY POSFOU;


----------------les commandes passées au mois de mars et avril---------
SELECT COMMANDE.NUMCOM ,COMMANDE.DATECOM 
FROM PAPYRUS.COMMANDE
WHERE DATECOM BETWEEN '01/03/10' AND '30/04/10';

----------------les commandes du jour qui ont des observations particulières
SELECT * FROM PAPYRUS.COMMANDE
WHERE OBSCOM LIKE '%';

--Lister le total de chaque commande par total décroissant
--Affichage : numéro de commande et total.

SELECT COMMANDE.NUMCOM ,SUM(LIGCOM.QTECDE * LIGCOM.PRIUNI) AS TOTALE 
FROM COMMANDE INNER JOIN LIGCOM ON COMMANDE.NUMCOM=LIGCOM.NUMCOM
group by COMMANDE.NUMCOM
ORDER BY SUM(LIGCOM.QTECDE * LIGCOM.PRIUNI)DESC ;

--les commandes dont le total est supérieur à 10 000€ ; 
--vous exclurez dans le calcul du total les articles commandés en quantité supérieure ou égale à 1000.
--Affichage : numéro de commande et total.

SELECT COMMANDE.NUMCOM ,SUM(LIGCOM.QTECDE * LIGCOM.PRIUNI) AS TOTALE 
FROM COMMANDE INNER JOIN LIGCOM ON COMMANDE.NUMCOM=LIGCOM.NUMCOM
WHERE (LIGCOM.QTECDE * LIGCOM.PRIUNI)>10000
AND LIGCOM.QTECDE<1000
group by COMMANDE.NUMCOM
ORDER BY SUM(LIGCOM.QTECDE * LIGCOM.PRIUNI)DESC ;

--Lister les commandes par nom fournisseur 
--Affichage : nom du fournisseur, numéro de commande et date de la commande

SELECT FOURNISSEUR.NOMFOU , COMMANDE.NUMCOM , COMMANDE.DATECOM
FROM FOURNISSEUR INNER JOIN COMMANDE ON COMMANDE.NUMFOU=FOURNISSEUR.NUMFOU;

commit;

--11. Sortir les produits des commandes ayant le mot "urgent'
--en observation ? Affichage : numéro de commande, nom du fournisseur, 
--libellé du produit et sous total = quantité commandée * Prix unitaire.

SELECT COMMANDE.NUMCOM,FOURNISSEUR.NOMFOU,PRODUIT.LIBART,
(LIGCOM.QTECDE * LIGCOM.PRIUNI) AS SOUS_TOTAL
FROM FOURNISSEUR
INNER JOIN COMMANDE ON  FOURNISSEUR.NUMFOU=COMMANDE.NUMFOU
INNER JOIN LIGCOM ON COMMANDE.NUMCOM=LIGCOM.NUMCOM 
INNER JOIN PRODUIT ON LIGCOM.CODART=PRODUIT.CODART
WHERE COMMANDE.OBSCOM LIKE '%urgent%';


--12. Coder de 3 manières différentes
--la requête suivante : Lister le nom
--des fournisseurs susceptibles de livrer au moins un article.
--


----------1 methode
SELECT DISTINCT NOMFOU FROM 
FOURNISSEUR INNER JOIN COMMANDE 
ON FOURNISSEUR.NUMFOU=COMMANDE.NUMFOU;

---------2 METHODE 


-- 13. Coder de 2 manières différentes la requête suivante :
---Lister les commandes (Numéro et date) dont le fournisseur est celui de la commande 70210.

SELECT NUMCOM , DATECOM
FROM COMMANDE
WHERE NUMFOU =
(SELECT NUMFOU FROM COMMANDE WHERE COMMANDE.NUMCOM =261);

-------2 EME METHODE 
SELECT COMMANDE.NUMFOU, COMMANDE.DATECOM
FROM COMMANDE INNER JOIN FOURNISSEUR
ON COMMANDE.NUMFOU=FOURNISSEUR.NUMFOU
WHERE FOURNISSEUR.NUMFOU =
(SELECT NUMFOU FROM COMMANDE WHERE COMMANDE.NUMCOM =261);

--Coder de 2 manières différentes la requête suivante :
--Dans les articles susceptibles d’être vendus, lister les articles moins chers
--(basés sur Prix) que le moins cher des rubans (article dont le premier caractère commence par R).
--Affichage : libellé de l’article et prix de l’article


  







