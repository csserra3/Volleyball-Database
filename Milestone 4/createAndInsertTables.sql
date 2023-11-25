DROP TABLE Teaches;
DROP TABLE Gets;
DROP TABLE PlayerStats;
DROP TABLE Players;
DROP TABLE Participate;
DROP TABLE Manages;
DROP TABLE Team;
DROP TABLE Coaches;
DROP TABLE HostedAt;
DROP TABLE Sponsors;
DROP TABLE Certification;
DROP TABLE Members;
DROP TABLE Club;
DROP TABLE Tournament;
DROP TABLE Facility;
DROP TABLE Organization;


CREATE TABLE Organization
(
    OrganizationID  INTEGER,
    Name            VARCHAR(50),
    AmountSponsored INTEGER,
    PRIMARY KEY (OrganizationID)
);

CREATE TABLE Facility
(
    FacilityID   INTEGER,
    FacilityName VARCHAR(50),
    Address      VARCHAR(50),
    Capacity     INTEGER,
    PRIMARY KEY (FacilityID)
);

CREATE TABLE Tournament
(
    TournamentID INTEGER,
    Name         VARCHAR(50),
    FacilityName VARCHAR(50) NOT NULL,
    SponsorID    INTEGER,
    StartDate    DATE,
    EndDate      DATE,
    PRIMARY KEY (TournamentID),
    FOREIGN KEY (SponsorID) REFERENCES Organization
);

CREATE TABLE Club
(
    ClubID   INTEGER,
    Name     VARCHAR(50),
    Location VARCHAR(50),
    PRIMARY KEY (ClubID)
);

CREATE TABLE Members
(
    ID  INTEGER,
    Name      VARCHAR(50),
    PhoneNum  INTEGER,
    Address   VARCHAR(50),
    City      VARCHAR(50),
    BirthDate DATE,
    Age       INTEGER,
    PRIMARY KEY (ID)
);

CREATE TABLE Certification
(
    CertificationID INTEGER,
    CertificateName VARCHAR(50),
    ExpirationDate  DATE,
    PRIMARY KEY (CertificationID)
);

CREATE TABLE Sponsors
(
    OrganizationID INTEGER,
    TournamentID INTEGER,
    AmountSponsored INTEGER,
    PRIMARY KEY (OrganizationID, TournamentID),
    FOREIGN KEY (OrganizationID) REFERENCES Organization,
    FOREIGN KEY (TournamentID) REFERENCES Tournament
);

CREATE TABLE HostedAt
(
    TournamentID INTEGER,
    FacilityID INTEGER,
    PRIMARY KEY (TournamentID, FacilityID),
    FOREIGN KEY (TournamentID) REFERENCES Tournament,
    FOREIGN KEY (FacilityID) REFERENCES Facility
);

CREATE TABLE Coaches
(
    ID              INTEGER,
    YearsCoached    INTEGER,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES Members
);

CREATE TABLE Team
(
    TeamID     INTEGER,
    ClubID     INTEGER,
    CoachID    INTEGER,
    NumPlayers INTEGER,
    PRIMARY KEY (TeamID),
    FOREIGN KEY (ClubID) REFERENCES Club,
    FOREIGN KEY (CoachID) REFERENCES Coaches
);

CREATE TABLE Manages
(
    ClubID   INTEGER,
    TeamID   INTEGER,
    PRIMARY KEY (ClubID, TeamID),
    FOREIGN KEY (ClubID) REFERENCES Club,
    FOREIGN KEY (TeamID) REFERENCES Team
);

CREATE TABLE Participate
(
    TeamID          INTEGER,
    TournamentID    INTEGER,
    PRIMARY KEY (TournamentID, TeamID),
    FOREIGN KEY (TeamID) REFERENCES Team,
    FOREIGN KEY (TournamentID) REFERENCES Tournament
);

CREATE TABLE Players
(
    ID         INTEGER,
    JerseyNum INTEGER,
    Position  VARCHAR(50),
    TeamID    INTEGER,
    SIN       INTEGER,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES Members,
    FOREIGN KEY (TeamID) REFERENCES Team,
    UNIQUE (SIN)
);

