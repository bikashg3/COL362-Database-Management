--Players in IPL
CREATE TABLE player (
player_id INT,
player_name VARCHAR(100),
dob DATE,
batting_hand VARCHAR(100),
bowling_skill VARCHAR(100),
country_name VARCHAR(100),
CONSTRAINT player_pk PRIMARY KEY (player_id)
);

--Teams in IPL
CREATE TABLE team (
team_id INT,
name VARCHAR(100),
CONSTRAINT team_pk PRIMARY KEY (team_id)
);

--Match in IPL
CREATE TABLE match (
match_id INT,
team_1 INT,
team_2 INT,
match_date DATE,
season_id INT,
venue VARCHAR(200),
toss_winner INT,
toss_decision VARCHAR(100),
win_type VARCHAR(100),
win_margin INT,
outcome_type VARCHAR(100),
match_winner INT,
man_of_the_match INT,
CONSTRAINT match_pk PRIMARY KEY (match_id),
FOREIGN KEY (team_1) references team(team_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (team_2) references team(team_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (match_winner) references team(team_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (man_of_the_match) references player(player_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT chk_season CHECK (season_id BETWEEN 1 AND 9)
);

--Player in match of IPL
CREATE TABLE player_match (
match_id INT,
player_id INT,
role VARCHAR(50),
team_id INT,
CONSTRAINT player_match_pk PRIMARY KEY (match_id,player_id),
FOREIGN KEY (match_id) references match(match_id),
FOREIGN KEY (player_id) references player(player_id),
FOREIGN KEY (team_id) references team(team_id)
);

-- ball_by_ball in match of IPL
CREATE TABLE ball_by_ball (
match_id int,
over_id int,
ball_id int,
innings_no int,
team_batting int,
team_bowling int,
striker_batting_position int,
striker int,
non_striker int,
bowler int,
CONSTRAINT ball_by_ball_pk PRIMARY KEY (match_id,over_id,ball_id,innings_no),
FOREIGN KEY (match_id) references match(match_id),
FOREIGN KEY (team_batting) references team(team_id),
FOREIGN KEY (team_bowling) references team(team_id),
FOREIGN KEY (striker) references player(player_id),
FOREIGN KEY (non_striker) references player(player_id),
FOREIGN KEY (bowler) references player(player_id),
CONSTRAINT chk_over_id CHECK (over_id BETWEEN 1 AND 20),
CONSTRAINT chk_ball_id CHECK (ball_id BETWEEN 1 AND 9),
CONSTRAINT chk_innings_no CHECK (innings_no BETWEEN 1 AND 4)
);


-- batsmen_scored in IPL
CREATE TABLE batsman_scored (
match_id int,
over_id int,
ball_id int,
runs_scored int,
innings_no int,
CONSTRAINT batsman_scored_pk PRIMARY KEY (match_id,over_id,ball_id,innings_no),
FOREIGN KEY (match_id) references match(match_id)
--FOREIGN KEY (over_id) references ball_by_ball(over_id),
--FOREIGN KEY (ball_id) references ball_by_ball(ball_id),
--FOREIGN KEY (innings_no) references ball_by_ball(innings_no)
);

-- wicket_taken in IPL
CREATE TABLE wicket_taken (
match_id int,
over_id int,
ball_id int,
player_out int,
kind_out VARCHAR(100),
innings_no int,
CONSTRAINT wicket_taken_pk PRIMARY KEY (match_id,over_id,ball_id,innings_no),
FOREIGN KEY (match_id) references match(match_id),
FOREIGN KEY (player_out) references player(player_id)
);

-- extra_runs in IPL
CREATE TABLE extra_runs (
match_id int,
over_id int,
ball_id int,
extra_type VARCHAR(100),
extra_runs int,
innings_no int,
CONSTRAINT extra_runs_pk PRIMARY KEY (match_id,over_id,ball_id,innings_no),
FOREIGN KEY (match_id) references match(match_id)
);
