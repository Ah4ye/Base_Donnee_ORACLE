--Creation des tables--

CREATE TABLE Interprete (
interpreteid Integer,
nom varchar2(100),
prenom varchar2(100),
constraint PK_interprete PRIMARY KEY (interpreteid)
);

CREATE SEQUENCE SEQ_INTERPRETE;

CREATE OR REPLACE TRIGGER trig_INTERPRETE
before insert on INTERPRETE for each row
    begin 
        select SEQ_INTERPRETE.NEXTVAL INTO :new.interpreteid from 
        DUAL;
end;
/


CREATE TABLE Realisateur (
realisateurid Integer,
nom varchar2(100),
prenom varchar2(100),
constraint PK_realisateur PRIMARY KEY (realisateurid)
);

CREATE SEQUENCE SEQ_REALISATEUR;

CREATE OR REPLACE TRIGGER trig_REALISATEUR
before insert on REALISATEUR for each row
    begin 
        select SEQ_REALISATEUR.NEXTVAL INTO :new.realisateurid from 
        DUAL;
end;
/


CREATE TABLE Compositeur(
compositeurid Integer,
nom varchar2(100),
prenom varchar2(100),
constraint PK_compositeur PRIMARY KEY (compositeurid)
);

CREATE SEQUENCE SEQ_COMPOSITEUR;

CREATE OR REPLACE TRIGGER trig_COMPOSITEUR
before insert on COMPOSITEUR for each row
    begin 
        select SEQ_COMPOSITEUR.NEXTVAL INTO :new.compositeurid from 
        DUAL;
end;
/

CREATE TABLE Acteur (
acteurid Integer,
nom varchar2(100),
prenom varchar2(100),
constraint PK_acteur PRIMARY KEY (acteurid)
);

CREATE SEQUENCE SEQ_ACTEUR;

CREATE OR REPLACE TRIGGER trig_ACTEUR
before insert on ACTEUR for each row
    begin 
        select SEQ_ACTEUR.NEXTVAL INTO :new.acteurid from 
        DUAL;
end;
/

CREATE TABLE Scenariste (
scenaristeid Integer,
nom varchar2(100),
prenom varchar2(100),
constraint PK_scenarite PRIMARY KEY (scenaristeid)
);

CREATE SEQUENCE SEQ_SCENARISTE;

CREATE OR REPLACE TRIGGER trig_SCENARISTE
before insert on SCENARISTE for each row
    begin 
        select SEQ_SCENARISTE.NEXTVAL INTO :new.scenaristeid from 
        DUAL;
end;
/

CREATE TABLE MetteurEnScene (
metteurensceneid Integer,
nom varchar2(100),
prenom varchar2(100),
constraint PK_metteurenscene PRIMARY KEY (metteurensceneid)
);

---------------------------------------------------------------------------------------------------------------------------------

DROP TABLE Interpreter ;
CREATE TABLE Interpreter (
interpreteid Integer,
divertissementid INTEGER,
constraint PK_interpreter PRIMARY KEY (interpreteid, divertissementid)
);

DROp TABLE Realise ;
CREATE TABLE Realise (
contenueid INTEGER,
realisateurid INTEGER,
constraint PK_realise PRIMARY KEY (contenueid, realisateurid)
);

DROp TABLE Realise_saison ;
CREATE TABLE Realise_saison (
saisonid INTEGER,
serieid INTEGER,
realisateurid INTEGER,
constraint PK_realise_saison PRIMARY KEY (saisonid, serieid,realisateurid)
);

CREATE TABLE Compose (
jeunesseid Integer,
compositeurid INTEGER,
constraint PK_compose PRIMARY KEY (jeunesseid, compositeurid)
);


DROP TABLE Joue_Film ;
CREATE TABLE Joue_Film (
jouefilmid INTEGER,
acteurid INTEGER,
CONSTRAINT PK_joue_film PRIMARY KEY (jouefilmid, acteurid)
);


DROP TABLE Joue_Serie ;
CREATE TABLE Joue_Serie (
joueserieid INTEGER,
jouesaisonid INTEGER,
acteurid INTEGER,
CONSTRAINT PK_joue_saison PRIMARY KEY (jouesaisonid, joueserieid,acteurid)
);



