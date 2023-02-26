WITH win_party
     AS (SELECT state,
                constituency,
                party,
                vote_percent
         FROM   loksabha_elections
         WHERE  winner = 1),
     lose_party
     AS (SELECT state,
                constituency,
                party,
                vote_percent
         FROM   loksabha_elections
         WHERE  winner = 0)
SELECT w.state                                       AS state,
       w.constituency,
       w.party                                       AS win,
       l.party                                       AS lost,
       w.vote_percent                                AS win_percent_votes,
       l.vote_percent                                AS lost_percent_votes,
       Round(( w.vote_percent - l.vote_percent ), 2) AS vote_percent_diff
FROM   win_party w
       JOIN lose_party l
         ON w.constituency = l.constituency
            AND w.state = l.state
ORDER  BY 1,
          2,
          vote_percent_diff; 