-- creating a data base to work with

CREATE database election;

USE election;

-- to get overview of the table

SELECT * FROM elections_ls;

-- Most number of seats won by party in 2014 elections

SELECT state, party, count(winner) AS total_seats
FROM elections_ls
WHERE winner = 1
GROUP BY 1, 2
ORDER BY 1, 2;

-- total number of voters according to the staes, this data can help in targetting the specific states where the population is more
-- which will help in getting targetting more number of seats according to the state  

SELECT DISTINCT(state), SUM(total_electors) AS state_electors
FROM elections_ls
WHERE winner = 1
GROUP BY 1
ORDER BY 2 DESC;

-- check for the constituency where the diffeence in vote share was narrow less than 5 %
-- This data can help in identifying the constituencies where the elections fought had good contest and hence thse region
-- become vulnerable and should be focussed more in upcoming elections
 
WITH temp_table AS
(SELECT state, constituency, party, over_total_electors_in_constituency AS percent_votes,
MAX(over_total_electors_in_constituency) OVER w AS max_percent,
DENSE_RANK() OVER w AS party_rank 
FROM elections_ls
WINDOW w AS (PARTITION BY constituency ORDER BY over_total_electors_in_constituency DESC
				RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
)
SELECT *, ROUND((max_percent - percent_votes),2) AS diff_votes
FROM temp_table
WHERE party_rank = 2 AND ROUND((max_percent - percent_votes),2) <= 5
GROUP BY state, constituency
ORDER BY state;
			
 -- check for the regional parties with good share of votes with whom alliance can be made
 -- this data can help with the vote share of small parties contesting in their respective regions
 -- Talks can be initiated with them to form alliance
 
 WITH temp_table AS
(SELECT state, constituency, party, over_total_electors_in_constituency AS percent_votes,
DENSE_RANK() OVER w AS party_rank 
FROM elections_ls
WINDOW w AS (PARTITION BY constituency ORDER BY over_total_electors_in_constituency DESC
				RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
)
SELECT *
FROM temp_table
WHERE party_rank > 2
ORDER BY 1, 2;

-- check for the states and constituency where elected person has good education
-- This data will help in understanding the people if they are actively thinking about the contestants education
 
SELECT state, constituency, party, education, winner
FROM elections_ls
WHERE winner = 1 AND (education LIKE '%graduate%' OR education LIKE '%doctorate%')
ORDER BY 1,2;
 
 
 -- elected people in the constituency that had more assets as compared to their competitors
 -- There is no denying fact that contestants use power of money to get the votes
 -- this data shows that elected contestant had more money as compared to his competitor
 
WITH temp_table AS 
(SELECT state, constituency, party, winner,assets,
RANK() OVER(PARTITION BY constituency ORDER BY assets DESC
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS assets_rank
FROM elections_ls
)
SELECT * 
FROM temp_table
WHERE winner = 1 AND assets_rank = 1
ORDER BY 1, 2;
                
                

                
                