DROP TABLE Scenarise_Divertissement ;
CREATE TABLE Scenarise_Divertissement (
scenarisedivid Integer,
scenaristeid INTEGER,
constraint PK_scenarise_div PRIMARY KEY (scenarisedivid, scenaristeid)
);

DROP TABLE Scenarise_Cinema ;
CREATE TABLE Scenarise_Cinema (
scenarisecinid Integer,
scenaristeid INTEGER,
constraint PK_scenarise_cin PRIMARY KEY (scenarisecinid, scenaristeid)
);


DROP TABLE Scenarise_Jeunesse ;
CREATE TABLE Scenarise_Jeunesse (
scenarisejeuid Integer,
scenaristeid INTEGER,
constraint PK_scenarise_jeu PRIMARY KEY (scenarisejeuid, scenaristeid)
);


DROP TABLE Met_Scene ;
CREATE TABLE Met_Scene (
met_sceneid Integer,
metteurensceneid INTEGER,
constraint PK_met_scene PRIMARY KEY (met_sceneid, metteurensceneid)
);

------------------------------------------------ CONTENUE -----------------------------------------------------------------
DROP TABLE Contenu ;
CREATE TABLE Contenu (
    contenuid INTEGER,
    type VARCHAR2(300),
    titre VARCHAR2(300),
    description VARCHAR2(200),
    theme VARCHAR2(100),
    lienBandeAnnonce VARCHAR2(50),
    note INTEGER, 
    paysProd VARCHAR2(200),
    anneeProd Date,
    duree VARCHAR2(70),
    classification VARCHAR2(20),
    CONSTRAINT PK_Contenu PRIMARY KEY (contenuid),
    CONSTRAINT CK_Note_05 CHECK (note BETWEEN 0 AND 5),
    
);



DROP SEQUENCE SEQ_CONTENU;
CREATE SEQUENCE SEQ_CONTENU;

CREATE OR REPLACE TRIGGER trig_CONTENU
before insert on Contenu for each row
    begin 
        select SEQ_Contenu.NEXTVAL INTO :new.contenuid from 
        DUAL;
end;
/

CREATE OR REPLACE TRIGGER trigger_prod
    BEFORE INSERT OR UPDATE ON contenu
    FOR EACH ROW 
BEGIN 
    IF :new.anneeProd < TO_DATE('1900/01/01', 'YYYY/MM/DD') OR :new.anneeProd > SYSDATE THEN 
        RAISE_APPLICATION_ERROR(-20000, 'Date incorrecte');
    END IF;
END;
/

CREATE TABLE TYPE_CONTENU ( 
nom varchar2(30),
Constraint PK_Type_Contenu PRIMARY KEY (nom)
);


---------------------------- TABLE TYPE de CONTENUE ------------------------------------

DROP TABLE Divertissement;
CREATE TABLE Divertissement (
divertissementid INTEGER,
constraint PK_Divertissement PRIMARY KEY (divertissementid)
);

CREATE SEQUENCE SEQ_DIVERTISSEMENT;

CREATE OR REPLACE TRIGGER trig_DIVERTISSEMENT
before insert on DIVERTISSEMENT for each row
    begin 
        select SEQ_DIVERTISSEMENT.NEXTVAL INTO :new.divertissementid from 
        DUAL;
end;
/

DROP TABLE Jeunesse;
CREATE TABLE Jeunesse (
jeunesseid INTEGER,
constraint PK_Jeunesse PRIMARY KEY (jeunesseid)
);

CREATE SEQUENCE SEQ_JEUNESSE;

CREATE OR REPLACE TRIGGER trig_JEUNESSE
before insert on JEUNESSE for each row
    begin 
        select SEQ_JEUNESSE.NEXTVAL INTO :new.jeunesseid from 
        DUAL;
end;
/

DROP TABLE Cinema;
CREATE TABLE Cinema (
cinemaid INTEGER,
constraint PK_Cinema PRIMARY KEY (cinemaid)
);

CREATE SEQUENCE SEQ_CINEMA;

