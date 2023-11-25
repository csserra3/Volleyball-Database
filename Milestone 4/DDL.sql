-- DDL
DROP TABLE Organization;
DROP TABLE Facility;
DROP TABLE Tournament;
DROP TABLE Club;
DROP TABLE Members;
DROP TABLE Certification;
DROP TABLE Sponsors;
DROP TABLE HostedAt;
DROP TABLE Coaches;
DROP TABLE Team;
DROP TABLE Manages;
DROP TABLE Participate;
DROP TABLE Players;
DROP TABLE PlayerStats;
DROP TABLE Gets;
DROP TABLE Teaches;


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
    SponsorID    VARCHAR(50),
    StartDate    DATE,
    EndDate      DATE,
    PRIMARY KEY (TournamentID),
    FOREIGN KEY (FacilityName) REFERENCES Facility,
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
    PRIMARY KEY (MemberID)
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
    TournamentID INT,
    FacilityID INT,
    PRIMARY KEY (TournamentID, FacilityID)
    FOREIGN KEY (TournamentID) REFERENCES Tournament,
    FOREIGN KEY (FacilityID) REFERENCES Facility
);

CREATE TABLE Coaches
(
    ID              INTEGER,
    YearsCoached    INTEGER,
    FOREIGN KEY (ID) REFERENCES Members,
    PRIMARY KEY (ID)
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
    FOREIGN KEY (TeamID) REFERENCES Team,
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
    PlayerID      Integer,
    MatchesPlayed INTEGER,
    GamesWon      INTEGER,
    NumofPoints   INTEGER,
    PRIMARY KEY (StatID),
    FOREIGN KEY (PlayerID) REFERENCES Players ON DELETE CASCADE
);

CREATE TABLE Gets
(
    GetID           INTEGER,
    ID        INTEGER,
    CertificateName VARCHAR(50),
    DateCertified   DATE,
    PRIMARY KEY (GetID),
    FOREIGN KEY (ID) REFERENCES Members,
    FOREIGN KEY (CertificateName) REFERENCES Certification
);

CREATE TABLE Teaches
(
    TeamID     INTEGER,
    ID         INTEGER,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES Members,
    FOREIGN KEY (TeamID) REFERENCES Team
);

-- INSERT STATEMENTS
INSERT INTO Organization(OrganizationID, Name, AmountSponsored)
VALUES (0000001, 'OrganizationOne', 10000),
       (0000002, 'OrganizationTwo', 10000),
       (0000003, 'OrganizationThree', 20000),
       (0000004, 'OrganizationFour', 3000),
       (0000005, 'OrganizationFive', 5000);

INSERT INTO Facility(FacilityID, FacilityName, Address, Capacity)
VALUES (0000001, 'FacilityOne', '123 Abc St', 500),
       (0000002, 'FacilityTwo', '19030 74 Ave', 400),
       (0000003, 'FacilityThree', '3012 Glen Dr', 500),
       (0000004, 'FacilityFour', '222 Smith Ave', 1000),
       (0000005, 'FacilityFive', '123 Van St', 700);

INSERT INTO Tournament(TournamentID, Name, FacilityName, SponsorID, StartDate, EndDate)
VALUES (0000001, 'TOne', 'FacilityOne', 0000001, 2023 - 06 - 28, 2023 - 06 - 30),
       (0000002, 'TTwo', 'FacilityTwo', '19030 74 Ave', 0000002, 2024 - 03 - 28, 2023 - 03 - 30),
       (0000003, 'TThree', 'FacilityThree', '3012 Glen Dr', 0000003, 2023 - 01 - 18, 2023 - 01 - 19),
       (0000004, 'TFour', 'FacilityFour', '222 Smith Ave', 0000004, 2023 - 07 - 28, 2023 - 07 - 30),
       (0000005, 'TFive', 'FacilityFive', '123 Van St', 0000005, 2024 - 06 - 25, 2024 - 06 - 29);

