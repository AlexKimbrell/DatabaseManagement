CREATE DATABASE basketball;
USE basketball;


CREATE TABLE IF NOT EXISTS season_stats (
	 Season YEAR, 
     Player_Name VARCHAR(45),
     Player_Position VARCHAR(10),
     Player_Age INT,
     Team VARCHAR(45),
     Games_Played INT,
     Player_Efficiency_Rating DOUBLE,
     True_Shooting_Percentage DOUBLE,
	 Win_Shares DOUBLE,
     Plus_Minus DOUBLE,
     Field_Goals INT,
     Field_Goal_Attempts INT,
     Field_Goal_Percentage DOUBLE,
     Free_Throws INT,
     Free_Throw_Attempts INT,
     Free_Throw_Percentage DOUBLE,
     Rebounds INT,
     Assists INT, 
     Steals INT,
     Blocks INT,
     Turnovers INT,
     Points INT,
     KNB_Score DOUBLE
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS players (
	Player_Name VARCHAR(45),
    Height INT,
    Weight INT,
    College VARCHAR(75)
) ENGINE=INNODB;

-- Create Index
CREATE INDEX Sort_By_Name ON season_stats(Player_Name);

-- Get the total KNB Score for every player's career
SELECT S.Player_Name, SUM(S.KNB_Score) AS 'Total KNB Score'
FROM season_stats S
GROUP BY S.Player_Name
ORDER BY SUM(S.KNB_Score) DESC;


-- Get the total number of players for each college
SELECT college, COUNT(P.Player_Name) AS 'NBA Players', SUM(KNB_Score) AS 'College KNB'
FROM players P JOIN season_stats S ON P.Player_Name=S.Player_Name
WHERE P.college != ''
GROUP BY college
ORDER BY COUNT(P.Player_Name) DESC;


-- Total KNB Score for each college
SELECT college, SUM(S.KNB_Score) AS 'Total Score'
FROM players P JOIN season_stats S ON P.Player_Name=S.Player_Name
WHERE P.college != ''
GROUP BY college
ORDER BY SUM(S.KNB_Score) DESC;


-- KNB Score Per Capita for each college
SELECT college, (SUM(S.KNB_Score) / COUNT(S.Player_Name)) AS 'KNB Per Capita', COUNT(S.Player_Name) AS 'NBA Players'
FROM players P JOIN season_stats S ON P.Player_Name=S.Player_Name
WHERE P.college != '' 
GROUP BY college
ORDER BY (SUM(S.KNB_Score) / COUNT(S.Player_Name)) DESC;


-- Colleges that produce the best average player under 180 centimeters
SELECT college, (SUM(S.KNB_Score) / COUNT(S.Player_Name)) AS 'KNB Per Capita', COUNT(S.Player_Name) AS 'NBA Players'
FROM players P JOIN season_stats S ON P.Player_Name=S.Player_Name
WHERE P.college != '' AND P.height < 180 
GROUP BY college
ORDER BY (SUM(S.KNB_Score) / COUNT(S.Player_Name)) DESC;


-- Colleges that produce best average player over 130 kg (~285 pounds)
SELECT college, (SUM(S.KNB_Score) / COUNT(S.Player_Name)) AS 'KNB Per Capita', COUNT(S.Player_Name) AS 'NBA Players'
FROM players P JOIN season_stats S ON P.Player_Name=S.Player_Name
WHERE P.college != '' AND P.weight > 130
GROUP BY college
ORDER BY (SUM(S.KNB_Score) / COUNT(S.Player_Name)) DESC;


-- NBA Players who had the highest average KNB Score for their career
SELECT S.Player_Name, COUNT(S.Season) AS 'Seasons', AVG(KNB_Score) AS 'Avg KNB'
FROM season_stats S
GROUP BY S.Player_Name
HAVING COUNT(S.Season) >=5
ORDER BY S.KNB_Score DESC;


-- NBA Players who had the highest PER for their career
SELECT S.Player_Name, COUNT(S.Season) AS 'Seasons', AVG(Player_Efficiency_Rating) AS 'Avg PER'
FROM season_stats S
GROUP BY S.Player_Name
HAVING COUNT(S.Season) >= 5
ORDER BY S.Player_Efficiency_Rating DESC;


-- NBA Players who did not go to an American College
SELECT * FROM players WHERE college = '';



SELECT * FROM season_stats LIMIT 10;

SELECT *
FROM season_stats
WHERE True_Shooting_Percentage > 0.500 AND Field_Goal_Attempts >= 100
GROUP BY Season
ORDER BY Season DESC;






-- Drop Index
DROP INDEX Sort_By_Name ON season_stats;