CREATE TABLE PlayerStats
(
    StatID        INTEGER,
    PlayerID      INTEGER,
    MatchesPlayed INTEGER,
    GamesWon      INTEGER,
    NumofPoints   INTEGER,
    PRIMARY KEY (StatID),
    FOREIGN KEY (PlayerID) REFERENCES Players ON DELETE CASCADE
);

CREATE TABLE Gets
(
    GetID           INTEGER,
    MemberID        INTEGER,
    CertificateName VARCHAR(50),
    DateCertified   DATE,
    PRIMARY KEY (GetID),
    FOREIGN KEY (MemberID) REFERENCES Members
);

CREATE TABLE Teaches
(
    TeachID    INTEGER,
    TeamID     INTEGER,
    ID         INTEGER,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES Members,
    FOREIGN KEY (TeamID) REFERENCES Team
);
--
-- -- INSERT STATEMENTS
INSERT INTO Organization (OrganizationID, Name, AmountSponsored) VALUES (1, 'OrganizationOne', 10000);
INSERT INTO Organization (OrganizationID, Name, AmountSponsored) VALUES (2, 'OrganizationTwo', 10000);
INSERT INTO Organization (OrganizationID, Name, AmountSponsored) VALUES (3, 'OrganizationThree', 20000);
INSERT INTO Organization (OrganizationID, Name, AmountSponsored) VALUES (4, 'OrganizationFour', 3000);
INSERT INTO Organization (OrganizationID, Name, AmountSponsored) VALUES (5, 'OrganizationFive', 5000);

INSERT INTO Facility(FacilityID, FacilityName, Address, Capacity)VALUES (1, 'FacilityOne', '123 Abc St', 500);
INSERT INTO Facility(FacilityID, FacilityName, Address, Capacity)VALUES (2, 'FacilityTwo', '19030 74 Ave', 400);
INSERT INTO Facility(FacilityID, FacilityName, Address, Capacity)VALUES (3, 'FacilityThree', '3012 Glen Dr', 500);
INSERT INTO Facility(FacilityID, FacilityName, Address, Capacity)VALUES (4, 'FacilityFour', '222 Smith Ave', 1000);
INSERT INTO Facility(FacilityID, FacilityName, Address, Capacity)VALUES (5, 'FacilityFive', '123 Van St', 700);

INSERT INTO Tournament(TournamentID, Name, FacilityName, SponsorID, StartDate, EndDate) VALUES (1, 'TOne', 'FacilityOne', 1, TO_DATE('2023-06-28', 'YYYY-MM-DD'), TO_DATE('2023-06-30', 'YYYY-MM-DD'));
INSERT INTO Tournament(TournamentID, Name, FacilityName, SponsorID, StartDate, EndDate) VALUES (2, 'TTwo', 'FacilityTwo', 2, TO_DATE('2024-03-28', 'YYYY-MM-DD'), TO_DATE('2023-03-30', 'YYYY-MM-DD'));
INSERT INTO Tournament(TournamentID, Name, FacilityName, SponsorID, StartDate, EndDate) VALUES (3, 'TThree', 'FacilityThree', 3, TO_DATE('2023-01-18', 'YYYY-MM-DD'), TO_DATE('2023-01-19', 'YYYY-MM-DD'));
INSERT INTO Tournament(TournamentID, Name, FacilityName, SponsorID, StartDate, EndDate) VALUES (4, 'TFour', 'FacilityFour', 4, TO_DATE('2023-07-28', 'YYYY-MM-DD'), TO_DATE('2023-07-30', 'YYYY-MM-DD'));
INSERT INTO Tournament(TournamentID, Name, FacilityName, SponsorID, StartDate, EndDate) VALUES  (5, 'TFive', 'FacilityFive', 5, TO_DATE('2024-06-25', 'YYYY-MM-DD'), TO_DATE('2024-06-29', 'YYYY-MM-DD'));

INSERT INTO Club(ClubID, Name, Location) VALUES (00001, 'ClubOne', '333 Sunny Ave');
INSERT INTO Club(ClubID, Name, Location) VALUES (00002, 'ClubTwo', '5034 Lock Ave');
INSERT INTO Club(ClubID, Name, Location) VALUES (00003, 'ClubThree', '4102 Ocean Dr');
INSERT INTO Club(ClubID, Name, Location) VALUES (00004, 'ClubFour', '3032 Bob Ave');
INSERT INTO Club(ClubID, Name, Location) VALUES (00005, 'ClubFive', '553 Smith St');

