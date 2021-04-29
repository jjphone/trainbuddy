DROP TABLE IF EXISTS train_time;

CREATE TABLE train_time (
  line int NOT NULL,
  train_dir int NOT NULL DEFAULT 0,
  s_code char(4) NOT NULL DEFAULT '',
  train_no char(6) NOT NULL DEFAULT '',
  stop_time char(5) DEFAULT NULL,
  PRIMARY KEY (line,train_dir,s_code,train_no),
  FOREIGN KEY (line, train_dir, train_no) REFERENCES train_seq(line, dir, train_no)
) ;