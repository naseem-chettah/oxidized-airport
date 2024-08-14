CREATE TABLE Seat (
  seat_id SERIAL PRIMARY KEY,
  airplane_id INT NOT NULL REFERENCES Airplane(airplane_id),
  seat_number VARCHAR(10) NOT NULL,
  class VARCHAR(20) NOT NULL CHECK ( class IN ('economy', 'business', 'first class') ),
  UNIQUE (airplane_id, seat_number)
);
