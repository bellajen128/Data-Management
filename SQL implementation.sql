SET SQL_SAFE_UPDATES = 0;

CREATE DATABASE IF NOT EXISTS DatingApp;
USE DatingApp;
-- Users table
CREATE TABLE IF NOT EXISTS Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    GenderIdentity VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Age INT,
    Location VARCHAR(255),
    Bio TEXT
) ENGINE=InnoDB;
DELIMITER //
CREATE TRIGGER before_insert_users
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    SET NEW.Age = TIMESTAMPDIFF(YEAR, NEW.DateOfBirth, CURDATE());
END;
//
DELIMITER ;

-- Interests table
CREATE TABLE IF NOT EXISTS Interests (
    InterestID INT AUTO_INCREMENT PRIMARY KEY,
    InterestName VARCHAR(255) NOT NULL
) ENGINE=InnoDB;



-- UserInterests table
CREATE TABLE IF NOT EXISTS UserInterests (
    UserID INT NOT NULL,
    InterestID INT NOT NULL,
    PRIMARY KEY (UserID, InterestID),
    FOREIGN KEY (UserID) REFERENCES UseUsersrs(UserID),
    FOREIGN KEY (InterestID) REFERENCES Interests(InterestID)
) ENGINE=InnoDB;

-- Preferences table
CREATE TABLE IF NOT EXISTS Preferences (
    PreferenceID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    PreferredAgeLower INT,
    PreferredAgeUpper INT,
    PreferredLocation VARCHAR(255),
    PreferredGender VARCHAR(50),
    OtherFilters TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- Likes table
CREATE TABLE IF NOT EXISTS Likes (
    LikeID INT AUTO_INCREMENT PRIMARY KEY,
    LikerUserID INT NOT NULL,
    LikeeUserID INT NOT NULL,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (LikerUserID) REFERENCES Users(UserID),
    FOREIGN KEY (LikeeUserID) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- Matches table
CREATE TABLE IF NOT EXISTS Matches (
    MatchID INT AUTO_INCREMENT PRIMARY KEY,
    UserID1 INT NOT NULL,
    UserID2 INT NOT NULL,
    MatchTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID1) REFERENCES Users(UserID),
    FOREIGN KEY (UserID2) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- Conversations table
CREATE TABLE IF NOT EXISTS Conversations (
    ConversationID INT AUTO_INCREMENT PRIMARY KEY,
    User1ID INT NOT NULL,
    User2ID INT NOT NULL,
    ConversationStartTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (User1ID) REFERENCES Users(UserID),
    FOREIGN KEY (User2ID) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- Messages table
CREATE TABLE IF NOT EXISTS Messages (
    MessageID INT AUTO_INCREMENT PRIMARY KEY,
    ConversationID INT NOT NULL,
    SenderID INT NOT NULL,
    Content TEXT NOT NULL,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ConversationID) REFERENCES Conversations(ConversationID),
    FOREIGN KEY (SenderID) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- SubscriptionPackages table
CREATE TABLE IF NOT EXISTS SubscriptionPackages (
    PackageID INT AUTO_INCREMENT PRIMARY KEY,
    PackageName VARCHAR(255) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Duration INT NOT NULL,
    FeaturesIncluded TEXT
) ENGINE=InnoDB;

-- UserSubscriptions table
CREATE TABLE IF NOT EXISTS UserSubscriptions (
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    PackageID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PaymentDetails VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PackageID) REFERENCES SubscriptionPackages(PackageID)
) ENGINE=InnoDB;

-- LoginLogoutRecords table
CREATE TABLE IF NOT EXISTS LoginLogoutRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    LoginTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    LogoutTimestamp DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- ProfileVisits table
CREATE TABLE IF NOT EXISTS ProfileVisits (
    VisitID INT AUTO_INCREMENT PRIMARY KEY,
    ViewerUserID INT NOT NULL,
    ViewedUserID INT NOT NULL,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ViewerUserID) REFERENCES Users(UserID),
    FOREIGN KEY (ViewedUserID) REFERENCES Users(UserID)
) ENGINE=InnoDB;



-- insert sample data --

INSERT INTO Users (Username, PasswordHash, GenderIdentity, DateOfBirth, Location, Bio)
VALUES
    ('Alice', 'hashed_password_21', 'Female', '1992-01-01', 'New York', 'Enjoys painting and reading books.'),
    ('Bob', 'hashed_password_22', 'Male', '1990-02-01', 'Los Angeles', 'A foodie who loves outdoor adventures.'),
    ('Charlie', 'hashed_password_23', 'Male', '1988-03-03', 'Chicago', 'Tech enthusiast and a rock climber.'),
    ('Diana', 'hashed_password_24', 'Female', '1991-04-04', 'San Francisco', 'Yoga practitioner and writer.'),
    ('Eve', 'hashed_password_25', 'Female', '1989-05-05', 'Chicago', 'Music lover and traveler.'),
    ('Frank', 'hashed_password_26', 'Male', '1993-06-06', 'Seattle', 'Aspiring photographer and traveler.'),
    ('Grace', 'hashed_password_27', 'Female', '1994-07-07', 'Chicago', 'Food lover and movie buff.'),
    ('Henry', 'hashed_password_28', 'Male', '1987-08-08', 'New York', 'Professional gamer and photographer.'),
    ('Iris', 'hashed_password_29', 'Female', '1990-09-09', 'Chicago', 'Fashion designer and environmentalist.'),
    ('Jack', 'hashed_password_30', 'Male', '1985-10-10', 'Seattle', 'Music composer and nature explorer.'),
    ('Katie', 'hashed_password_31', 'Female', '1992-11-11', 'New York', 'Hiker and wine enthusiast.'),
    ('Leo', 'hashed_password_32', 'Male', '1993-12-12', 'Seattle', 'Tech geek and DIY enthusiast.'),
    ('Mia', 'hashed_password_33', 'Female', '1996-01-01', 'Chicago', 'Photography and adventure lover.'),
    ('Nate', 'hashed_password_34', 'Male', '1986-02-02', 'New York', 'Guitarist and fitness enthusiast.'),
    ('Olivia', 'hashed_password_35', 'Female', '1988-03-03', 'New York', 'Art curator and film buff.'),
    ('Peter', 'hashed_password_36', 'Male', '1991-04-04', 'Los Angeles', 'Entrepreneur and sports fan.'),
    ('Quincy', 'hashed_password_37', 'Male', '1992-05-05', 'San Francisco', 'Traveler and tech innovator.'),
    ('Rachel', 'hashed_password_38', 'Female', '1995-06-06', 'New York', 'Bookworm and fitness fanatic.'),
    ('Sam', 'hashed_password_39', 'Male', '1990-07-07', 'Chicago', 'Coffee lover and photographer.'),
    ('Tina', 'hashed_password_40', 'Female', '1993-08-08', 'New York', 'Food critic and outdoor explorer.'),
    ('Noel', 'hashed_password_40', 'Male', '1992-07-28', 'New York', 'Food critic and outdoor explorer.'),
    ('Bella', 'hashed_password_40', 'Female', '2000-01-28', 'Chicago', 'Food critic and outdoor explorer.'),
    ('Jacky', 'hashed_password_40', 'Male', '1999-08-16', 'Seattle', 'Food critic and outdoor explorer.'),
    ('Mimi', 'hashed_password_40', 'Male', '2000-08-23', 'Chicago', 'Food critic and outdoor explorer.'),
    ('Alan', 'hashed_password_40', 'Male', '1997-08-12', 'Chicago', 'Food critic and outdoor explorer.'),
    ('Jason', 'hashed_password_40', 'Male', '1993-12-08', 'Seattle', 'Food critic and outdoor explorer.');

INSERT INTO Interests (InterestName)
VALUES
    ('Cooking'),
    ('Painting'),
    ('Music'),
    ('Photography'),
    ('Traveling'),
    ('Fitness'),
    ('Tech'),
    ('Reading'),
    ('Movies'),
    ('Gaming'),
    ('Fashion'),
    ('Hiking'),
    ('Writing'),
    ('Sports'),
    ('Yoga'),
    ('Film'),
    ('Environment'),
    ('Music Composition'),
    ('Entrepreneurship'),
    ('DIY');

INSERT INTO UserInterests (UserID, InterestID)
VALUES
    (1, 2), -- Alice: Painting
    (2, 1), -- Bob: Cooking
    (3, 5), -- Charlie: Traveling
    (4, 6), -- Diana: Fitness
    (5, 3), -- Eve: Music
    (6, 4), -- Frank: Photography
    (7, 9), -- Grace: Movies
    (8, 10), -- Henry: Gaming
    (9, 11), -- Iris: Fashion
    (10, 12), -- Jack: Hiking
    (11, 13), -- Katie: Writing
    (12, 7), -- Leo: Tech
    (13, 8), -- Mia: Reading
    (14, 6), -- Nate: Fitness
    (15, 14), -- Olivia: Film
    (16, 15), -- Peter: Sports
    (17, 16), -- Quincy: Environment
    (18, 3), -- Rachel: Music
    (19, 17), -- Sam: Yoga
    (20, 18); -- Tina: DIY

INSERT INTO Preferences (UserID, PreferredAgeLower, PreferredAgeUpper, PreferredLocation, PreferredGender, OtherFilters)
VALUES
	(21, 23, 24, 'Vancouver', 'Female', 'Music lover'),
	(22, 23, 26, 'Vancouver', 'Male', 'Music lover'),
    (23, 24, 34, 'Vancouver', 'Female', 'Outdoor enthusiast'),
    (24, 26, 36, 'Vancouver', 'Female', 'DIY and crafts'),
    (1, 25, 35, 'New York', 'Male', 'No smoking'),
    (2, 24, 32, 'Los Angeles', 'Female', 'No pets'),
    (3, 26, 36, 'Chicago', 'Female', 'Must love hiking'),
    (4, 23, 33, 'San Francisco', 'Male', 'Active lifestyle'),
    (5, 27, 37, 'Miami', 'Male', 'Open to adventures'),
    (6, 22, 30, 'Seattle', 'Female', 'Creative and outgoing'),
    (7, 28, 38, 'Boston', 'Male', 'Sports fan'),
    (8, 24, 34, 'Dallas', 'Female', 'Outgoing and athletic'),
    (9, 26, 36, 'Austin', 'Male', 'Dog lover'),
    (10, 22, 32, 'San Diego', 'Female', 'Health-conscious'),
    (11, 25, 35, 'Portland', 'Male', 'Adventurous'),
    (12, 23, 33, 'Chicago', 'Female', 'Coffee lover'),
    (13, 24, 34, 'Houston', 'Male', 'Entrepreneur'),
    (14, 27, 37, 'New York', 'Female', 'Artistic and creative'),
    (15, 22, 32, 'Los Angeles', 'Male', 'Film enthusiast'),
    (16, 29, 39, 'San Francisco', 'Female', 'Tech enthusiast'),
    (17, 30, 40, 'Seattle', 'Male', 'Fitness and food lover'),
    (18, 23, 33, 'Chicago', 'Female', 'Music lover'),
    (19, 24, 34, 'Austin', 'Male', 'Outdoor enthusiast'),
    (20, 26, 36, 'Miami', 'Female', 'DIY and crafts');


INSERT INTO Likes (LikerUserID, LikeeUserID, Timestamp)
VALUES
	(12, 21, '2025-04-05 10:00:00'),
    (3, 21, '2025-04-05 10:00:00'),
    (2, 22, '2025-04-05 10:00:00'),
    (1, 2, '2025-04-05 10:00:00'),
    (2, 3, '2025-04-05 10:05:00'),
    (3, 4, '2025-04-05 10:10:00'),
    (4, 5, '2025-04-05 10:15:00'),
    (5, 6, '2025-04-05 10:20:00'),
    (6, 7, '2025-04-05 10:25:00'),
    (7, 8, '2025-04-05 10:30:00'),
    (8, 9, '2025-04-05 10:35:00'),
    (9, 10, '2025-04-05 10:40:00'),
    (10, 11, '2025-04-05 10:45:00'),
    (11, 12, '2025-04-05 10:50:00'),
    (12, 13, '2025-04-05 10:55:00'),
    (13, 14, '2025-04-05 11:00:00'),
    (14, 15, '2025-04-05 11:05:00'),
    (15, 16, '2025-04-05 11:10:00'),
    (16, 17, '2025-04-05 11:15:00'),
    (17, 18, '2025-04-05 11:20:00'),
    (18, 19, '2025-04-05 11:25:00'),
    (19, 20, '2025-04-05 11:30:00'),
    (20, 1, '2025-04-05 11:35:00');


INSERT INTO Matches (UserID1, UserID2, MatchTimestamp)
VALUES
    (1, 2, '2025-04-05 10:15:00'),
    (2, 3, '2025-04-05 10:20:00'),
    (3, 4, '2025-04-05 10:25:00'),
    (4, 5, '2025-04-05 10:30:00'),
    (5, 6, '2025-04-05 10:35:00'),
    (6, 7, '2025-04-05 10:40:00'),
    (7, 8, '2025-04-05 10:45:00'),
    (8, 9, '2025-04-05 10:50:00'),
    (9, 10, '2025-04-05 10:55:00'),
    (10, 11, '2025-04-05 11:00:00'),
    (11, 12, '2025-04-05 11:05:00'),
    (12, 13, '2025-04-05 11:10:00'),
    (13, 14, '2025-04-05 11:15:00'),
    (14, 15, '2025-04-05 11:20:00'),
    (15, 16, '2025-04-05 11:25:00'),
    (16, 17, '2025-04-05 11:30:00'),
    (17, 18, '2025-04-05 11:35:00'),
    (18, 19, '2025-04-05 11:40:00'),
    (19, 20, '2025-04-05 11:45:00'),
    (20, 1, '2025-04-05 11:50:00');

INSERT INTO Conversations (User1ID, User2ID, ConversationStartTimestamp)
VALUES
    (1, 2, '2025-04-05 10:16:00'),
    (2, 3, '2025-04-05 10:21:00'),
    (3, 4, '2025-04-05 10:26:00'),
    (4, 5, '2025-04-05 10:31:00'),
    (5, 6, '2025-04-05 10:36:00'),
    (6, 7, '2025-04-05 10:41:00'),
    (7, 8, '2025-04-05 10:46:00'),
    (8, 9, '2025-04-05 10:51:00'),
    (9, 10, '2025-04-05 10:56:00'),
    (10, 11, '2025-04-05 11:01:00'),
    (11, 12, '2025-04-05 11:06:00'),
    (12, 13, '2025-04-05 11:11:00'),
    (13, 14, '2025-04-05 11:16:00'),
    (14, 15, '2025-04-05 11:21:00'),
    (15, 16, '2025-04-05 11:26:00'),
    (16, 17, '2025-04-05 11:31:00'),
    (17, 18, '2025-04-05 11:36:00'),
    (18, 19, '2025-04-05 11:41:00'),
    (19, 20, '2025-04-05 11:46:00'),
    (20, 1, '2025-04-05 11:51:00');


INSERT INTO Messages (ConversationID, SenderID, Content, Timestamp)
VALUES
    (1, 1, 'Hi Bob, how are you?', '2025-04-05 10:17:00'),
    (1, 2, 'Hey Alice, I am good! How about you?', '2025-04-05 10:18:00'),
    (2, 2, 'Hi Charlie, nice to match with you!', '2025-04-05 10:22:00'),
    (2, 3, 'Hello Alice, great to chat!', '2025-04-05 10:23:00'),
    (3, 3, 'Hey Diana, how are you?', '2025-04-05 10:27:00'),
    (3, 4, 'Hi Frank, how’s the weather in Seattle?', '2025-04-05 10:28:00'),
    (4, 4, 'Hello Eve, nice to meet you!', '2025-04-05 10:32:00'),
    (4, 5, 'Hey Mia, what have you been up to?', '2025-04-05 10:33:00'),
    (5, 5, 'Hi Rachel, what do you like to do for fun?', '2025-04-05 10:37:00'),
    (5, 6, 'Hi Tina, I love photography too!', '2025-04-05 10:38:00');


INSERT INTO SubscriptionPackages (PackageName, Price, Duration, FeaturesIncluded)
VALUES
    ('Basic', 9.99, 30, 'Access to basic features'),
    ('Premium', 19.99, 30, 'Access to premium features'),
    ('Elite', 29.99, 30, 'All features included with elite support');



INSERT INTO UserSubscriptions (UserID, PackageID, StartDate, EndDate, PaymentDetails)
VALUES
    (1, 1, '2025-03-01', '2025-03-31', 'Credit Card'),
    (2, 2, '2025-03-02', '2025-03-31', 'PayPal'),
    (3, 3, '2025-03-03', '2025-04-02', 'Credit Card'),
    (4, 1, '2025-03-04', '2025-04-03', 'PayPal'),
    (5, 2, '2025-03-05', '2025-04-04', 'PayPal'),
	(6, 1, '2025-04-01', '2025-04-30', 'Credit Card'),
    (7, 2, '2025-04-02', '2025-05-02', 'PayPal'),
    (8, 3, '2025-04-03', '2025-05-03', 'Credit Card'),
    (9, 1, '2025-04-04', '2025-05-04', 'PayPal'),
    (10, 2, '2025-04-05', '2025-05-05', 'Credit Card'),
    (11, 3, '2025-04-06', '2025-05-06', 'PayPal'),
    (12, 1, '2025-04-07', '2025-05-07', 'Credit Card'),
    (13, 2, '2025-04-08', '2025-05-08', 'PayPal'),
    (14, 3, '2025-04-09', '2025-05-09', 'Credit Card'),
    (15, 1, '2025-04-10', '2025-05-10', 'PayPal'),
    (16, 2, '2025-04-11', '2025-05-11', 'Credit Card'),
    (17, 3, '2025-04-12', '2025-05-12', 'PayPal'),
    (18, 1, '2025-04-13', '2025-05-13', 'Credit Card'),
    (19, 2, '2025-04-14', '2025-05-14', 'PayPal'),
    (20, 3, '2025-04-15', '2025-05-15', 'Credit Card');




INSERT INTO LoginLogoutRecords (UserID, LoginTimestamp, LogoutTimestamp)
VALUES
    (1, '2025-04-05 09:00:00', '2025-04-05 11:00:00'),
    (2, '2025-04-05 09:15:00', '2025-04-05 11:15:00'),
    (3, '2025-04-05 09:30:00', '2025-04-05 11:30:00'),
    (4, '2025-04-05 08:00:00', '2025-04-05 10:00:00'), 
    (5, '2025-04-05 08:30:00', '2025-04-05 10:30:00'),
    (6, '2025-04-01 08:30:00', '2025-04-01 10:30:00'),
    (7, '2025-04-02 09:00:00', '2025-04-02 11:00:00'),
    (8, '2025-04-03 09:15:00', '2025-04-03 11:15:00'),
    (9, '2025-04-04 09:30:00', '2025-04-04 11:30:00'),
    (10, '2025-04-05 09:45:00', '2025-04-05 11:45:00'),
    (11, '2025-04-06 10:00:00', '2025-04-06 12:00:00'),
    (12, '2025-04-07 10:30:00', '2025-04-07 12:30:00'),
    (13, '2025-04-08 11:00:00', '2025-04-08 01:00:00'),
    (14, '2025-04-09 11:30:00', '2025-04-09 01:30:00'),
    (15, '2025-04-10 12:00:00', '2025-04-10 02:00:00'),
    (16, '2025-04-11 12:30:00', '2025-04-11 02:30:00'),
    (17, '2025-04-12 13:00:00', '2025-04-12 03:00:00'),
    (18, '2025-04-13 13:30:00', '2025-04-13 03:30:00'),
    (19, '2025-04-14 14:00:00', '2025-04-14 04:00:00'),
    (20, '2025-04-15 14:30:00', '2025-04-15 04:30:00');
    
    
    
INSERT INTO ProfileVisits (ViewerUserID, ViewedUserID, Timestamp)
VALUES
    (1, 2, '2025-04-05 09:05:00'),
    (2, 3, '2025-04-05 09:15:00'),
    (3, 4, '2025-04-05 09:25:00'),
    (1, 3, '2025-04-05 09:10:00'),
    (2, 4, '2025-04-05 09:20:00'),
    (3, 5, '2025-04-05 09:30:00'),
    (4, 6, '2025-04-05 09:40:00'),
    (5, 7, '2025-04-05 09:50:00'),
    (6, 8, '2025-04-05 10:00:00'),
    (7, 9, '2025-04-05 10:10:00'),
    (8, 10, '2025-04-05 10:20:00'),
    (9, 11, '2025-04-05 10:30:00'),
    (10, 12, '2025-04-05 10:40:00'),
    (11, 13, '2025-04-05 10:50:00'),
    (12, 14, '2025-04-05 11:00:00'),
    (13, 15, '2025-04-05 11:10:00'),
    (14, 16, '2025-04-05 11:20:00'),
    (15, 17, '2025-04-05 11:30:00'),
    (16, 18, '2025-04-05 11:40:00'),
    (17, 19, '2025-04-05 11:50:00'),
    (18, 20, '2025-04-05 12:00:00'),
    (19, 1, '2025-04-05 12:10:00'),
    (20, 2, '2025-04-05 12:20:00');



