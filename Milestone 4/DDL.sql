-- DDL From Milestone 2
-- TODO: Need tables to account for Relations

CREATE TABLE Organization
(
    OrganizationID  INTEGER,
    Name            VARCHAR(50),
    AmountSponsored INTEGER,
    PRIMARY KEY (OrganizationID)
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

CREATE TABLE Tournaments
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

CREATE TABLE HostedAt
(
    TournamentID INT,
    FacilityID INT,
    PRIMARY KEY (TournamentID, FacilityID)
    FOREIGN KEY (TournamentID) REFERENCES Tournament,
    FOREIGN KEY (FacilityID) REFERENCES Facility
);

CREATE TABLE Facility
(
    FacilityID   INTEGER,
    FacilityName VARCHAR(50),
    Address      VARCHAR(50),
    Capacity     INTEGER,
    PRIMARY KEY (FacilityID)
);

CREATE TABLE Participate
(
    TeamID          INTEGER,
    TournamentID    INTEGER,
    PRIMARY KEY (TournamentID, TeamID),
    FOREIGN KEY (TeamID) REFERENCES Team,
    FOREIGN KEY (TournamentID) REFERENCES Tournament
);

CREATE TABLE Club
(
    ClubID   INTEGER,
    Name     VARCHAR(50),
    Location VARCHAR(50),
    PRIMARY KEY (ClubID)
);

CREATE TABLE Manages
(
    ClubID   INTEGER,
    TeamID   INTEGER,
    PRIMARY KEY (ClubID, TeamID),
    FOREIGN KEY (ClubID) REFERENCES Club,
    FOREIGN KEY (TeamID) REFERENCES Team,
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

CREATE TABLE Coaches
(
    ID              INTEGER,
    YearsCoached    INTEGER,
    FOREIGN KEY (ID) REFERENCES Members,
    PRIMARY KEY (ID)
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
)

CREATE TABLE PlayerStats
(
    StatID        INTEGER,
    PlayerID      Integer,
    MatchesPlayed INTEGER,
    GamesWon      INTEGER,
    NumOfPoints   INTEGER,
    PRIMARY KEY (StatID),
    FOREIGN KEY (PlayerID) REFERENCES Players,
    ON DELETE CASCADE
)

CREATE TABLE Certification
(
    CertificationID INTEGER,
    CertificateName VARCHAR(50),
    ExpirationDate  DATE,
    PRIMARY KEY (CertificationID)
)

CREATE TABLE Gets
(
    ID              INTEGER,
    CertificationID   INTEGER,
    PRIMARY KEY (ID, CertificationID),
    FOREIGN KEY (ID) REFERENCES Members,
    FOREIGN KEY (CertificationID) REFERENCES Certification
);

CREATE TABLE Teaches
(
    TeamID     INTEGER,
    ID         INTEGER,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES Members,
    FOREIGN KEY (TeamID) REFERENCES Team
);