CREATE TABLE IF NOT EXISTS Flight (
  flight_id SERIAL PRIMARY KEY,
  airplane_id INT NOT NULL REFERENCES Airplane(airplane_id),
  flight_number VARCHAR(10) UNIQUE NOT NULL,
  departure_airport_id INT NOT NULL REFERENCES Airport(airport_id),
  arrival_airport_id INT NOT NULL REFERENCES Airport(airport_id),
  departure_time TIMESTAMPTZ NOT NULL,
  arrival_time TIMESTAMPTZ CHECK (arrival_time > departure_time),
  flight_status VARCHAR(20) NOT NULL CHECK ( flight_status IN ('on time', 'delayed', 'cancelled') )
);

CREATE INDEX idx_flight_id ON Flight(flight_id);
