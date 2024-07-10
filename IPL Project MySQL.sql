use ipl;
-- WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS? -- 
select player_of_match, count( player_of_match) as awards_count
from matches
group by player_of_match
order by 2 desc
limit 5;

-- HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON? --
select season, winner as team, count(*) as mathces_won
from matches
group by winner, season
order by 1 asc;

-- WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET? --
select avg(strike_rate) from
(select batsman, (sum(total_runs)/count(ball))*100 as strike_rate 
from deliveries 
group by batsman) as batsman_state;

-- WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING SECOND? --
select batting_first, count(*) as matches_won from
(select case when win_by_runs > 0 then team1 else team2 end as batting_first from matches
where winner!='Tie') as batting_first_team group by batting_first order by 2 desc;

-- WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)? --
select batsman, (sum(batsman_runs)*100/count(*)) as strike_rate
from deliveries
group by batsman
having sum(batsman_runs) >= 200
order by 2 desc
limit 1;

-- HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'? -- 
select batsman, count(player_dismissed) as dismissed_player
from deliveries
where player_dismissed is not null and bowler = 'SL Malinga'
group by batsman
order by 2;

-- WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXESCOMBINED) HIT BY EACH BATSMAN? -- 
select batsman, avg(case when batsman_runs=4 or batsman_runs=6 then 1 else 0 end)*100 as avg_boundaries
from deliveries
group by batsman;

-- WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?
select season,batting_team, avg(fours+sixes) as avg_boundaries
from(select season,match_id,batting_team,sum(case when batsman_runs = 4 then 1 else 0 end) as fours, sum(case when batsman_runs = 6 then 1 else 0 end) as sixes
from deliveries, matches where deliveries.match_id = matches.id
group by season,match_id,batting_team) as four_six_sum
group by season,batting_team; 

-- WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON? --
select season,batting_team,max(total_runs) as highest_partnership
from(select season,batting_team,partnership,sum(total_runs) as total_runs
from(select season,match_id,batting_team,
sum(batsman_runs) as partnership,sum(batsman_runs)+sum(extra_runs) as total_runs
from deliveries,matches where deliveries.match_id=matches.id
group by season,match_id,batting_team) as team_scores
group by season,batting_team,partnership) as highest_partnership
group by season,batting_team; 

-- HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH? -- 
select m.id as match_no,d.bowling_team,
sum(d.extra_runs) as extras
from matches as m
join deliveries as d on d.match_id=m.id
where extra_runs>0
group by m.id,d.bowling_team;

-- WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE MATCH? --
select m.id as match_no,d.bowler,count(win_by_wickets) as wickets_taken
from matches as m
join deliveries as d on d.match_id=m.id
where d.player_dismissed is not null
group by m.id,d.bowler
order by wickets_taken desc
limit 1;

-- HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?
select m.city,case when m.team1=m.winner then m.team1
when m.team2=m.winner then m.team2
else 'draw'
end as winning_team,
count(*) as wins
from matches as m
join deliveries as d on d.match_id=m.id
where m.result!='Tie'
group by m.city,winning_team;

-- HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON? --
select season, toss_winner, count(toss_winner) as toss_win
from matches
group by  season, toss_winner;

-- HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD? --
select player_of_match,count(player_of_match) as total_wins
from matches 
where player_of_match is not null
group by player_of_match
order by total_wins desc;

-- WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH? --
select m.id,d.inning,
avg(d.total_runs) as average_runs_per_over
from matches as m
join deliveries as d on d.match_id=m.id
group by m.id,d.inning;

-- WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH? --
select m.season,m.id as match_no,d.batting_team,
sum(d.total_runs) as total_score
from matches as m
join deliveries as d on d.match_id=m.id
group by m.season,m.id,d.batting_team
order by total_score desc
limit 1;

-- WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH? --
select d.batsman,m.id,
sum(d.batsman_runs) as total_score
from matches as m
join deliveries as d on d.match_id=m.id
group by d.batsman,m.id
order by total_score desc
limit 1;


