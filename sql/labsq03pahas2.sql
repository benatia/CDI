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

--------code des fournisseurs pour lesquels des commandes ont �t� pass�es
SELECT NUMFOU FROM COMMANDE
WHERE NUMCOM !=0;

----------2 em methode 
select FOURNISSEUR.NUMFOU
FROM PAPYRUS.FOURNISSEUR INNER JOIN PAPYRUS.COMMANDE ON 
FOURNISSEUR.NUMFOU=COMMANDE.NUMFOU
WHERE COMMANDE.NUMFOU !=0;

------nombre de commandes fournisseurs pass�es, et le nombre de fournisseur concern�s.

SELECT  COUNT(COMMANDE.NUMCOM) AS nbre_commande,count (DISTINCT(NUMFOU)) AS nbre_fournisseur
FROM PAPYRUS.COMMANDE;



------les produits ayant un stock inf�rieur ou �gal au stock d'alerte
------et dont la quantit� annuelle est inf�rieure � 1000.
SELECT *  FROM PAPYRUS.PRODUIT 
WHERE STKPHY <= STKALE AND  QTEANN <1000;

----Quels sont les fournisseurs situ�s dans les d�partements 75 78 92 77
SELECT POSFOU ,NOMFOU 
FROM PAPYRUS.FOURNISSEUR
WHERE POSFOU LIKE '75%' OR POSFOU LIKE '78%' 
OR POSFOU LIKE '92%' OR POSFOU LIKE '77%'
ORDER BY POSFOU;


----------------les commandes pass�es au mois de mars et avril---------
SELECT COMMANDE.NUMCOM ,COMMANDE.DATECOM 
FROM PAPYRUS.COMMANDE
WHERE DATECOM BETWEEN '01/03/10' AND '30/04/10';

----------------les commandes du jour qui ont des observations particuli�res
SELECT * FROM PAPYRUS.COMMANDE
WHERE OBSCOM LIKE '%';

--Lister le total de chaque commande par total d�croissant
--Affichage : num�ro de commande et total.

SELECT COMMANDE.NUMCOM ,SUM(LIGCOM.QTECDE * LIGCOM.PRIUNI) AS TOTALE 
FROM COMMANDE INNER JOIN LIGCOM ON COMMANDE.NUMCOM=LIGCOM.NUMCOM
group by COMMANDE.NUMCOM
ORDER BY SUM(LIGCOM.QTECDE * LIGCOM.PRIUNI)DESC ;

--les commandes dont le total est sup�rieur � 10 000� ; 
--vous exclurez dans le calcul du total les articles command�s en quantit� sup�rieure ou �gale � 1000.
--Affichage : num�ro de commande et total.

SELECT COMMANDE.NUMCOM ,SUM(LIGCOM.QTECDE * LIGCOM.PRIUNI) AS TOTALE 
FROM COMMANDE INNER JOIN LIGCOM ON COMMANDE.NUMCOM=LIGCOM.NUMCOM
WHERE (LIGCOM.QTECDE * LIGCOM.PRIUNI)>10000
AND LIGCOM.QTECDE<1000
group by COMMANDE.NUMCOM
ORDER BY SUM(LIGCOM.QTECDE * LIGCOM.PRIUNI)DESC ;

--Lister les commandes par nom fournisseur 
--Affichage : nom du fournisseur, num�ro de commande et date de la commande

SELECT FOURNISSEUR.NOMFOU , COMMANDE.NUMCOM , COMMANDE.DATECOM
FROM FOURNISSEUR INNER JOIN COMMANDE ON COMMANDE.NUMFOU=FOURNISSEUR.NUMFOU;

commit;

--11. Sortir les produits des commandes ayant le mot "urgent'
--en observation ? Affichage : num�ro de commande, nom du fournisseur, 
--libell� du produit et sous total = quantit� command�e * Prix unitaire.

SELECT COMMANDE.NUMCOM,FOURNISSEUR.NOMFOU,PRODUIT.LIBART,
(LIGCOM.QTECDE * LIGCOM.PRIUNI) AS SOUS_TOTAL
FROM FOURNISSEUR
INNER JOIN COMMANDE ON  FOURNISSEUR.NUMFOU=COMMANDE.NUMFOU
INNER JOIN LIGCOM ON COMMANDE.NUMCOM=LIGCOM.NUMCOM 
INNER JOIN PRODUIT ON LIGCOM.CODART=PRODUIT.CODART
WHERE COMMANDE.OBSCOM LIKE '%urgent%';


--12. Coder de 3 mani�res diff�rentes
--la requ�te suivante : Lister le nom
--des fournisseurs susceptibles de livrer au moins un article.
--


----------1 methode
SELECT DISTINCT NOMFOU FROM 
FOURNISSEUR INNER JOIN COMMANDE 
ON FOURNISSEUR.NUMFOU=COMMANDE.NUMFOU;

---------2 METHODE 


-- 13. Coder de 2 mani�res diff�rentes la requ�te suivante :
---Lister les commandes (Num�ro et date) dont le fournisseur est celui de la commande 70210.

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

--Coder de 2 mani�res diff�rentes la requ�te suivante :
--Dans les articles susceptibles d��tre vendus, lister les articles moins chers
--(bas�s sur Prix) que le moins cher des rubans (article dont le premier caract�re commence par R).
--Affichage : libell� de l�article et prix de l�article


  







