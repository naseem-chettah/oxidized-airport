CREATE TABLE Airport (
  airport_id SERIAL PRIMARY KEY,
  city VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  IATA VARCHAR(3) UNIQUE NOT NULL
);

CREATE INDEX idx_airport_id ON Airport(airport_id);