INSERT INTO Members(ID, Name, PhoneNum, Address, City, Birthdate, Age) VALUES (1, 'Bob Smith', 6045555555, '123 Sunny Ave', 'Vancouver', TO_DATE('1996-01-01', 'YYYY-MM-DD'), 20);
INSERT INTO Members(ID, Name, PhoneNum, Address, City, Birthdate, Age) VALUES (2, 'Joe David', 6045557777, '333 Flemings Ave', 'Vancouver', TO_DATE('1991-02-01', 'YYYY-MM-DD'), 19);
INSERT INTO Members(ID, Name, PhoneNum, Address, City, Birthdate, Age) VALUES (3, 'Billy Smith', 6045555566, '555 Water Ave', 'Burnaby', TO_DATE('2000-11-10', 'YYYY-MM-DD'), 19);
INSERT INTO Members(ID, Name, PhoneNum, Address, City, Birthdate, Age) VALUES  (4, 'Sue Anderson', 6045555353, '6063 Blue Street', 'Richmond', TO_DATE('1996-01-01', 'YYYY-MM-DD'), 22);
INSERT INTO Members(ID, Name, PhoneNum, Address, City, Birthdate, Age) VALUES (5, 'Michael Scott', 6045555151, '2323 80 Ave', 'Surrey', TO_DATE('1996-01-01', 'YYYY-MM-DD'), 24);


