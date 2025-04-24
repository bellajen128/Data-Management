-- 1) Simple query
--   List all users in San Francisco
SELECT UserId, Username, Age, GenderIdentity
FROM Users
WHERE Location = 'San Francisco';


-- 2) Aggregate
--   Count users by gender
SELECT GenderIdentity,
       COUNT(*) AS UserCount
FROM Users
GROUP BY GenderIdentity;


-- Inner join: users with location preferences
SELECT u.Username, p.PreferredLocation
FROM Users u
INNER JOIN Preferences p
  ON u.UserID = p.UserID;

-- Left outer join: every user along with their preference details 
SELECT
  u.UserID,
  u.Username,
  p.PreferredAgeLower,
  p.PreferredAgeUpper,
  p.PreferredLocation,
  p.PreferredGender
FROM Users u
LEFT JOIN Preferences p
  ON u.UserID = p.UserID;



-- 4) Nested query
--   Find usernames of everyone liked by user #4
SELECT Username
FROM Users
WHERE UserID IN (
  SELECT LikeeUserID
  FROM Likes
  WHERE LikerUserID = 4
);


-- 5) Correlated query
--   Show each user with the number of likes they’ve received
SELECT u.Username,
       (SELECT COUNT(*)
        FROM Likes l
        WHERE l.LikeeUserID = u.UserID
       ) AS LikesReceived
FROM Users u;

select u.username, count(l.LikeID) as LikesReceived
from user as u inner join likes as l
on l.LikeeUserID = u.UserID




-- 6) >= ALL / > ANY / EXISTS / NOT EXISTS
--   a) Users older than or equal to every other user
SELECT Username, Age
FROM Users
WHERE Age >= ALL (SELECT Age FROM Users);

--   b) Users older than at least one user in Chicago
SELECT Username, Age
FROM Users
WHERE Age > ANY (
  SELECT Age
  FROM Users
  WHERE Location = 'Chicago'
);

--   c) Users who have at least one match
SELECT Username
FROM Users u
WHERE EXISTS (
  SELECT 1
  FROM Matches m
  WHERE m.UserID1 = u.UserID OR m.UserID2 = u.UserID
);

--   d) Users who’ve never sent a message
SELECT Username
FROM Users u
WHERE NOT EXISTS (
  SELECT 1
  FROM Messages m
  WHERE m.SenderID = u.UserID
);


-- 7) Set operation (UNION)
--   List all male or female usernames (deduplicated)
SELECT Username
FROM Users
WHERE GenderIdentity = 'Male'
UNION
SELECT Username
FROM Users
WHERE GenderIdentity = 'Female';


-- 8) Subquery in SELECT
--   Show each user’s profile view count
SELECT u.Username,
       (SELECT COUNT(*) 
        FROM ProfileVisits pv
        WHERE pv.ViewedUserID = u.UserID
       ) AS ViewCount
FROM Users u;


-- 9) Subquery in FROM
--   Top 5 most‐liked users
SELECT sq.UserID, u.Username, sq.TotalLikes
FROM (
  SELECT LikeeUserID AS UserID,
         COUNT(*)    AS TotalLikes
  FROM Likes
  GROUP BY LikeeUserID
) AS sq
JOIN Users u ON u.UserID = sq.UserID
ORDER BY sq.TotalLikes DESC
LIMIT 5;
