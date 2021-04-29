DROP TABLE IF EXISTS train_lines CASCADE;
CREATE TABLE train_lines (
  line int NOT NULL,
  name varchar(30) DEFAULT NULL,
  type char(1) DEFAULT NULL,
  description varchar(30) DEFAULT NULL,
  PRIMARY KEY (line)
);

INSERT INTO train_lines VALUES (1,'Central-Bankstown-Liverpool','S',NULL),(11,'Strathfield-Bankstown-Central','S',NULL),(2,'Hurtsville-BondiJunction','S',NULL),(3,'Epping-NSyd-Central','R',NULL),(13,'Epping-Strathfield-Central','R',NULL),(4,'Lidcome-OlympicPark','S',NULL),(5,'Clyde-Carlingford','S',NULL),(6,'Glenfield-Blacktown','S',NULL),(7,'Glenfield-Airport-Central','S',NULL),(9,'M-Central-Granville-Liverpool','S',NULL),(8,'M-Central-lidcome-Glenfield','S',NULL),(10,'Blacktown-Central-Chatswood','S',NULL);