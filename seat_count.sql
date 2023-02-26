create database LS_elections;

use LS_elections;

-- Total seats won by parties

with total_seats as 
( 
select party, sum(winner) as seats
from loksabha_elections
group by 1
order by seats desc
)
select *
from total_seats
where seats > 10
union all
select 'others' as party, sum(seats) as seats  
from total_seats
where seats < 10;