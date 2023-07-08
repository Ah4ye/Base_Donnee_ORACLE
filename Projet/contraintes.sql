ALTER TABLE Contenu ADD CONSTRAINT CK_LienBandeAnnonce CHECK (lienBandeAnnonce LIKE 'http%');

ALTER TABLE Client ADD CONSTRAINT CK_Password CHECK (
    LENGTH(mdp) >= 8 AND
    REGEXP_LIKE(mdp, '[a-zA-Z]') AND
    REGEXP_LIKE(mdp, '[0-9]') AND
    REGEXP_LIKE(mdp, '[A-Z]') AND
    REGEXP_LIKE(mdp, '[^a-zA-Z0-9]')
);

CREATE OR REPLACE TRIGGER tr_location_abonner
BEFORE INSERT OR UPDATE ON Location_Abonner
FOR EACH ROW
DECLARE
    v_max_locations INTEGER;
BEGIN
    SELECT nombreMax INTO v_max_locations
    FROM Abonnement
    WHERE abonnementid = (
        SELECT abonnementid
        FROM Abonner
        WHERE abonnerid = :new.abonnerid
    );
    
    IF :new.evaluation_abo > v_max_locations THEN
        RAISE_APPLICATION_ERROR(-20000, 'Le nombre de locations dépasse la limite autorisée pour cet abonnement.');
    END IF;
END;
/


ALTER TABLE Abonner ADD CONSTRAINT UQ_Client_Abonnement UNIQUE (clientid);



CREATE OR REPLACE TRIGGER TRG_VERIFIER_DATE_FIN
BEFORE INSERT OR UPDATE ON Contenue_Louer
FOR EACH ROW
DECLARE
    datefin_location DATE;
BEGIN
    SELECT date_fin INTO datefin_location FROM Louer WHERE louerid = :NEW.louerid;
    IF datefin_location < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Impossible d''accéder à ce contenu car la date de location est dépassée.');
    ELSIF datefin_location = SYSDATE AND INSERTING THEN
        DELETE FROM Louer WHERE louerid = :NEW.louerid;
    END IF;
END;
/




