--1--

SELECT player_name FROM player WHERE country_name ='England' AND batting_hand = 'Left-hand bat' ORDER BY player_name ASC ;

--2--

SELECT foo.player_name,foo.player_age FROM  (SELECT  cast(date_part('year',age(timestamp '2018-02-12',dob)) as int) AS player_age,player_name from player where cast(date_part('year',age(timestamp '2018-02-12',dob)) as int)>=28 and bowling_skill='Legbreak googly' ORDER BY player_age DESC, player_name ASC ) as foo;

--3--

SELECT match_id,toss_winner FROM match WHERE toss_decision='bat' ORDER BY match_id;

--4--

SELECT a.over_id, sum(COALESCE(runs_scored,0) + COALESCE(extra_runs,0)) as runs_scored from ball_by_ball a LEFT JOIN batsman_scored b ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(b.match_id,b.over_id,b.ball_id,b.innings_no) LEFT JOIN extra_runs e ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(e.match_id,e.over_id,e.ball_id,e.innings_no) INNER JOIN match d ON a.match_id=d.match_id WHERE d.match_id=335987 GROUP BY a.over_id,a.innings_no HAVING sum(COALESCE(runs_scored,0) + COALESCE(extra_runs,0))<=7 ORDER BY 2 DESC,1 ASC;

--5--

SELECT player_name from player,wicket_taken where player.player_id = wicket_taken.player_out and wicket_taken.kind_out='bowled' GROUP BY player_id ORDER BY player_name;

--6--

SELECT a.match_id, b.name AS team_1 ,c.name AS team_2,d.name AS winning_team_name,win_margin from match a left outer join team b on a.team_1=b.team_id left outer join team c on a.team_2=c.team_id left outer join team d on a.match_winner=d.team_id WHERE win_margin>=60 AND win_type='runs' GROUP BY a.match_id,b.name,c.name,d.name ORDER BY win_margin ASC, 1 ASC;

--7--

SELECT player_name FROM player WHERE cast(date_part('year',age(timestamp '2018-02-12',dob)) as int)<30 and batting_hand='Left-hand bat' ORDER BY  player_name ASC ;

--8--

SELECT a.match_id, SUM(COALESCE(runs_scored,0) + COALESCE(extra_runs,0)) as total_runs from ball_by_ball a LEFT JOIN batsman_scored b ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(b.match_id,b.over_id,b.ball_id,b.innings_no) LEFT JOIN extra_runs e ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(e.match_id,e.over_id,e.ball_id,e.innings_no) GROUP BY a.match_id ORDER BY 1 ASC;

--9--

with query4 as (with query3 as (with query2 as (WITH query1 as (SELECT a.match_id as match_id,a.over_id,a.innings_no,(SUM(COALESCE(runs_scored,0) + COALESCE(extra_runs,0))) as total_runs from ball_by_ball a LEFT JOIN batsman_scored b ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(b.match_id,b.over_id,b.ball_id,b.innings_no) LEFT JOIN extra_runs e ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(e.match_id,e.over_id,e.ball_id,e.innings_no) GROUP BY a.match_id,a.over_id,a.innings_no  ORDER BY 1 ASC,2 ASC) select  a.match_id,a.over_id,a.innings_no,max(total_runs) as total_runs from query1 a group by a.match_id,a.over_id,a.innings_no order by 1 ) select p.match_id,over_id,p.innings_no,p.total_runs from query2 as p inner join (select match_id,max(total_runs) as total_runs from query2 group by match_id) q on concat(p.match_id,p.total_runs)=concat(q.match_id,q.total_runs) ) select distinct a.match_id,a.over_id,a.total_runs as maximum_runs,c.player_name from query3 a inner join ball_by_ball b on concat(a.match_id,a.over_id,a.innings_no)=concat(b.match_id,b.over_id,b.innings_no) inner join player c on b.bowler=c.player_id order by 1 asc,2 asc) SELECT match_id,maximum_runs,player_name from query4;

--10--

SELECT a.player_name, sum(case when kind_out='run out' then 1 else 0 end) number from player a left join wicket_taken b on a.player_id=b.player_out group by 1 order by 2 desc,1 asc;

--11--

SELECT kind_out as out_type,count(*) as number FROM wicket_taken group by kind_out ORDER BY 2 DESC, 1 ASC;

--12--

SELECT team.name AS name,count(*) as number FROM match, player_match , team WHERE man_of_the_match=player_match.player_id AND player_match.team_id=team.team_id AND match.match_id=player_match.match_id GROUP BY team.name ORDER BY 1 ASC;

--13--

WITH mytable as (SELECT venue,sum(total) as total FROM (SELECT match.venue,count(extra_runs)as total from extra_runs,match where extra_type='wides' and match.match_id=extra_runs.match_id GROUP BY match.match_id,match.venue ORDER BY match.venue) as foo GROUP BY venue) SELECT venue FROM mytable where total=(select max(total) from mytable) ORDER BY venue ASC limit 1;

--14--

SELECT venue FROM (SELECT venue,count(*) as total_wins from match where (toss_decision='field' and match_winner=toss_winner) OR (toss_decision='bat' and match_winner!=toss_winner) GROUP BY venue ORDER BY 2 DESC, 1 ASC) foo ;

--15--

