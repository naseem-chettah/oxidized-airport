CREATE TABLE IF NOT EXISTS Passenger (
  passenger_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  passport_number VARCHAR(20) UNIQUE NOT NULL
);