CREATE OR REPLACE TRIGGER trig_CINEMA
before insert on CINEMA for each row
    begin 
        select SEQ_CINEMA.NEXTVAL INTO :new.cinemaid from 
        DUAL;
end;
/

DROP TABLE SERIE ;
CREATE TABLE Serie (
serieid INTEGER,
nbsaison INTEGER
);

CREATE SEQUENCE SEQ_SERIE;

CREATE OR REPLACE TRIGGER trig_SERIE
before insert on SERIE for each row
    begin 
        select SEQ_SERIE.NEXTVAL INTO :new.serieid from 
        DUAL;
end;
/

ALTER TABLE SAISON DROP CONSTRAINT PK_Saison ;
ALTER TABLE SAISON ADD CONSTRAINT PK_Saison PRIMARY KEY (saisonid, serieid) ;
DROP Table SAISON ;
CREATE TABLE Saison (
serieid INTEGER,
saisonid INTEGER,
NBEP INTEGER NOT NULL,
duree TIMESTAMP NOT NULL,
constraint PK_Saison PRIMARY KEY (saisonid, serieid)
);



---------------------------------------------- ---------------------------------------------------
DROP TABLE Louer ;
CREATE TABLE Louer (
louerid INTEGER,
clientid INTEGER,
date_debut DATE,
date_fin DATE,
version varchar2(30) NOT NULL,
prix INTEGER,
CONSTRAINT check_date_fin CHECK (date_fin = date_debut + 7),
constraint PK_louer PRIMARY KEY (louerid)
);

CREATE SEQUENCE SEQ_LOUER;

CREATE OR REPLACE TRIGGER trig_LOUER
before insert on LOUER for each row
    begin 
        select SEQ_LOUER.NEXTVAL INTO :new.louerid from 
        DUAL;
end;
/

CREATE TABLE Contenue_Louer (
louerid INTEGER,
contenueid INTEGER,
evaluation_location INTEGER,
constraint PK_contenue_louer PRIMARY KEY (louerid, contenueid)
);


DROP TABLE Achete ;
CREATE TABLE Achete (
acheteid Integer,
clientid INTEGER,
formatid INTEGER NOT NULL,
version varchar2(30) NOT NULL,
prix INTEGER,
constraint PK_Achete PRIMARY KEY (acheteid)
);

CREATE SEQUENCE SEQ_ACHETE;

CREATE OR REPLACE TRIGGER trig_ACHETE
before insert on ACHETE for each row
    begin 
        select SEQ_ACHETE.NEXTVAL INTO :new.acheteid from 
        DUAL;
end;
/


CREATE TABLE Contenue_Acheter (
acheteid INTEGER,
contenueid INTEGER,
evaluation_achat INTEGER,
constraint PK_contenue_acheter PRIMARY KEY (acheteid, contenueid)
);

DRop table format ;
CREATE TABLE Format (
formatid INTEGER,
nom varchar2(25) NOT NULL,
extension varchar2(10) NOT NULL,
type VARCHAR2(150) NOT NULL,
logiciels varchar2(150) NOT NULL,
constraint PK_Format PRIMARY KEY (formatid)
);

CREATE SEQUENCE SEQ_FORMAT;

CREATE OR REPLACE TRIGGER trig_FORMAT
before insert on FORMAT for each row
    begin 
        select SEQ_FORMAT.NEXTVAL INTO :new.formatid from 
        DUAL;
end;
/

CREATE TABLE Abonner (
abonnerid INTEGER,
abonnementid INTEGER NOT NULL,
clientid INTEGER NOT NULL,
date_deb DATE NOT NULL,
date_fin DATE NOT NULL,
constraint PK_Abonne PRIMARY KEY (abonnerid)
);

CREATE SEQUENCE SEQ_Abonne;

CREATE OR REPLACE TRIGGER trig_ABONNE
before insert on ABONNE for each row
    begin 
        select SEQ_ABONNE.NEXTVAL INTO :new.abonneid from 
        DUAL;
end;
/

CREATE TABLE Location_Abonner (
abonnerid INTEGER,
contenueid INTEGER,
evaluation_abo INTEGER,
constraint PK_location_abonner PRIMARY KEY (abonnerid, contenueid)
);