WITH subquery3 as (WITH subquery2 as (WITH subquery as (WITH query as (SELECT a.over_id, sum(COALESCE(runs_scored,0) + COALESCE(extra_runs,0)) as runs_scored,count(player_out),bowler,d.match_id from ball_by_ball a LEFT JOIN batsman_scored b ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(b.match_id,b.over_id,b.ball_id,b.innings_no)  LEFT JOIN extra_runs e ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(e.match_id,e.over_id,e.ball_id,e.innings_no) LEFT JOIN wicket_taken f ON CONCAT(a.match_id,a.over_id,a.ball_id,a.innings_no)=CONCAT(f.match_id,f.over_id,f.ball_id,f.innings_no) INNER JOIN match d ON a.match_id=d.match_id GROUP BY a.bowler,a.innings_no,a.over_id,d.match_id ORDER BY 4 ASC) SELECT bowler,sum(count) as wickets,sum(runs_scored) as runs_given from query GROUP BY bowler  ORDER BY 1) SELECT *,min(round((runs_given/wickets),3)) as average from subquery where wickets>0 GROUP BY subquery.bowler,subquery.wickets,subquery.runs_given ORDER BY 4,1 ASC) SELECT player_name,average from player,subquery2 where player.player_id=subquery2.bowler ORDER BY 2) SELECT player_name FROM subquery3 where average=(select min(average) from subquery3) ORDER BY 1 ASC;

--16--

SELECT d.player_name,c.name FROM match a INNER JOIN player_match b ON a.match_id=b.match_id INNER JOIN player d ON d.player_id=b.player_id INNER JOIN team c ON c.team_id=b.team_id WHERE b.team_id=a.match_winner AND b.role='CaptainKeeper' ORDER BY 1 ASC,2 ASC;

--17--

WITH foo as (SELECT c.player_name, sum(runs_scored)as runs_scored,a.match_id from ball_by_ball a inner join batsman_scored b on concat(a.match_id,a.over_id,a.ball_id,a.innings_No)=concat(b.match_id,b.over_id,b.ball_id,b.innings_no) inner join player c on a.striker=c.player_id  inner join match d on a.match_id=d.match_id  group by c.player_name,a.match_id ORDER BY 1 DESC, 2 ASC ) SELECT player_name,sum(runs_scored) as runs_scored FROM foo t where exists (SELECT * from foo where player_name=t.player_name and runs_scored>=50) GROUP BY player_name order by 2 desc, 1 asc ;

--18--

WITH query as (SELECT c.player_name,a.match_id,a.team_batting,sum(runs_scored) as runs_scored FROM ball_by_ball as a INNER JOIN batsman_scored b on concat(a.match_id,a.over_id,a.ball_id,a.innings_no)= concat(b.match_id,b.over_id,b.ball_id,b.innings_no) inner join player c on a.striker=c.player_id inner join match d on a.match_id=d.match_id group by a.match_id,c.player_name,a.team_batting ORDER BY 4 DESC) SELECT player_name FROM (SELECT * FROM query where runs_scored>=100 ORDER BY match_id) AS p,match WHERE p.match_id=match.match_id and p.team_batting!=match.match_winner ORDER BY 1 ASC;

--19--

SELECT match_id,venue FROM match a where (team_1=1 OR team_2=1) AND match_winner!=1 ORDER BY 1 ASC;

--20--

WITH subquery as (WITH query as (SELECT c.player_name,a.match_id,a.team_batting,sum(runs_scored) as runs_scored FROM ball_by_ball as a INNER JOIN batsman_scored b on concat(a.match_id,a.over_id,a.ball_id,a.innings_no)=concat(b.match_id,b.over_id,b.ball_id,b.innings_no) inner join player c on a.striker=c.player_id inner join match d on a.match_id=d.match_id and d.season_id=5 group by a.match_id,c.player_name,a.team_batting ORDER BY 4 DESC) SELECT player_name,sum(runs_scored) as runs_scored,count(*) as batted_count,round(sum(runs_scored)/count(*),3) as average from query GROUP BY player_name order by 4 desc,1 asc) SELECT player_name from subquery limit 10;

--21--

WITH subquery3 as (WITH subquery2 as (WITH subquery as (WITH query as (SELECT c.player_name,a.match_id,a.team_batting,sum(runs_scored) as runs_scored,c.country_name FROM player as c left join ball_by_ball a on a.striker=c.player_id left JOIN batsman_scored b on concat(a.match_id,a.over_id,a.ball_id,a.innings_no)=concat(b.match_id,b.over_id,b.ball_id,b.innings_no) left join match d on a.match_id=d.match_id group by a.match_id,c.player_name,a.team_batting,c.country_name ORDER BY 4 DESC) SELECT player_name,coalesce(sum(runs_scored),0) as runs_scored,count(*) as batted_count,country_name from query GROUP BY player_name,country_name order by 2 desc) SELECT player_name,round(runs_scored/batted_count,3) as average,batted_count,country_name from subquery ORDER BY 2 DESC ) SELECT sum(average) as total_runs,count(*) as total_country_players,country_name,round(sum(average)/count(*),3) as country_average from subquery2 GROUP BY country_name ORDER BY 4 desc,3 ASC) SELECT country_name from subquery3 where (country_average >= (SELECT DISTINCT(country_average) FROM subquery3 as s1 GROUP BY country_average ORDER BY country_average DESC limit 1 OFFSET 4 ) );
