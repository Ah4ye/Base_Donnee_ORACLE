------------------ IMPLEMENTE TYPE_CONTENU, ACTEUR et REALISATEUR EN FONCTION de DATANETFLOUZE ------------------
INSERT INTO TYPE_CONTENU (nom)
SELECT DISTINCT
    CASE 
        WHEN TYPE = 'TV Show' AND (LOWER(LISTED_IN) LIKE '%kids%' OR LOWER(LISTED_IN) LIKE '%kids'' tv%' OR LOWER(LISTED_IN) LIKE '%teen%' ) THEN 'Jeunesse'
        WHEN TYPE = 'TV Show' THEN 'Serie'
        WHEN TYPE = 'Movie' AND ((LISTED_IN) LIKE '%Children%' OR LOWER(LISTED_IN) LIKE '%Children%' OR LOWER(LISTED_IN) LIKE '%Family%' ) THEN 'Jeunesse'
        WHEN TYPE = 'Movie' AND ( (LISTED_IN) LIKE '%Stand-Up Comedy%'OR LOWER(LISTED_IN) LIKE '%Stand-Up Comedy%' OR LOWER(LISTED_IN) LIKE '%Stand-Up Comedy & Talk Shows%' ) THEN 'Divertissement'
        WHEN TYPE = 'Movie' THEN 'Cinema'
    END AS nom
FROM DATANETFLOUZE
;

INSERT INTO Acteur (prenom, nom)
SELECT DISTINCT SUBSTR(VAL, 1, INSTR(VAL, ' ')-1) AS nom, SUBSTR(VAL, INSTR(VAL, ' ')+1) AS prenom
FROM V_CAST
;

INSERT INTO Realisateur (prenom, nom)
SELECT DISTINCT SUBSTR(VAL, 1, INSTR(VAL, ' ')-1) AS nom, SUBSTR(VAL, INSTR(VAL, ' ')+1) AS prenom
FROM V_DIRECTOR
;
-------------------------------------  FIN  --------------------------------



------------------ IMPLEMENTE CONTENU EN FONCTION de DATANETFLOUZE ------------------
Insert INTO CONTENU (contenuid,type , titre ,description , theme , lienbandeannonce, note , paysprod, anneeprod , duree , classification)
Select DISTINCT
    SUBSTR(SHOW_ID, 2) as contenuid,
  CASE 
        WHEN TYPE = 'TV Show' AND (LOWER(LISTED_IN) LIKE '%kids%' OR LOWER(LISTED_IN) LIKE '%kids'' tv%' OR LOWER(LISTED_IN) LIKE '%teen%' ) THEN 'Jeunesse'
        WHEN TYPE = 'TV Show' THEN 'Serie'
        WHEN TYPE = 'Movie' AND ((LISTED_IN) LIKE '%Children%' OR LOWER(LISTED_IN) LIKE '%Children%' OR LOWER(LISTED_IN) LIKE '%Family%' ) THEN 'Jeunesse'
        WHEN TYPE = 'Movie' AND ( (LISTED_IN) LIKE '%Stand-Up Comedy%'OR LOWER(LISTED_IN) LIKE '%Stand-Up Comedy%' OR LOWER(LISTED_IN) LIKE '%Stand-Up Comedy & Talk Shows%' ) THEN 'Divertissement'
        WHEN TYPE = 'Movie' THEN 'Cinema'
    END AS type
    ,
    TITLE , DESCRIPTION ,LISTED_IN, null , null , COUNTRY, to_date( '02/01' || RELEASE_YEAR) , DURATION 
    ,
     CASE 
        WHEN RATING  LIKE '%NR%' OR RATING  LIKE '%UR%' THEN 'Tous publics'
        WHEN RATING  LIKE '%TV-MA%' OR RATING  LIKE '%R%' OR RATING  LIKE '%NC-17%' THEN '-18'
        WHEN RATING  LIKE '%TV-14%' OR RATING  LIKE '%PG-13%' THEN '-16'
        WHEN RATING  LIKE '%TV-PG%'  THEN '-12'
        WHEN RATING  LIKE '%TV-Y7%' OR RATING  LIKE '%PG%' OR RATING  LIKE '%TV-Y7-FV%' THEN '-10'
        WHEN RATING  LIKE '%TV-G%' OR RATING  LIKE '%TV-Y%' OR RATING  LIKE '%G%' THEN 'Tous publics'
    END AS classification