INSERT INTO Certification(CertificationID, CertificateName, ExpirationDate) VALUES (55551, 'CertOne', TO_DATE('2023-06-12', 'YYYY-MM-DD'));
INSERT INTO Certification(CertificationID, CertificateName, ExpirationDate) VALUES (55552, 'CertTwo', TO_DATE('2023-02-11', 'YYYY-MM-DD'));
INSERT INTO Certification(CertificationID, CertificateName, ExpirationDate) VALUES (55553, 'CertThree', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO Certification(CertificationID, CertificateName, ExpirationDate) VALUES (55554, 'CertFour', TO_DATE('2023-10-10', 'YYYY-MM-DD'));
INSERT INTO Certification(CertificationID, CertificateName, ExpirationDate) VALUES (55555, 'CertFive', TO_DATE('2023-06-13', 'YYYY-MM-DD'));

INSERT INTO Sponsors(OrganizationID, TournamentID, AmountSponsored) VALUES (1, 1, 100000);
INSERT INTO Sponsors(OrganizationID, TournamentID, AmountSponsored) VALUES (2, 2, 200000);
INSERT INTO Sponsors(OrganizationID, TournamentID, AmountSponsored) VALUES (3, 3, 300000);
INSERT INTO Sponsors(OrganizationID, TournamentID, AmountSponsored) VALUES (4, 4, 400000);
INSERT INTO Sponsors(OrganizationID, TournamentID, AmountSponsored) VALUES (5, 5, 500000);

INSERT INTO HostedAt(TournamentID, FacilityID) VALUES (1, 1);
INSERT INTO HostedAt(TournamentID, FacilityID) VALUES (2, 2);
INSERT INTO HostedAt(TournamentID, FacilityID) VALUES (3, 3);
INSERT INTO HostedAt(TournamentID, FacilityID) VALUES (4, 4);
INSERT INTO HostedAt(TournamentID, FacilityID) VALUES (5, 5);

INSERT INTO Coaches(ID, YearsCoached) VALUES (1, 2);
INSERT INTO Coaches(ID, YearsCoached) VALUES (2, 3);
INSERT INTO Coaches(ID, YearsCoached) VALUES (3, 5);
INSERT INTO Coaches(ID, YearsCoached) VALUES (4, 7);
INSERT INTO Coaches(ID, YearsCoached) VALUES (5, 10);

INSERT INTO Team(TeamID, ClubID, CoachID, NumPlayers) VALUES (1, 1, 1, 12);
INSERT INTO Team(TeamID, ClubID, CoachID, NumPlayers) VALUES (2, 2, 2, 14);
INSERT INTO Team(TeamID, ClubID, CoachID, NumPlayers) VALUES (3, 3, 3, 12);
INSERT INTO Team(TeamID, ClubID, CoachID, NumPlayers) VALUES (4, 4, 4, 12);
INSERT INTO Team(TeamID, ClubID, CoachID, NumPlayers) VALUES (5, 5, 5, 14);

INSERT INTO Manages(ClubID, TeamID) VALUES (00001, 1);
INSERT INTO Manages(ClubID, TeamID) VALUES (00002, 2);
INSERT INTO Manages(ClubID, TeamID) VALUES (00003, 3);
INSERT INTO Manages(ClubID, TeamID) VALUES (00004, 4);
INSERT INTO Manages(ClubID, TeamID) VALUES (00005, 5);

INSERT INTO Participate(TeamID, TournamentID) VALUES (1, 1);
INSERT INTO Participate(TeamID, TournamentID) VALUES (2, 2);
INSERT INTO Participate(TeamID, TournamentID) VALUES (3, 3);
INSERT INTO Participate(TeamID, TournamentID) VALUES (4, 4);
INSERT INTO Participate(TeamID, TournamentID) VALUES (5, 5);

INSERT INTO Players(ID, JerseyNum, Position, TeamID, SIN) VALUES (1,0,'Outside',1,665577);
INSERT INTO Players(ID, JerseyNum, Position, TeamID, SIN) VALUES (2,10,'Middle',1,556633);
INSERT INTO Players(ID, JerseyNum, Position, TeamID, SIN) VALUES (3,16,'Setter',3,663321);
INSERT INTO Players(ID, JerseyNum, Position, TeamID, SIN) VALUES (4,9,'Power',5,332244);
INSERT INTO Players(ID, JerseyNum, Position, TeamID, SIN) VALUES (5,6,'Libero',5,562525);


INSERT INTO PlayerStats(StatID, PlayerID, MatchesPlayed, GamesWon, NumOfPoints)VALUES (1, 1, 5, 2, 2000);
INSERT INTO PlayerStats(StatID, PlayerID, MatchesPlayed, GamesWon, NumOfPoints)VALUES (2, 2, 25, 10, 900);
INSERT INTO PlayerStats(StatID, PlayerID, MatchesPlayed, GamesWon, NumOfPoints)VALUES (3, 3, 10, 2, 2000);
INSERT INTO PlayerStats(StatID, PlayerID, MatchesPlayed, GamesWon, NumOfPoints)VALUES (4, 4, 7, 2, 2000);
INSERT INTO PlayerStats(StatID, PlayerID, MatchesPlayed, GamesWon, NumOfPoints)VALUES (5, 5, 5, 2, 2000);

INSERT INTO Gets(GetID, MemberID, CertificateName, DateCertified) VALUES (1, 1, 'Safe Sport', TO_DATE('2012-03-10', 'YYYY-MM-DD'));
INSERT INTO Gets(GetID, MemberID, CertificateName, DateCertified) VALUES (2, 2, 'Safe Sport', TO_DATE('2014-05-11', 'YYYY-MM-DD'));
INSERT INTO Gets(GetID, MemberID, CertificateName, DateCertified) VALUES (3, 3, 'Safe Sport', TO_DATE('2016-07-23', 'YYYY-MM-DD'));
INSERT INTO Gets(GetID, MemberID, CertificateName, DateCertified) VALUES (4, 4, 'Safe Sport', TO_DATE('2017-01-20', 'YYYY-MM-DD'));
INSERT INTO Gets(GetID, MemberID, CertificateName, DateCertified) VALUES (5, 5, 'Safe Sport', TO_DATE('2011-09-2', 'YYYY-MM-DD'));

INSERT INTO Teaches(TeachID, TeamID, ID) VALUES (1, 1, 1);
INSERT INTO Teaches(TeachID, TeamID, ID) VALUES (2, 2, 2);
INSERT INTO Teaches(TeachID, TeamID, ID) VALUES (3, 3, 3);
INSERT INTO Teaches(TeachID, TeamID, ID) VALUES (4, 4, 4);
INSERT INTO Teaches(TeachID, TeamID, ID) VALUES (5, 5, 5);
