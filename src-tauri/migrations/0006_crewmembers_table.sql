CREATE TABLE IF NOT EXISTS CrewMember (
  crew_member_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  role VARCHAR(50) NOT NULL
);

CREATE INDEX idx_crew_member_id ON CrewMember(crew_member_id);
