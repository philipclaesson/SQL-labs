DROP TABLE IF EXISTS "Sport" CASCADE;
CREATE TABLE "Sport" (
	"Sport_name" text NOT NULL,
	Constraint "Sport_name_pkey" Primary Key ("Sport_name")
);

DROP TABLE IF EXISTS "Sport2" CASCADE;
CREATE TABLE "Sport2" (
	"Sport_name" text NOT NULL,
	"Hej" text references Sport(sport_name) NOT NULL,
	Constraint "Sport_name_pkey2" Primary Key ("Sport_name")
);