FROM DATANETFLOUZE
;


-------------------------------------  FIN  --------------------------------


------------------ IMPLEMENTE DES CONTENUE EN FONCTION de Contenue ------------------
Insert into Divertissement ( divertissementid ) Select Distinct contenuid FROM Contenu WHERE type = 'Divertissement' ;
Insert into Cinema ( cinemaid ) Select Distinct contenuid FROM Contenu WHERE type = 'Cinema' ;
Insert into Jeunesse ( jeunesseid ) Select Distinct contenuid FROM Contenu WHERE type = 'Jeunesse' ;
INSERT INTO Serie (serieid, nbsaison) SELECT DISTINCT contenuid, SUBSTR(duree, 1, 1)FROM Contenu WHERE type = 'Serie';

DECLARE
  i INTEGER := 1;
    v_serieid INTEGER := 1;
   v_nbsaison INTEGER;
BEGIN
  FOR c IN (SELECT DISTINCT serieid, nbsaison FROM Serie) LOOP
    v_serieid := c.serieid;
    v_nbsaison := c.nbsaison;
    FOR i IN 1..v_nbsaison LOOP
      INSERT INTO Saison (serieid, saisonid, NBEP) VALUES (v_serieid, i, 24);
    END LOOP;
  END LOOP;
  COMMIT;
END;
-------------------------------------  FIN  --------------------------------


----------------------- Remplissage Table Acting des Acteur --------------------

INSERT INTO Realise (contenueid, realisateurid)
SELECT DISTINCT SUBSTR(v.SHOW_ID, 2), r.realisateurid
FROM (
    SELECT SHOW_ID, VAL
    FROM V_DIRECTOR
) v
JOIN (
    SELECT realisateurid, nom, prenom
    FROM Realisateur
) r ON v.VAL = r.prenom || ' ' || r.nom
JOIN Contenu c ON SUBSTR(v.SHOW_ID, 2) = c.contenuid
WHERE c.type = 'Cinema';


-- Insert les realisateurs dans une saison Aleatoire compris entre 1 le nombre de saison qui est dans le champs duree de contenue
INSERT INTO Realise_saison (serieid, saisonid ,realisateurid)
SELECT DISTINCT  SUBSTR(v.SHOW_ID, 2), FLOOR(DBMS_RANDOM.VALUE(1,SUBSTR(c.duree, 1, 1))) ,r.realisateurid
FROM (
    SELECT SHOW_ID, VAL
    FROM V_DIRECTOR
) v
JOIN (
    SELECT realisateurid, nom, prenom
    FROM Realisateur
) r ON v.VAL = r.prenom || ' ' || r.nom
JOIN Contenu c ON SUBSTR(v.SHOW_ID, 2) = c.contenuid
WHERE c.type = 'Serie';
-------------------------------- FIN -------------------------------------------

----------------------- Remplissage Table Acting des Acteur --------------------
INSERT INTO Joue_Film (jouefilmid, acteurid)
SELECT DISTINCT SUBSTR(v.SHOW_ID, 2), r.acteurid
FROM (
    SELECT SHOW_ID, VAL
    FROM V_CAST
) v
JOIN (
    SELECT acteurid, nom, prenom
    FROM Acteur
) r ON v.VAL = r.prenom || ' ' || r.nom
JOIN Contenu c ON SUBSTR(v.SHOW_ID, 2) = c.contenuid
WHERE c.type = 'Cinema';

-- Insert les acteurs dans une saison Aleatoire compris entre 1 le nombre de saison qui est dans le champs duree de contenue
INSERT INTO Joue_Serie (joueserieid, jouesaisonid ,acteurid)
SELECT DISTINCT  SUBSTR(v.SHOW_ID, 2), FLOOR(DBMS_RANDOM.VALUE(1,SUBSTR(c.duree, 1, 1))) ,r.acteurid
FROM (
    SELECT SHOW_ID, VAL
    FROM V_CAST
) v
JOIN (
    SELECT acteurid, nom, prenom
    FROM acteur
) r ON v.VAL = r.prenom || ' ' || r.nom
JOIN Contenu c ON SUBSTR(v.SHOW_ID, 2) = c.contenuid
WHERE c.type = 'Serie';
-------------------------------- FIN -------------------------------------------