DROP TABLE Abonnement ;
CREATE TABLE Abonnement(
abonnementid Integer,
nom varchar2(100) NOT NULL,
nombreMax INTEGER NOT NULL,
prix INTEGER,
constraint PK_Abonnement PRIMARY KEY (abonnementid)
);

CREATE SEQUENCE SEQ_Abonnement;

CREATE OR REPLACE TRIGGER trig_ABONNEMENT
before insert on ABONNEMENT for each row
    begin 
        select SEQ_ABONNEMENT.NEXTVAL INTO :new.abonnementid from 
        DUAL;
end;
/

CREATE TABLE Client_ABO (
clientid Integer,
abonnerid INTEGER,
constraint PK_Client_ABO PRIMARY KEY (clientid,abonnerid)
);

DROp TABLE CLIENT ;
CREATE TABLE Client (
clientid Integer,
nom varchar2(100),
prenom varchar2(100),
Num_rue INTEGER,
RUE varchar2(50),
Ville varchar2(50),
mail varchar2(50),
tel INTEGER,
mdp varchar2(50) NOT NULL,
constraint PK_Client PRIMARY KEY (clientid)
);

CREATE SEQUENCE SEQ_Client;

CREATE OR REPLACE TRIGGER trig_CLIENT
before insert on CLIENT for each row
    begin 
        select SEQ_CLIENT.NEXTVAL INTO :new.clientid from 
        DUAL;
end;
/



