-- DDL From Milestone 2
-- TODO: Need tables to account for Relations

drop table Organization;
drop table Facility;

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
)

CREATE TABLE Club
(
    ClubID   INTEGER,
    Name     VARCHAR(50),
    Location VARCHAR(50),
    PRIMARY KEY (ClubID)
)

CREATE TABLE Team
(
    TeamID     INTEGER,
    ClubID     INTEGER,
    CoachID    INTEGER,
    NumPlayers INTEGER,
    PRIMARY KEY (TeamID),
    FOREIGN KEY (ClubID) REFERENCES Club,
    FOREIGN KEY (CoachID) REFERENCES Coaches
)

CREATE TABLE Players
(
    PlayerID  INTEGER,
    MemberID  INTEGER,
    JerseyNum INTEGER,
    Position  VARCHAR(50),
    TeamID    INTEGER,
    SIN       INTEGER,
    PRIMARY KEY (PlayerID, MemberID),
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
    NumofPoints   INTEGER,
    PRIMARY KEY (StatID),
    FOREIGN KEY (PlayerID) REFERENCES Players,
    ON DELETE CASCADE
)
    )

CREATE TABLE Certification
(
    CertificationID INTEGER,
    CertificateName VARCHAR(50),
    ExpirationDate  DATE,
    PRIMARY KEY (CertificationID)
)

CREATE TABLE Coaches
(
    CoachID         INTEGER,
    MemberID        INTEGER,
    CertificateName VARCHAR(50),
    YearsCoached    INTEGER,
    FOREIGN KEY (ID) REFERENCES Members,
    FOREIGN KEY (CertificateName) REFERENCES Certification,
    PRIMARY KEY (MemberID)
)

CREATE TABLE Members
(
    MemberID  INTEGER,
    Name      VARCHAR(50),
    PhoneNum  INTEGER,
    Address   VARCHAR(50),
    City      VARCHAR(50),
    BirthDate DATE,
    Age       INTEGER,
    PRIMARY KEY (MemberID)
)
