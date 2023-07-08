SELECT titre
FROM Contenu
WHERE theme LIKE '%Anime%' OR theme LIKE '%Fantasy%'
ORDER BY titre ASC;

-- Pas Test --
SELECT c.titre, c.theme
FROM client cl
JOIN location l ON cl.clientid = l.clientid
JOIN contenu_location clt ON l.locationid = clt.locationid
JOIN contenu c ON clt.contenuid = c.contenuid
WHERE cl.nom = 'Dupont'
AND l.date_debut BETWEEN TO_DATE('01-JAN-2022', 'DD-MON-YYYY') AND TO_DATE('31-MAR-2022', 'DD-MON-YYYY') ;

SELECT a.id_abonne, 
       COUNT(e.id_contenu) AS nb_contenus_empruntes, 
       (a.nb_emprunts_max - COUNT(e.id_contenu)) AS nb_emprunts_restants
FROM abonnes a
LEFT JOIN emprunts e ON a.id_abonne = e.id_abonne
GROUP BY a.id_abonne;
------------------

SELECT a.nom, a.prenom, COUNT(*) as nb_films
FROM Acteur a
JOIN Joue_Film j ON a.acteurid = j.acteurid
JOIN Contenu c ON j.jouefilmid = c.contenuid
JOIN Realise r ON c.contenuid = r.contenueid
JOIN Realisateur re ON r.realisateurid = re.realisateurid
WHERE re.nom LIKE '%Fincher%' AND re.prenom LIKE '%David%'
GROUP BY a.nom, a.prenom;

SELECT r.nom, r.prenom, COUNT(*) AS nb_contenus_realises
FROM Realisateur r
JOIN Realise rs ON r.realisateurid = rs.realisateurid
GROUP BY r.nom, r.prenom
HAVING COUNT(*) = (
  SELECT MAX(nb_contenus_realises)
  FROM (
    SELECT COUNT(*) AS nb_contenus_realises
    FROM Realise
    GROUP BY realisateurid
  )
);



SELECT acteur.nom, COUNT(film.id) AS nb_films_joues
FROM acteur
JOIN casting ON acteur.id = casting.acteur_id
JOIN film ON film.id = casting.film_id
GROUP BY acteur.id
HAVING COUNT(film.id) > 5;

SELECT contenuid, COUNT(*) as nombre_de_locations
FROM contenu_location
GROUP BY contenuid;

SELECT r.nom, COUNT(*) AS nb_contenus
FROM Realise r
JOIN Contenu c ON r.contenuid = c.contenuid
JOIN (
  SELECT ci.contenuid, ci.classification
  FROM Cinema ci
  WHERE ci.classification IN ('-16', '-18')
  UNION ALL
  SELECT d.divertissementid, d.classification
  FROM Divertissement d
  WHERE d.classification IN ('-16', '-18')
  UNION ALL
  SELECT s.contenuid, s.classification
  FROM Serie s
  WHERE s.classification IN ('-16', '-18')
) c16 ON c.contenuid = c16.contenuid
GROUP BY r.realisateurid, r.nom
HAVING COUNT(*) > 2
ORDER BY nb_contenus DESC;


SELECT Nom
FROM Client
WHERE Ville = (SELECT Ville FROM Client WHERE nom = 'Dupont');

SELECT COUNT(DISTINCT realisateurid)
FROM Realise
WHERE realisateurid NOT IN (
    SELECT DISTINCT R.realisateurid
    FROM Realise R
    JOIN Cinema F ON R.contenuid = F.contenuid
    WHERE F.theme = 'Comedie'
)


SELECT id , nom
FROM Client
WHERE clientid NOT IN (
    SELECT DISTINCT clientid
    FROM Louer
);

SELECT j.contenueid
FROM Jeunesse j
INNER JOIN Contenu c ON j.contenueid = c.contenueid
WHERE c.paysProd = 'France'
AND j.contenueid NOT IN (SELECT contenueid FROM Contenu_Location);

SELECT c.id
FROM CLient cl, Client_Abo ca, Abonner a, abonnenement ab, Location_Abonner la, contenu c
WHERE cl.clientid = ca.clientid 
AND a.abonnerid = ca.abonnerid
AND a.type = ab.abonnenementid
and a.abonnerid = la.abonnerid
and la.contenueid = c.contenu id
and ab.nom = 'VIP'
and c.type = 'Divertissmeent'
and la.date >= ADD_MONTHS(TRUNC(SYSDATE), -3)
;

SELECT realisateurid, COUNT(*) AS nb_realisations
FROM Realise
GROUP BY realisateurid
HAVING COUNT(*) > (SELECT AVG(nb) FROM (SELECT COUNT(*) AS nb FROM Realise GROUP BY realisateurid))
;

SELECT DISTINCT realisateurid
FROM Realise
INNER JOIN Contenu ON Realise.contenueid = Contenu.contenueid
WHERE Contenu.theme IN ('Sci-Fi & Fantasy', 'TV Action & Adventure')
GROUP BY realisateurid
HAVING COUNT(DISTINCT Contenu.theme) = 2

SELECT r.realisateurid, COUNT(*) AS nb_films_realises
FROM Realise r
JOIN Contenu c ON r.contenueid = c.contenueid
LEFT JOIN Contenu_Location cl ON c.contenueid = cl.contenueid
LEFT JOIN Location_Abonner la ON cl.locationid = la.locationid
GROUP BY r.realisateurid
ORDER BY nb_films_realises DESC;

SELECT c.titre
FROM Contenu c
WHERE c.type = 'cinéma' 
AND NOT EXISTS (
  SELECT 1 
  FROM Contenu c2 
  JOIN Contenu_Motcle cm ON c2.contenueid = cm.contenueid 
  JOIN Motcle m ON cm.motcleid = m.motcleid 
  WHERE c2.titre = 'The Founder' 
  AND cm.contenueid = c.contenueid
);

SELECT DISTINCT c1.titre
FROM Contenu c1
JOIN Contenu c2 ON c1.contenuid <> c2.contenuid 
AND c1.type = 'Cinema'
AND c2.type = 'Cinema'
AND EXISTS (
    SELECT 1 FROM Theme t1 JOIN Theme t2 
    ON t1.contenuid = c1.contenuid 
    AND t2.contenuid = c2.contenuid
    WHERE (t1.theme = t2.theme) 
    AND c2.titre LIKE '%The Founder%'
);

SELECT Titre
FROM Contenu
WHERE theme IN (
    SELECT theme
    FROM Contenu
    WHERE titre LIKE '%The Founder%'
)
AND type = 'Cinema'
AND titre NOT LIKE '%The Founder%';


SELECT c2.Titre
FROM Contenu c1, Contenu c2
WHERE c1.titre LIKE '%The Founder%' 
AND c1.contenuid != c2.contenuid 
AND NOT EXISTS (
  SELECT *
  FROM (SELECT DISTINCT theme FROM Contenu WHERE contenuid = c1.contenuid) t1
  FULL OUTER JOIN (SELECT DISTINCT theme FROM Contenu WHERE contenuid = c2.contenuid) t2 
  ON t1 = t2
  WHERE t1 IS NULL OR t2 IS NULL
);



