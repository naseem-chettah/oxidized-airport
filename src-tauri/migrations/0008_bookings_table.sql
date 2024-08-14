CREATE TABLE Booking (
  booking_id SERIAL PRIMARY KEY,
  flight_id INT NOT NULL REFERENCES Flight(flight_id),
  passenger_id INT NOT NULL REFERENCES Passenger(passenger_id),
  seat_id INT NOT NULL REFERENCES Seat(seat_id),
  booking_date TIMESTAMPTZ NOT NULL,
  booking_status VARCHAR(20) NOT NULL CHECK ( booking_status IN ('confirmed', 'cancelled', 'checked-in') ),
  UNIQUE (flight_id, seat_id)
);