INSERT INTO Club(ClubID, Name, Location)
VALUES (0000001, 'ClubOne', '333 Sunny Ave'),
       (0000002, 'ClubTwo', '5034 Lock Ave'),
       (0000003, 'ClubThree', '4102 Ocean Dr'),
       (0000004, 'ClubFour', '3032 Bob Ave'),
       (0000005, 'ClubFive', '553 Smith St');

INSERT INTO Members(ID, Name, PhoneNum, Address, City, Birthdate, Age)
VALUES (001, 'Bob Smith', 6045555555, '123 Sunny Ave', 'Vancouver', 1996 - 01 - 01, 20),
       (002, 'Joe David', 6045557777, '333 Flemings Ave', 'Vancouver', 1991 - 02 - 01, 19),
       (003, 'Billy Smith', 6045555566, '555 Water Ave', 'Burnaby', 2000 - 11 - 10, 19),
       (004, 'Sue Anderson', 6045555353, '6063 Blue Street', 'Richmond', 1996 - 01 - 01, 22),
       (005, 'Michael Scott', 6045555151, '2323 80 Ave', 'Surrey', 1996 - 01 - 01, 24);

INSERT INTO Certification(CertificationID, CertificateName, ExpirationDate)
VALUES (55551, 'CertOne', 2023 - 06 - 12),
       (55552, 'CertTwo', 2023 - 02 - 11),
       (55553, 'CertThree', 2024 - 01 - 01),
       (55554, 'CertFour', 2023 - 10 - 10),
       (55555, 'CertFive', 2023 - 06 - 13);

INSERT INTO Sponsors(OrganizationID, TournamentID, AmountSponsored)
VALUES (0000001, 0000001, 100000),
       (0000002, 0000002, 200000),
       (0000003, 0000003, 300000),
       (0000004, 0000004, 400000),
       (0000005, 0000005, 500000);

INSERT INTO HostedAt(TournamentID, FacilityID)
VALUES (0000001, 0000001),
       (0000002, 0000002),
       (0000003, 0000003),
       (0000004, 0000004),
       (0000005, 0000005);

INSERT INTO Coaches(ID, CertificateName, YearsCoached)
VALUES (010, 2),
       (012, 3),
       (013, 6),
       (020, 12),
       (021, 5);

INSERT INTO Team(TeamID, ClubID, CoachID, NumPlayers)
VALUES (000001, 0000001, 11111, 11),
       (000002, 0000002, 22222, 15),
       (000003, 0000003, 33333, 10),
       (000004, 0000004, 44444, 14),
       (000005, 0000005, 55555, 10);

INSERT INTO Manages(ClubID, TeamID)
VALUES (000001, 0000001),
       (000002, 0000002),
       (000003, 0000003),
       (000004, 0000004),
       (000005, 0000005);

INSERT INTO Participate(TeamID, TournamentID)
VALUES (000001, 0000001),
       (000002, 0000002),
       (000003, 0000003),
       (000004, 0000004),
       (000005, 0000005);

INSERT INTO Players(ID, JerseyNum, Position, TeamID, SIN)
VALUES (001,00,"Power",000001,665577),
       (002,10,"Middle",000001,556633),
       (003,16,"Setter",000003,663321),
       (004,09,"Power",000005,332244),
       (005,99,"Libero",000005,562525S);

INSERT INTO PlayerStats(StatID, PlayerID, MatchesPlayed, GamesWon, NumOfPoints)
VALUES (00000001, 1001, 5, 2, 2000),
       (00000002, 1015, 15, 8, 500),
       (00000003, 1022, 25, 10, 900),
       (00000004, 1010, 30, 10, 3000),
       (000000005, 1032, 1, 0, 100);

INSERT INTO Gets(ID, CertificationID)
VALUES (010, 55551),
       (012, 55552),
       (013, 55553),
       (020, 55554),
       (021, 55555);

INSERT INTO Teaches(TeamID, ID)
VALUES (000001, 010),
       (000002, 012),
       (000003, 013),
       (000004, 020),
       (000005, 021);

