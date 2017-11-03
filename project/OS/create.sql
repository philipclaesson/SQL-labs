DROP TABLE IF EXISTS "Competitor" CASCADE;
CREATE TABLE "Competitor" (
	"Competitor_id" integer,
	"Team_id" integer references Team(Team_id),
	"Competitor_name" text,
	"Nation_name" text references National_Team(Nation_name) NOT NULL,
	"Sport_name" text references Sport(Sport_name),
	"Position" text,
	Constraint "Competitor_id_pkey" Primary Key ("Competitor_id")
);

DROP TABLE IF EXISTS "Sport" CASCADE;
CREATE TABLE "Sport" (
	"Sport_name" text NOT NULL,
	Constraint "Sport_name_pkey" Primary Key ("Sport_name")
);

DROP TABLE IF EXISTS "Medal" CASCADE;
CREATE TABLE "Medal" (
	"Sport_name" text references Sport(sport_name),
	"Medal_val" varchar(6) NOT NULL,
	"Team_id" integer references Teams(team_id),
	"Competitor_id" integer references Competitor(Competitor_id),

);

DROP TABLE IF EXISTS "Competition" CASCADE;
CREATE TABLE "Competition" (
	"Competition_name" integer NOT NULL,
	"Sport_name" text references Sport(sport_name),
	"Arena_name" text NOT NULL,
	"Place" text NOT NULL,
	DATE timestamp with time zone NOT NULL,
	TIMESTAMP timestamp with time zone NOT NULL,
	"Duration" integer NOT NULL,
	Constraint "Competition_name_pkey" Primary Key ("Competition_name")
);

DROP TABLE IF EXISTS "National_team" CASCADE;
CREATE TABLE "National_team" (
	"Nation_name" text NOT NULL,
	Constraint "Nation_pkey" PRIMARY KEY ("Nation_name")
); 

DROP TABLE IF EXISTS "Official" CASCADE;
CREATE TABLE "Official" (
	"Official_id" integer NOT NULL,
	"Official_name" text NOT NULL,
	Constraint "Officials_pkey" Primary Key ("Official_id")
);

DROP TABLE IF EXISTS "Team" CASCADE;
CREATE TABLE "Team" (
	"Team_id" integer NOT NULL,
	"Sport_name" text references Sport(sport_name),
	"Nation_name" text references National_team(Nation_name),
	Constraint "Team_pkey" Primary Key ("Team_id")
);

DROP TABLE IF EXISTS "Competitor_Competition" CASCADE;
CREATE TABLE "Competitor_Competition" (
	"Competitor_id" int references Competitor(Competitor_id),
	"Competition_name" text references Competition(Competition_name),
);

DROP TABLE IF EXISTS "Offical_Competition" CASCADE;
CREATE TABLE "Offical_Competition" (
	"Official_id" int references Official(Official_id),
	"Competition_name" text references Competition(Competition_name),
);

DROP TABLE IF EXISTS "Offical_Sport" CASCADE;
CREATE TABLE "Offical_Sport" (
	"Official_id" int references Official(Official_id),
	"Sport_name" text references Sport(Sport_name),
);
