CREATE TABLE FlightCrewAssignment (
  assignment_id SERIAL PRIMARY KEY,
  flight_id INT NOT NULL REFERENCES Flight(flight_id),
  crew_member_id INT NOT NULL REFERENCES CrewMember(crew_member_id),
  UNIQUE (flight_id, crew_member_id)
);
