CREATE TABLE Airplane (
  airplane_id SERIAL PRIMARY KEY,
  model VARCHAR(50) NOT NULL,
  manufacturer VARCHAR(50) NOT NULL,
  capacity INT NOT NULL
);

CREATE INDEX idx_airplane_id ON Airplane(airplane_id);