---- CLE ETRANGERE TABLE INTERPRETER ----------------
ALTER Table Interpreter ADD Constraint FK_Interpreter_Interprete FOREIGN KEY (interpreteid) REFERENCES Interprete(interpreteid);
ALTER Table Interpreter ADD Constraint FK_Interpreter_Divertissement FOREIGN KEY (divertissementid) REFERENCES Divertissement(divertissementid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE REALISE ----------------
ALTER Table Realise ADD Constraint FK_Realise_Contenue FOREIGN KEY (contenueid) REFERENCES Contenu(contenuid);
ALTER Table Realise ADD Constraint FK_Realise_Realisateur FOREIGN KEY (realisateurid) REFERENCES Realisateur(realisateurid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE REALISE SAISON ----------------
ALTER Table Realise_saison ADD Constraint FK_Realise_seaso_Contenue FOREIGN KEY (saisonid) REFERENCES Saison(saisonid);
ALTER Table Realise_saison ADD Constraint FK_Realise_seaso_Realisateur FOREIGN KEY (realisateurid) REFERENCES Realisateur(realisateurid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE COMPOSE ----------------
ALTER Table Compose ADD Constraint FK_Compose_jeunesse FOREIGN KEY (jeunesseid) REFERENCES Jeunesse(jeunesseid);
ALTER Table Compose ADD Constraint FK_Compose_compositeur FOREIGN KEY (compositeurid) REFERENCES Compositeur(compositeurid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Joue_Film ----------------
ALTER Table Joue_Film ADD Constraint FK_Joue_Film FOREIGN KEY (jouefilmid) REFERENCES Cinema(cinemaid);
ALTER Table Joue_Film ADD Constraint FK_Joue_Film_acteur FOREIGN KEY (acteurid) REFERENCES Acteur(acteurid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Joue_Serie ----------------
ALTER Table Joue_Serie ADD Constraint FK_Joue_Serie FOREIGN KEY (joueserieid) REFERENCES Serie(serieid);
ALTER Table Joue_Serie ADD Constraint FK_Joue_Serie_saison FOREIGN KEY (jouesaisonid) REFERENCES Saison(saisonid);
ALTER Table Joue_Serie ADD Constraint FK_Joue_Serie_acteur FOREIGN KEY (acteurid) REFERENCES Acteur(acteurid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Scenarise_Divertissement ----------------
ALTER Table Scenarise_Divertissement ADD Constraint FK_Scenarise_Div FOREIGN KEY (scenarisedivid) REFERENCES Divertissement(divertissementid);
ALTER Table Scenarise_Divertissement ADD Constraint FK_Scenarise_Div_scenariste FOREIGN KEY (scenaristeid) REFERENCES Scenariste(scenaristeid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Scenarise_Cinema ----------------
ALTER Table Scenarise_Cinema ADD Constraint FK_Scenarise_Cinema FOREIGN KEY (scenarisecinid) REFERENCES Cinema(cinemaid);
ALTER Table Scenarise_Cinema ADD Constraint FK_Scenarise_Cinema_scenariste FOREIGN KEY (scenaristeid) REFERENCES Scenariste(scenaristeid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Scenarise_Jeunesse ----------------
ALTER Table Scenarise_Jeunesse ADD Constraint FK_Scenarise_Jeunesse FOREIGN KEY (scenarisejeuid) REFERENCES Jeunesse(jeunesseid);
ALTER Table Scenarise_Jeunesse ADD Constraint FK_Scenarise_Jeune_scenariste FOREIGN KEY (scenaristeid) REFERENCES Scenariste(scenaristeid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Met_Scene ----------------
ALTER Table Met_Scene ADD Constraint FK_Met_Scene FOREIGN KEY (met_sceneid) REFERENCES Divertissement(divertissementid);
ALTER Table Met_Scene ADD Constraint FK_Met_Scene_metteur FOREIGN KEY (metteurensceneid) REFERENCES MetteurEnScene(metteurensceneid);
---------- Fin des CLE ETRANGERE de la TABLE --------



---- CLE ETRANGERE TABLE Contenu ----------------
ALTER Table Contenu ADD Constraint FK_Contenu_Type FOREIGN KEY (type) REFERENCES TYPE_CONTENU(nom);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Saison ----------------
ALTER Table Saison ADD Constraint FK_Saison_serie FOREIGN KEY (serieid) REFERENCES Serie(serieid);
---------- Fin des CLE ETRANGERE de la TABLE --------



---- CLE ETRANGERE TABLE LOUER ----------------
ALTER Table Louer ADD Constraint FK_Louer_client FOREIGN KEY (clientid) REFERENCES Client(clientid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Contenue_Louer ----------------
ALTER Table Contenue_Louer ADD Constraint FK_Contenue_Louer_loue FOREIGN KEY (louerid) REFERENCES Louer(louerid);
ALTER Table Contenue_Louer ADD Constraint FK_Contenue_Louer_contenu FOREIGN KEY (contenueid) REFERENCES Contenu(contenuid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Achete ----------------
ALTER Table Achete ADD Constraint FK_Achete_client FOREIGN KEY (clientid) REFERENCES Client(clientid);
ALTER Table Achete ADD Constraint FK_Achete_format FOREIGN KEY (formatid) REFERENCES Format(formatid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Contenue_Acheter ----------------
ALTER Table Contenue_Acheter ADD Constraint FK_Contenue_Acheter_achat FOREIGN KEY (acheteid) REFERENCES Achete(acheteid);
ALTER Table Contenue_Acheter ADD Constraint FK_Contenue_Acheter_conte FOREIGN KEY (contenueid) REFERENCES Contenu(contenuid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Abonner ----------------
ALTER Table Abonner DROP Constraint FK_Abonner_abonnement ;
ALTER Table Abonner ADD Constraint FK_Abonner_abonnement FOREIGN KEY (abonnementid) REFERENCES Abonnement(abonnementid);
ALTER Table Abonner ADD Constraint FK_Abonner_client FOREIGN KEY (clientid) REFERENCES Client(clientid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Location_Abonner ----------------
ALTER Table Location_Abonner ADD Constraint FK_Location_Abonner_abo FOREIGN KEY (abonnerid) REFERENCES Abonner(abonnerid);
ALTER Table Location_Abonner ADD Constraint FK_Location_Abonner_conte FOREIGN KEY (contenueid) REFERENCES Contenu(contenuid);
---------- Fin des CLE ETRANGERE de la TABLE --------

---- CLE ETRANGERE TABLE Client_ABO ----------------
ALTER Table Client_ABO ADD Constraint FK_Client_ABO_abonner FOREIGN KEY (abonnerid) REFERENCES Abonner(abonnerid);
ALTER Table  Client_ABO ADD Constraint FK_Client_ABO_client FOREIGN KEY (clientid) REFERENCES Client(clientid);
---------- Fin des CLE ETRANGERE de la TABLE --------










