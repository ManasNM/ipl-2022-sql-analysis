---Step 1: Create Database
CREATE DATABASE IPL_Data_2022;
GO

---Step 2: Use the Database
USE IPL_Data_2022;
GO

---Step 3: Create Table
CREATE TABLE ipl_2022_matches (
    match_id INT,
    match_date DATE,
    venue VARCHAR(255),
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(20),
    match_winner VARCHAR(100),
    result VARCHAR(50),
    won_by VARCHAR(50),
    margin INT,
    eliminator VARCHAR(10),
    method VARCHAR(50),
    umpire1 VARCHAR(100),
    umpire2 VARCHAR(100),
    player_of_the_match VARCHAR(100),
    top_scorer VARCHAR(100),
    highscore INT,
    best_bowling VARCHAR(100),
    best_bowling_figure VARCHAR(20),
    first_ings_score INT,
    second_ings_score INT
);

---Step 4: Bulk Insert Data
BULK INSERT ipl_2022_matches
FROM 'C:\IPLData\Cleaned_IPL_2022.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

---📊 Data Analysis Queries

---1️ Total Matches Played
SELECT COUNT(*) AS total_matches FROM ipl_2022_matches;

---2️ Which Team Won the Most Matches
SELECT match_winner, COUNT(*) AS wins
FROM ipl_2022_matches
WHERE match_winner IS NOT NULL
GROUP BY match_winner
ORDER BY wins DESC;

----3  Top 5 Players of the Match
SELECT player_of_the_match, COUNT(*) AS awards
FROM ipl_2022_matches
GROUP BY player_of_the_match
ORDER BY awards DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

----4 Most Used Venue
SELECT venue, COUNT(*) AS total_matches
FROM ipl_2022_matches
GROUP BY venue
ORDER BY total_matches DESC;

----5 Top High Scorer Players
SELECT TOP 5 top_scorer, highscore
FROM ipl_2022_matches
ORDER BY highscore DESC;


----6 Toss Winner vs Match Winner
SELECT 
    CASE 
        WHEN toss_winner = match_winner THEN 'Yes'
        ELSE 'No'
    END AS toss_equals_match_winner,
    COUNT(*) AS match_count
FROM ipl_2022_matches
WHERE toss_winner IS NOT NULL AND match_winner IS NOT NULL
GROUP BY 
    CASE 
        WHEN toss_winner = match_winner THEN 'Yes'
        ELSE 'No'
    END;

---7 Highest Individual Score
SELECT TOP 1 top_scorer, highscore
FROM ipl_2022_matches
ORDER BY highscore DESC;

---8 Best Bowling Figures
SELECT DISTINCT TOP 5 best_bowling, best_bowling_figure
FROM ipl_2022_matches
WHERE best_bowling IS NOT NULL
ORDER BY best_bowling_figure DESC;

--- 9 Win Percentage by Team
SELECT match_winner AS team, 
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ipl_2022_matches) AS win_percentage
FROM ipl_2022_matches
WHERE match_winner IS NOT NULL
GROUP BY match_winner
ORDER BY win_percentage DESC;

--- 10. Toss Decision Impact
SELECT toss_decision, COUNT(*) AS matches
FROM ipl_2022_matches
GROUP BY toss_decision
ORDER BY matches DESC;

---11. Most Competitive Matches (Smallest Win Margin)
SELECT TOP 5 match_id, team1, team2, won_by, margin
FROM ipl_2022_matches
WHERE margin IS NOT NULL
ORDER BY margin ASC;

---12. Teams Scoring the Highest in 1st Innings
SELECT TOP 5 team1 AS team, first_ings_score
FROM ipl_2022_matches
ORDER BY first_ings_score DESC;





