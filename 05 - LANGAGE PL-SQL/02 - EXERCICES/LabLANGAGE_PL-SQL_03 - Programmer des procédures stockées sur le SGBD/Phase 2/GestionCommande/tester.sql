BEGIN
  gest_com.ajouter_produit(2010, 'camshaft', 245.00);
  gest_com.ajouter_produit(2011, 'connecting rod', 122.50);
  gest_com.ajouter_produit(2012, 'crankshaft', 388.25);
  gest_com.ajouter_produit(2013, 'cylinder head', 201.75);
  gest_com.ajouter_produit(2014, 'cylinder sleeve', 73.50);
  gest_com.ajouter_produit(2015, 'engine bearning', 43.85);
  gest_com.ajouter_produit(2016, 'flywheel', 155.00);
  gest_com.ajouter_produit(2017, 'freeze plug', 17.95);
  gest_com.ajouter_produit(2018, 'head gasket', 36.75);
  gest_com.ajouter_produit(2019, 'lifter', 96.25);
  gest_com.ajouter_produit(2020, 'oil pump', 207.95);
  gest_com.ajouter_produit(2021, 'piston', 137.75);
  gest_com.ajouter_produit(2022, 'piston ring', 21.35);
  gest_com.ajouter_produit(2023, 'pushrod', 110.00);
  gest_com.ajouter_produit(2024, 'rocker arm', 186.50);
  gest_com.ajouter_produit(2025, 'valve', 68.50);
  gest_com.ajouter_produit(2026, 'valve spring', 13.25);
  gest_com.ajouter_produit(2027, 'water pump', 144.50);
  COMMIT;
END;

BEGIN
  gest_com.ajouter_client(101, 'Martin', 'Jacques','112', 'Metz', 'Toulouse', 'France','0651875653');
  gest_com.ajouter_client(102, 'Marley', 'Bob','12', 'Metz', 'Toulouse', 'France','0651875653');
  gest_com.ajouter_client(103, 'Mc Ferrin', 'Boby','2', 'Metz', 'Paris', 'France','0651875653');
  gest_com.ajouter_client(104, 'No one', 'No Body','100', 'noland', 'nowhere', 'somewhere','000000000');
  COMMIT;
END;

BEGIN
  gest_com.entrer_commande(30501, 103, '2012-09-14', '2012-09-21');
  gest_com.ajouter_ligne(01, 30501, 2011, 5, 0.02);
  gest_com.ajouter_ligne(02, 30501, 2018, 25, 0.10);
  gest_com.ajouter_ligne(03, 30501, 2026, 10, 0.05);

  gest_com.entrer_commande(30502, 102, '2012-09-15', '2012-09-22');
  gest_com.ajouter_ligne(01, 30502, 2013, 1, 0.00);
  gest_com.ajouter_ligne(02, 30502, 2014, 1, 0.00);

  gest_com.entrer_commande(30503, 104, '2012-09-15', '2012-09-23');
  gest_com.ajouter_ligne(01, 30503, 2020, 5, 0.02);
  gest_com.ajouter_ligne(02, 30503, 2027, 5, 0.02);
  gest_com.ajouter_ligne(03, 30503, 2021, 15, 0.05);
  gest_com.ajouter_ligne(04, 30503, 2022, 15, 0.05);

  gest_com.entrer_commande(30504, 101, '2012-09-16', '2012-09-23');
  gest_com.ajouter_ligne(01, 30504, 2025, 20, 0.10);
  gest_com.ajouter_ligne(02, 30504, 2026, 20, 0.10);
  COMMIT;
END;

SET SERVEROUTPUT ON
CALL dbms_java.set_output(2000);

CALL gest_com.calculer_total();