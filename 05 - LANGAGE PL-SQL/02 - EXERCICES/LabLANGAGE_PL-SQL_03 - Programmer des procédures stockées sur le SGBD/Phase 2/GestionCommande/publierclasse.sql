CREATE OR REPLACE PACKAGE gest_com AS 

PROCEDURE ajouter_client (num_cli NUMBER, nom VARCHAR2,prenom VARCHAR2, 
nim_adr VARCHAR2, rue CHAR, ville VARCHAR2,pays VARCHAR2,num_tel VARCHAR2)
AS LANGUAGE JAVA
NAME 'GestionCommande.ajouterClient (int, java.lang.String,java.lang.String,
java.lang.String,java.lang.String,java.lang.String, java.lang.String,java.lang.String)';

PROCEDURE ajouter_produit (num_pro NUMBER, description VARCHAR2,prix NUMBER)
AS LANGUAGE JAVA
NAME 'GestionCommande.ajouterProduit(int, java.lang.String, float)';

PROCEDURE entrer_commande (num_com NUMBER, nim_cli NUMBER,date_com VARCHAR2, date_liv VARCHAR2)
AS LANGUAGE JAVA
NAME 'GestionCommande.entrerCommande (int,int,java.lang.String,java.lang.String)';

PROCEDURE ajouter_ligne (num_ligne NUMBER, num_com NUMBER,num_pro NUMBER, quantite NUMBER, remise NUMBER)
AS LANGUAGE JAVA
NAME 'GestionCommande.ajouterLigne (int,int,int,int,float)';

PROCEDURE calculer_total
AS LANGUAGE JAVA
NAME 'GestionCommande.calculerTotal()';

PROCEDURE delete_com(num_com NUMBER)
AS LANGUAGE JAVA
NAME 'GestionCommande.supprimerCommande(int)';

END;