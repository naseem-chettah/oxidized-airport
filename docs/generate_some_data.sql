--
-- CREATE THE NEEDED TABLES
--

CREATE TABLE IF NOT EXISTS Airplane (
  airplane_id SERIAL PRIMARY KEY,
  model VARCHAR(50) NOT NULL,
  manufacturer VARCHAR(50) NOT NULL,
  capacity INT NOT NULL
);

CREATE INDEX idx_airplane_id ON Airplane(airplane_id);



CREATE TABLE IF NOT EXISTS Airport (
  airport_id SERIAL PRIMARY KEY,
  city VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  IATA VARCHAR(3) UNIQUE NOT NULL
);

CREATE INDEX idx_airport_id ON Airport(airport_id);



CREATE TABLE IF NOT EXISTS Seat (
  seat_id SERIAL PRIMARY KEY,
  airplane_id INT NOT NULL REFERENCES Airplane(airplane_id),
  seat_number VARCHAR(10) NOT NULL,
  class VARCHAR(20) NOT NULL CHECK ( class IN ('economy', 'business', 'first class') ),
  UNIQUE (airplane_id, seat_number)
);



CREATE TABLE IF NOT EXISTS Passenger (
  passenger_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  passport_number VARCHAR(20) UNIQUE NOT NULL
);



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



CREATE TABLE IF NOT EXISTS CrewMember (
  crew_member_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  role VARCHAR(50) NOT NULL
);

CREATE INDEX idx_crew_member_id ON CrewMember(crew_member_id);



CREATE TABLE IF NOT EXISTS FlightCrewAssignment (
  assignment_id SERIAL PRIMARY KEY,
  flight_id INT NOT NULL REFERENCES Flight(flight_id),
  crew_member_id INT NOT NULL REFERENCES CrewMember(crew_member_id),
  UNIQUE (flight_id, crew_member_id)
);



CREATE TABLE IF NOT EXISTS Booking (
  booking_id SERIAL PRIMARY KEY,
  flight_id INT NOT NULL REFERENCES Flight(flight_id),
  passenger_id INT NOT NULL REFERENCES Passenger(passenger_id),
  seat_id INT NOT NULL REFERENCES Seat(seat_id),
  booking_date TIMESTAMPTZ NOT NULL,
  booking_status VARCHAR(20) NOT NULL CHECK ( booking_status IN ('confirmed', 'cancelled', 'checked-in') ),
  UNIQUE (flight_id, seat_id)
);


--
-- INSERT SOME DATA
--

-- insert some airplanes
INSERT INTO Airplane (model, manufacturer, capacity)
VALUES 
  ('Boeing 737-800', 'Boeing', 189),
  ('Airbus A320', 'Airbus', 180),
  ('Embraer E175', 'Embraer', 76),
  ('Bombardier CRJ-900', 'Bombardier', 90);

-- insert some airports
INSERT INTO Airport (city, country, IATA)
VALUES 
  ('New York', 'United States', 'JFK'),
  ('London', 'United Kingdom', 'LHR'),
  ('Tokyo', 'Japan', 'HND'),
  ('Paris', 'France', 'CDG'),
  ('Dubai', 'United Arab Emirates', 'DXB'),
  ('Singapore', 'Singapore', 'SIN'),
  ('Los Angeles', 'United States', 'LAX'),
  ('Frankfurt', 'Germany', 'FRA');

-- insert some seats for the 1st airplane (189)
WITH airplane_id_cte AS (
  SELECT airplane_id
  FROM Airplane
  WHERE model = 'Boeing 737-800'
  LIMIT 1
)

INSERT INTO Seat (airplane_id, seat_number, class)
SELECT airplane_id,
       seat_number,
       CASE 
         WHEN row_number <= 12 THEN 'first class'
         WHEN row_number <= 30 THEN 'business'
         ELSE 'economy'
       END as class
FROM airplane_id_cte,
     (SELECT 
        CONCAT(
          chr((row_number - 1) % 6 + 65),
          LPAD(((row_number - 1) / 6 + 1)::text, 2, '0')
        ) as seat_number,
        row_number
      FROM generate_series(1, 189) row_number
     ) seats;

-- insert some seats for the 2nd airplane (150)
WITH airplane_id_cte AS (
  SELECT airplane_id
  FROM Airplane
  ORDER BY airplane_id
  OFFSET 1 LIMIT 1
)

INSERT INTO Seat (airplane_id, seat_number, class)
SELECT airplane_id,
       seat_number,
       CASE 
         WHEN row_number <= 12 THEN 'first class'
         WHEN row_number <= 30 THEN 'business'
         ELSE 'economy'
       END as class
FROM airplane_id_cte,
     (SELECT 
        CONCAT(
          chr((row_number - 1) % 6 + 65),
          LPAD(((row_number - 1) / 6 + 1)::text, 2, '0')
        ) as seat_number,
        row_number
      FROM generate_series(1, 150) row_number
     ) seats;

-- insert some seats for the 3rd airplane (76)
WITH airplane_id_cte AS (
  SELECT airplane_id
  FROM Airplane
  ORDER BY airplane_id
  OFFSET 2 LIMIT 1
)

INSERT INTO Seat (airplane_id, seat_number, class)
SELECT airplane_id,
       seat_number,
       CASE 
         WHEN row_number <= 12 THEN 'first class'
         WHEN row_number <= 30 THEN 'business'
         ELSE 'economy'
       END as class
FROM airplane_id_cte,
     (SELECT 
        CONCAT(
          chr((row_number - 1) % 6 + 65),
          LPAD(((row_number - 1) / 6 + 1)::text, 2, '0')
        ) as seat_number,
        row_number
      FROM generate_series(1, 76) row_number
     ) seats;

-- insert some seats for the 4th airplane (76)
WITH airplane_id_cte AS (
  SELECT airplane_id
  FROM Airplane
  ORDER BY airplane_id DESC
  LIMIT 1
)

INSERT INTO Seat (airplane_id, seat_number, class)
SELECT airplane_id,
       seat_number,
       CASE 
         WHEN row_number <= 12 THEN 'first class'
         WHEN row_number <= 30 THEN 'business'
         ELSE 'economy'
       END as class
FROM airplane_id_cte,
     (SELECT 
        CONCAT(
          chr((row_number - 1) % 6 + 65),
          LPAD(((row_number - 1) / 6 + 1)::text, 2, '0')
        ) as seat_number,
        row_number
      FROM generate_series(1, 76) row_number
     ) seats;


-- insert some passenger
INSERT INTO Passenger (first_name, last_name, passport_number)
VALUES
  ('John', 'Doe', 'QCYBSM9F4'),                     
  ('Jane', 'Doe', 'A6316BYE3'), 
  ('Bob', 'Smith', 'I0778T1C3'),
  ('Alice', 'Johnson', 'KR6KKOEYQ'),
  ('Tom', 'Wilson', 'LZX190M3N'),
  ('Sara', 'Davis', '90UPY9B4V'),
  ('Michael', 'Brown', 'L447N0E6D'),
  ('Emily', 'Taylor', 'YD1KRI208'),
  ('David', 'Anderson', 'R6ICF66ER'),
  ('Olivia', 'Thompson', 'VJ4CM30O4'),
  ('William', 'Lee', 'PJ72YJOWH'),
  ('Sophia', 'Kim', '7Z00NKINT'),
  ('Daniel', 'Patel', '3JI2M2JUQ'),
  ('Isabella', 'Gonzalez', 'P59TVAAN9'),
  ('Alexander', 'Nguyen', 'WET7I6NQI'),
  ('Ava', 'Hernandez', 'XHR091Z8Y'),
  ('Jacob', 'Diaz', 'F4Z2PT96M'),
  ('Emma', 'Reyes', 'VAF5OE6N5'),
  ('Benjamin', 'Gutierrez', '2NV45L0NX'),
  ('Mia', 'Jimenez', 'K9917DM36'),
  ('Ethan', 'Sanchez', '7H6LFA725'),
  ('Isabella', 'Morales', 'W6TNS4URA'),
  ('Jacob', 'Ramirez', 'HYGZ9A4EV'),
  ('Avery', 'Flores', 'O4LV4SU78'),
  ('Oliver', 'Castillo', 'I19422JH1'),
  ('Abigail', 'Rojas', 'RT4QU8RMU'),
  ('Lucas', 'Vargas', 'F6N0R9RWS'),
  ('Ella', 'Arredondo', 'FMF0PS2RR'),
  ('Noah', 'Mercado', 'PJ55T1721'),
  ('Amelia', 'Contreras', '5JJ3IQH9P'),
  ('Mason', 'Guerrero', '6DPX9F2K3'),
  ('Harper', 'Ochoa', 'F2ILBGOIH'),
  ('Liam', 'Salazar', '6IKRZ1L5D'),
  ('Isabella', 'Moreno', 'AHK3KALBR'),
  ('William', 'Guzman', 'XP8OE3PMH'),
  ('Ava', 'Mendoza', 'R41ZOGRHJ'),
  ('Benjamin', 'Padilla', 'MMQN452M8'),
  ('Mia', 'Valenzuela', 'H3920AI9G'),
  ('Jacob', 'Zavala', '7E5O7GEFV'),
  ('Emma', 'Santana', '5U35KMNVC'),
  ('Oliver', 'Duran', 'Y8KFZVMC7'),
  ('Abigail', 'Alvarez', '5Q8F06BN7'),
  ('Noah', 'Cortes', 'Z46BLQ91D'),
  ('Ella', 'Dominguez', 'Z7W749J8J'),
  ('Lucas', 'Santillan', 'NCJZ505UX'),
  ('Harper', 'Palacio', 'URRUT592T'),
  ('Mason', 'Bautista', 'FVWSTAGMA'),
  ('Amelia', 'Montoya', 'URQ5XEVS8'),
  ('Liam', 'Reyes', 'ZHGDWBAY8'),
  ('Isabella', 'Oliva', 'B8C6ADSJA'),
  ('William', 'Galvan', 'F7WVY2RW8'),
  ('Ava', 'Ochoa', '06CRZXQO5'),
  ('Benjamin', 'Villegas', '7XWH32867'),
  ('Mia', 'Rocha', 'EV9JHJJ1S'),
  ('Jacob', 'Gallegos', '0Y0IOX5RA'),
  ('Emma', 'Montiel', 'B08DAGH51'),
  ('Oliver', 'Cordoba', '5XATCFW46'),
  ('Abigail', 'Quintero', 'NNUD9QA20'),
  ('Noah', 'Tamayo', '680T5VDC4'),
  ('Ella', 'Machado', 'UP4XC4U65'),
  ('Lucas', 'Guzman', '7H5QS67EX'),
  ('Harper', 'Barrera', 'P6P1P693O'),
  ('Mason', 'Macias', 'LW8M5OBAW'),
  ('Amelia', 'Espinoza', 'BTD70J1D3'),
  ('Liam', 'Montes', '0V9JP1BF0'),
  ('Isabella', 'Trujillo', 'YKUJKZERR'),
  ('William', 'Romero', '3FNWPXXS0'),
  ('Ava', 'Cortez', 'UY0BNAWH8'),
  ('Benjamin', 'Morales', 'XNSKPF5MC'),
  ('Mia', 'Salinas', 'ID2FOSPWW'),
  ('Jacob', 'Ortiz', 'WWZKFCWT5'),
  ('Emma', 'Rios', 'ZLCL7J4FI'),
  ('Oliver', 'Ramirez', 'XS6SK9ILH'),
  ('Abigail', 'Herrera', 'VV41HEF4R'),
  ('Noah', 'Diaz', 'R1NRD6YX7'),
  ('Ella', 'Jimenez', 'X4E0AKYZZ'),
  ('Lucas', 'Ramos', 'ZRBA8NBI4'),
  ('Harper', 'Delgado', '9G841O97B'),
  ('Mason', 'Castaneda', 'GQSDIA158'),
  ('Amelia', 'Suarez', 'AZ8QZMU40'),
  ('Liam', 'Urbina', '3HP9Q1SDP'),
  ('Isabella', 'Cabrera', '4CTKAKSPU'),
  ('William', 'Orozco', 'B7539T2LZ'),
  ('Ava', 'Valdes', 'LJPP8HIC4'),
  ('Benjamin', 'Murillo', '7B9VB70U9'),
  ('Mia', 'Pena', '15V15KK3S'),
  ('Jacob', 'Mejia', 'CJ9XBUPQA'),
  ('Emma', 'Alvarado', 'A27M326N4'),
  ('Oliver', 'Velasquez', '5SUO7U7QB'),
  ('Abigail', 'Calderon', 'LT5ND5I4X'),
  ('Noah', 'Castillo', '0HUD8X4F1'),
  ('Ella', 'Reyes', '8B20PF7OF'),
  ('Lucas', 'Rosales', 'X2LNLV127'),
  ('Harper', 'Meza', 'RGO0CX4SZ'),
  ('Mason', 'Gutierrez', 'H72MO3ECB'),
  ('Amelia', 'Montes', '8A9H01GTI'),
  ('Liam', 'Molina', '692666UF4'),
  ('Isabella', 'Munoz', 'GUZS6664D'),
  ('William', 'Zamora', 'VZ9ZLNJHQ'),
  ('Ava', 'Arias', 'S36SUAK46'),
  ('Benjamin', 'Davila', '1WCJN7602'),
  ('Mia', 'Guzman', '9DZ4CSZKK'),
  ('Jacob', 'Quiros', 'DJFHLIE1K'),
  ('Emma', 'Vargas', 'FITZA66TH'),
  ('Oliver', 'Ochoa', '8UADSX1DV'),
  ('Abigail', 'Alfaro', 'YXZZDIVEA'),
  ('Noah', 'Soto', 'X1NTAHBCY'),
  ('Ella', 'Padilla', '60UVIM4PA'),
  ('Lucas', 'Benitez', 'Y2OGUCEE2'),
  ('Harper', 'Moreno', 'MN6CON709'),
  ('Mason', 'Chavez', 'JWY96O8M7'),
  ('Amelia', 'Ramos', 'QUN0SO7Z9'),
  ('Liam', 'Serrano', 'A7A0EZC1L'),
  ('Isabella', 'Acosta', 'M25UOMH2T'),
  ('William', 'Dominguez', 'MQ3ALQ4EY'),
  ('Ava', 'Castillo', 'RS6Y0QYAB'),
  ('Benjamin', 'Rojas', 'Y0QE17T7W'),
  ('Mia', 'Arce', 'W52RH7TY8'),
  ('Jacob', 'Cortez', 'QVMGE3KIP'),
  ('Emma', 'Olivo', '7ZWQUW7EY'),
  ('Oliver', 'Murillo', 'F6RCC1YCU'),
  ('Abigail', 'Gonzalez', 'WP634YBQV'),
  ('Noah', 'Palacios', '2AL7RF0OX'),
  ('Ella', 'Perez', '2NAE94WT7'),
  ('Lucas', 'Mendoza', '547T2KKTK'),
  ('Harper', 'Macias', 'H9M8FH359'),
  ('Mason', 'Suarez', '48GY26LBN'),
  ('Amelia', 'Montalvo', 'U3K7ONZJH'),
  ('Liam', 'Delgado', '0BTP9YWND'),
  ('Isabella', 'Rios', '0I2JMOWCM'),
  ('William', 'Castillo', 'DV6UA0C5V'),
  ('Ava', 'Flores', 'O2F0Q877E'),
  ('Benjamin', 'Gomez', 'O8NJ117EP'),
  ('Mia', 'Aguilar', 'MK99O3WCY'),
  ('Jacob', 'Solis', 'Q9OX1YD1X'),
  ('Emma', 'Cortes', 'FM7C6HWK8'),
  ('Oliver', 'Villegas', '2C56YJNJ3'),
  ('Abigail', 'Ramirez', '07GKH54F6'),
  ('Noah', 'Mejia', '85PO5M6Z7'),
  ('Ella', 'Rojas', 'A00HO249J'),
  ('Lucas', 'Ruiz', 'YHDK2NWPF'),
  ('Harper', 'Montoya', 'HE93VXEY3'),
  ('Mason', 'Santana', 'E5UT602DK'),
  ('Amelia', 'Diaz', '0ND9XKYFN'),
  ('Liam', 'Rios', 'OOWPWNGFD'),
  ('Isabella', 'Guzman', 'CFJRU4LDA'),
  ('William', 'Reyes', 'ZLQIEOK62'),
  ('Ava', 'Moreno', '6S66EEAYZ'),
  ('Benjamin', 'Arce', 'OIAFBBWK9'),
  ('Mia', 'Vargas', 'YA2D3O05M'),
  ('Jacob', 'Cortez', '0GCB60YA7'),
  ('Emma', 'Delgado', 'DM2JD40FR'),
  ('Oliver', 'Ochoa', '06W215SE8'),
  ('Abigail', 'Rocha', '9BXL9Z372'),
  ('Noah', 'Herrera', 'UOVRLHI27'),
  ('Ella', 'Bautista', 'K16AWE7SA'),
  ('Lucas', 'Guerrero', '2X01DNUIT'),
  ('Harper', 'Ramos', '8ACZME49M'),
  ('Mason', 'Suarez', 'UZ25B3E99'),
  ('Amelia', 'Montes', '8UI40RV73'),
  ('Liam', 'Moreno', '95FRO1B6P'),
  ('Isabella', 'Salazar', 'TCP38WDTT'),
  ('William', 'Perez', '10QW0DA9U'),
  ('Ava', 'Duran', 'MS2W22V61'),
  ('Benjamin', 'Mendoza', 'FRNC0YPQH'),
  ('Mia', 'Machado', 'RYWH6FHX7'),
  ('Jacob', 'Soto', 'LE809T62T'),
  ('Emma', 'Benitez', '7TRM0L4M7'),
  ('Oliver', 'Padilla', 'UC2GDS1V6'),
  ('Abigail', 'Meza', 'BPMEEKO1V'),
  ('Noah', 'Macias', 'J21EDDFR9'),
  ('Ella', 'Cabrera', '7UQ6HTC9A'),
  ('Lucas', 'Barrera', '40M19DU7E'),
  ('Harper', 'Galvan', '4UQOAGVSO'),
  ('Mason', 'Murillo', 'QLMY4CF6W'),
  ('Amelia', 'Palacio', 'IFA32I6NU'),
  ('Liam', 'Quiros', '40BQ9UV7S'),
  ('Isabella', 'Alfaro', '20JA2GM6K'),
  ('William', 'Palacios', 'X2F5N2RYD'),
  ('Ava', 'Tamayo', 'M57OB8ZT8'),
  ('Benjamin', 'Acosta', '3TK7YGU6E'),
  ('Mia', 'Montiel', '2NDVI6RI8'),
  ('William', 'Castillo', 'RO1T2X85S'),
  ('Ava', 'Flores', 'OSDJFAEX4'),
  ('Benjamin', 'Gomez', 'AFXZJUI3E'),
  ('Mia', 'Aguilar', '7AREWY0H5'),
  ('Jacob', 'Solis', 'F9ZB44UKZ'),
  ('Emma', 'Cortes', 'F9681IOTS'),
  ('Oliver', 'Villegas', '0PTCJUJ64'),
  ('Abigail', 'Ramirez', '1YUMBCYEJ'),
  ('Noah', 'Mejia', '75QQKN85P'),
  ('Ella', 'Rojas', 'FAA96Z7JW'),
  ('Lucas', 'Ruiz', 'JRQ76BMQQ'),
  ('Harper', 'Montoya', 'MRZLRG1WE'),
  ('Mason', 'Santana', 'OYYODCOZ1'),
  ('Amelia', 'Diaz', '6190Z0KV3'),
  ('Liam', 'Rios', '0M5A9GSEK'),
  ('Isabella', 'Guzman', 'QA3T3U49P'),
  ('William', 'Reyes', '925CB22BE'),
  ('Ava', 'Moreno', 'UR6NUHKIJ'),
  ('Benjamin', 'Arce', 'M9VJ4CQY7'),
  ('Mia', 'Vargas', '3XEFU56B6'),
  ('Jacob', 'Cortez', '60F9RWKD0'),
  ('Emma', 'Delgado', '47I13FY4V'),
  ('Oliver', 'Ochoa', 'C891RMHNM'),
  ('Abigail', 'Rocha', 'BDPJBWL2N'),
  ('Noah', 'Herrera', '2CH588INC'),
  ('Ella', 'Bautista', 'V8DY5X25Y'),
  ('Lucas', 'Guerrero', 'ULYV9R4XQ'),
  ('Harper', 'Ramos', '7U0G9UU3O'),
  ('Mason', 'Suarez', 'AW8D92NQ0'),
  ('Amelia', 'Montes', '492DWD1GE'),
  ('Liam', 'Moreno', '9EJZ01111'),
  ('Isabella', 'Salazar', 'VR468XIQL'),
  ('William', 'Perez', 'NWA6GT37P'),
  ('Ava', 'Duran', 'A8WFFIB8W'),
  ('Benjamin', 'Mendoza', '779RX1A0K'),
  ('Mia', 'Machado', '7HUXZXKK6'),
  ('Jacob', 'Soto', 'CR2GNWOI4'),
  ('Emma', 'Benitez', 'D175G8HJR'),
  ('Oliver', 'Padilla', 'HWSD0NCFX'),
  ('Abigail', 'Meza', 'FTR1LGOKK'),
  ('Noah', 'Macias', '7L1WJ8MS9'),
  ('Ella', 'Cabrera', '2G3X4889Q'),
  ('Lucas', 'Barrera', 'S767LUL2I'),
  ('Harper', 'Galvan', 'OGNT00217'),
  ('Mason', 'Murillo', 'CBOSCFSIR'),
  ('Amelia', 'Palacio', '5TSE3Q8DR'),
  ('Liam', 'Quiros', 'KUQMZP12J'),
  ('Isabella', 'Alfaro', '1MQ516T5K'),
  ('William', 'Palacios', 'L913PG9RW'),
  ('Ava', 'Tamayo', 'HX81F3P69'),
  ('Benjamin', 'Acosta', '1RAUXV6OZ'),
  ('Mia', 'Montiel', 'J4YT63RIY'),
  ('Jacob', 'Valenzuela', '0IWZKZB5W'),
  ('Emma', 'Trujillo', 'XWF3JEF9C'),
  ('Oliver', 'Arias', '8KG299W4B'),
  ('Abigail', 'Guzman', '1ALPJE1T0'),
  ('Noah', 'Dominguez', 'B31H0HIB1'),
  ('Ella', 'Orozco', 'Y5ZAY500P'),
  ('Lucas', 'Valdes', 'Y7HGLFPA2'),
  ('Harper', 'Murillo', 'NR4IW6WI0'),
  ('Mason', 'Pena', 'IF9DN82RO'),
  ('Amelia', 'Mejia', 'Q51H37I4M'),
  ('Liam', 'Alvarado', 'UPVROTUYF'),
  ('Isabella', 'Velasquez', 'SY2W9471N'),
  ('William', 'Castillo', '2K8JRBQ17'),
  ('Ava', 'Calderon', 'BN5ZJ00HU'),
  ('Benjamin', 'Reyes', '5VZZ1R8S6'),
  ('Mia', 'Rosales', 'YI1OUVJ1M'),
  ('Jacob', 'Meza', '00I0U4B2G'),
  ('Emma', 'Gutierrez', 'AF7VVQJ5K'),
  ('Oliver', 'Montes', 'R61SU73TL'),
  ('Abigail', 'Munoz', '6IGMKVQE6'),
  ('Noah', 'Zamora', 'CR2MINALZ'),
  ('Ella', 'Arias', '3Y1AW910S'),
  ('Lucas', 'Davila', 'W6SVTSSM3'),
  ('Harper', 'Quiros', '7U51PYMK8'),
  ('Mason', 'Olivo', 'DG6S5AX4B'),
  ('Amelia', 'Ochoa', 'B8PXX3M5I'),
  ('Liam', 'Alfaro', 'DG8EWRJ78'),
  ('Isabella', 'Soto', 'RV0J4DCV1'),
  ('William', 'Padilla', '9I5SNRU3F'),
  ('Ava', 'Machado', 'ZH27CW1QP'),
  ('Benjamin', 'Guzman', '1H00VQCFU'),
  ('Mia', 'Cordoba', 'R1JMSEVRS'),
  ('Jacob', 'Quintero', '3IX6H9GMB'),
  ('Emma', 'Tamayo', '4LH2TB0I0'),
  ('Oliver', 'Acosta', 'PVP2H2W0E'),
  ('Abigail', 'Montoya', 'FBT3VSCN7'),
  ('Noah', 'Rojas', 'WGUQW3OML'),
  ('Ella', 'Benitez', 'ROAUA0ZYS'),
  ('Lucas', 'Moreno', 'AJJ66PPX3'),
  ('Harper', 'Salazar', 'JBHSISRUE'),
  ('Mason', 'Perez', 'T874W1YQ4'),
  ('Amelia', 'Duran', 'GWMITSEEL'),
  ('Liam', 'Mendoza', 'F73YTF1P1'),
  ('Isabella', 'Macias', '55548K1ES'),
  ('William', 'Cabrera', '7B6R8620G'),
  ('Ava', 'Barrera', 'QR83RO6OC'),
  ('Benjamin', 'Galvan', 'Y1W02FX9Y'),
  ('Mia', 'Murillo', '66I1EU1O7'),
  ('Jacob', 'Pena', 'LGO3D11T1'),
  ('Emma', 'Mejia', '3SMX0K3I6'),
  ('Oliver', 'Alvarado', 'IJ2YOV89J'),
  ('Abigail', 'Velasquez', '5PR65R2QO'),
  ('Noah', 'Calderon', 'FRQM4A0FE'),
  ('Ella', 'Reyes', 'YVD69MVIW'),
  ('Lucas', 'Rosales', '37QB8SGG4'),
  ('Harper', 'Meza', '25HO4PMCX'),
  ('Mason', 'Gutierrez', 'L2HVYWV2Q'),
  ('Amelia', 'Ramos', 'ZG7MTVL20'),
  ('Liam', 'Serrano', 'B3UTYPHUD'),
  ('Isabella', 'Acosta', '74CIX3DDH'),
  ('William', 'Dominguez', 'BUD3OF3G5'),
  ('Ava', 'Castillo', '8972CM2V1'),
  ('Benjamin', 'Rojas', 'FRHTVD4XJ'),
  ('Mia', 'Arce', 'MSFMGU0BF'),
  ('Jacob', 'Cortez', '06LVCLZOJ'),
  ('Emma', 'Olivo', 'V9F0E7NI5'),
  ('Oliver', 'Murillo', '0BTDIYTM9'),
  ('Abigail', 'Gonzalez', '5U31UZ0KA'),
  ('Noah', 'Palacios', 'SART9ZD71'),
  ('Ella', 'Perez', 'F5AUUM88R'),
  ('Lucas', 'Mendoza', 'G62S62E26'),
  ('Harper', 'Macias', '2NMV6008Y'),
  ('Mason', 'Suarez', 'VBBRY94AS'),
  ('Amelia', 'Montalvo', '7Q253A7L7'),
  ('Liam', 'Delgado', '0HAFW71L4'),
  ('Isabella', 'Rios', 'D20Y8YV44'),
  ('William', 'Castillo', '9CE7YROR6'),
  ('Ava', 'Flores', 'WH5UV1589'),
  ('Benjamin', 'Gomez', '6OUDU8J6T'),
  ('Mia', 'Aguilar', 'WPMNOPYS0'),
  ('Jacob', 'Solis', 'CA408RZCH'),
  ('Emma', 'Cortes', 'QZOA2CVZR'),
  ('Oliver', 'Villegas', 'EOXF411SX'),
  ('Abigail', 'Ramirez', '00RH8P690'),
  ('Noah', 'Mejia', '14TF03QH6'),
  ('Ella', 'Rojas', 'B3POTT7H2'),
  ('Lucas', 'Ruiz', '4A2AX20AM'),
  ('Harper', 'Montoya', 'RKO2UUTMT'),
  ('Mason', 'Santana', '7410865CK'),
  ('Amelia', 'Diaz', '2KEWGI1A1'),
  ('Liam', 'Rios', 'K327F1E9E'),
  ('Isabella', 'Guzman', '1QUQQ7FCM'),
  ('William', 'Reyes', 'CKX4U7072'),
  ('Ava', 'Moreno', '4J758HXEQ'),
  ('Benjamin', 'Arce', '8QA26XAW4'),
  ('Mia', 'Vargas', 'RGQM7FUY5'),
  ('Jacob', 'Cortez', '0310DPD8J'),
  ('Emma', 'Delgado', '22F7EXUT5'),
  ('Oliver', 'Ochoa', 'H2C1BARAR'),
  ('Abigail', 'Rocha', '05O92XXGQ'),
  ('Noah', 'Herrera', 'R6L58MKNQ'),
  ('Ella', 'Bautista', 'HGSQD50GS'),
  ('Lucas', 'Guerrero', 'RJRHG84W6'),
  ('Harper', 'Ramos', '031LM4X88'),
  ('Mason', 'Suarez', 'RASAY1Y0S'),
  ('Amelia', 'Montes', '8HPN5S3WW'),
  ('Liam', 'Moreno', 'O1KZ4GTF8'),
  ('Isabella', 'Salazar', 'JKRT954N5'),
  ('William', 'Perez', 'T0OIY9PN4'),
  ('Ava', 'Duran', 'DXIZ5OOQ6'),
  ('Benjamin', 'Mendoza', 'QWLQV45XA'),
  ('Mia', 'Machado', 'YK16E5QAN'),
  ('Jacob', 'Soto', 'H1J77W7Q5'),
  ('Emma', 'Benitez', 'GOXM79OOO'),
  ('Oliver', 'Padilla', '94NWYBB9L'),
  ('Abigail', 'Meza', 'WV6T03S0F'),
  ('Noah', 'Macias', '7ROFSF9XP'),
  ('Ella', 'Cabrera', 'F5KMSTAGL'),
  ('Lucas', 'Barrera', 'K08A08G4G'),
  ('Harper', 'Galvan', '6DT4UQZMQ'),
  ('Mason', 'Murillo', 'TB2CDNS9U'),
  ('Amelia', 'Palacio', '7TL71X9VV'),
  ('Liam', 'Quiros', 'K03JAQN99'),
  ('Isabella', 'Alfaro', 'H8NIRGGQE'),
  ('William', 'Palacios', 'XD553JFXZ'),
  ('Ava', 'Tamayo', 'OC9G3TBMV'),
  ('Benjamin', 'Acosta', 'CB1QBL00Q'),
  ('Mia', 'Montiel', 'E78QXOJH0'),
  ('Jacob', 'Valenzuela', '4TNY0UW2C'),
  ('Emma', 'Trujillo', '3J1KP4PE7'),
  ('Oliver', 'Arias', 'HHJHTFJT6'),
  ('Abigail', 'Guzman', 'VRUHKZQMT'),
  ('Noah', 'Dominguez', '0I5ERLP11'),
  ('Ella', 'Orozco', 'WAYR053RC'),
  ('Lucas', 'Valdes', '2HTTJZ8P0'),
  ('Harper', 'Murillo', 'Z60YKG9UN'),
  ('Mason', 'Pena', 'RAEEKSAND'),
  ('Amelia', 'Mejia', 'MIY6DYAOD'),
  ('Liam', 'Alvarado', '3F8HFI98I'),
  ('Isabella', 'Velasquez', '0UZV289HR'),
  ('William', 'Castillo', 'CW2AYVGGP'),
  ('Ava', 'Calderon', 'STAQKF1MA'),
  ('Benjamin', 'Reyes', 'TDKOBHA13'),
  ('Mia', 'Rosales', '300UEWDO8'),
  ('Jacob', 'Meza', 'RSO2J9WTX'),
  ('Emma', 'Gutierrez', 'E9S87W413'),
  ('Oliver', 'Montes', 'NS4SCZHB9'),
  ('Abigail', 'Munoz', '00H3WSMDT'),
  ('Noah', 'Zamora', '90V1I5UC3'),
  ('Ella', 'Arias', '7J93RM6DZ'),
  ('Lucas', 'Davila', 'I1Y8YCVFP'),
  ('Harper', 'Quiros', '6008BTDEN'),
  ('Mason', 'Olivo', 'M9WI5EQVY'),
  ('Amelia', 'Ochoa', 'AEXADIN7Q'),
  ('Liam', 'Alfaro', '7Z7UF3LCY'),
  ('Isabella', 'Soto', 'LHL9IPJTL'),
  ('William', 'Padilla', 'PCQSKHFIC'),
  ('Ava', 'Machado', 'XANR0EZY2'),
  ('Benjamin', 'Guzman', 'G2LU0GGS5'),
  ('Mia', 'Cordoba', '046F8DKX7'),
  ('Jacob', 'Quintero', 'UI3Y0HC5C'),
  ('Emma', 'Tamayo', 'WIG8Q8824'),
  ('Oliver', 'Acosta', 'WSU4BF3LT'),
  ('Abigail', 'Montoya', '5G0YVWTV9'),
  ('Noah', 'Rojas', '1CNXMP41X'),
  ('Ella', 'Benitez', 'Z389PZFSE'),
  ('Lucas', 'Moreno', 'S0EP05OS1'),
  ('Harper', 'Salazar', '3US52RK90'),
  ('Mason', 'Perez', '215EONKBT'),
  ('Amelia', 'Duran', 'I7F5H9TWZ'),
  ('Liam', 'Mendoza', 'NIB0S0UME'),
  ('Isabella', 'Macias', '9S722NZKD'),
  ('William', 'Cabrera', 'EEAY55A3G'),
  ('Ava', 'Barrera', '37KIJV6V2'),
  ('Benjamin', 'Galvan', 'H3NSV0URB'),
  ('Mia', 'Murillo', 'ALSGMS805'),
  ('Jacob', 'Pena', '72WY351HA'),
  ('Emma', 'Mejia', 'JIMWYN1A3'),
  ('Oliver', 'Alvarado', '6O5756L6E'),
  ('Abigail', 'Velasquez', '1HFMKEJQ4'),
  ('Noah', 'Calderon', 'FU4GCUVMC'),
  ('Ella', 'Reyes', 'LNGOGN5NU'),
  ('Lucas', 'Rosales', 'ND52LYZQG'),
  ('Harper', 'Meza', 'Z00L8AESM'),
  ('Mason', 'Gutierrez', 'VX1BM4IWM'),
  ('Amelia', 'Ramos', 'GZVQRDZJV'),
  ('Liam', 'Serrano', 'L0FUFCQR6'),
  ('Isabella', 'Acosta', 'OQ87HQTCZ'),
  ('William', 'Dominguez', 'V32V0JCOV'),
  ('Ava', 'Castillo', '8YT4XRW4B'),
  ('Benjamin', 'Rojas', 'C761MDGE2'),
  ('Mia', 'Arce', 'LOGL14VAN'),
  ('Jacob', 'Cortez', 'QYRSA5RB5'),
  ('Emma', 'Olivo', 'TEE7CPAWO'),
  ('Oliver', 'Murillo', 'M9YR3L5IY'),
  ('Abigail', 'Gonzalez', '1PZN553LB'),
  ('Noah', 'Palacios', '9A11IM365'),
  ('Ella', 'Perez', 'Z2MD3EYF5'),
  ('Lucas', 'Mendoza', 'FP4TTKLLO'),
  ('Harper', 'Macias', 'D1HO0YMQJ'),
  ('Mason', 'Suarez', 'ZZZ8SQSMN'),
  ('Amelia', 'Montalvo', '2L3N0DFPB'),
  ('Liam', 'Delgado', 'LY53Z5K1G'),
  ('Isabella', 'Rios', '6CEKSFS0G'),
  ('William', 'Castillo', 'FSGX1NBJW'),
  ('Ava', 'Flores', 'WBA872JIO'),
  ('Benjamin', 'Gomez', 'VR26SSG99'),
  ('Mia', 'Aguilar', '36D2X56LP'),
  ('Jacob', 'Solis', 'GFF6WSE2K'),
  ('Emma', 'Cortes', 'B10OGO9E1'),
  ('Oliver', 'Villegas', 'UC1PSJK7D'),
  ('Abigail', 'Ramirez', 'UN0HCNV4B'),
  ('Noah', 'Mejia', 'JVSF7G4M4'),
  ('Ella', 'Rojas', 'XHPJB3ANJ'),
  ('Lucas', 'Ruiz', 'YU5G8HI40'),
  ('Harper', 'Montoya', 'V1HV88UPL'),
  ('Mason', 'Santana', '1AJMIEG36'),
  ('Amelia', 'Diaz', '9OCMH68GP'),
  ('Liam', 'Rios', 'M0J3LR8HS'),
  ('Isabella', 'Guzman', '5R2P41ADO'),
  ('William', 'Reyes', 'WX0G6ZZDK'),
  ('Ava', 'Moreno', 'R4I93OQ43'),
  ('Benjamin', 'Arce', 'Z60EQ62FW'),
  ('Mia', 'Vargas', '1LAV06O9I'),
  ('Jacob', 'Cortez', 'NOPZS6UU8'),
  ('Emma', 'Delgado', '0XW73T321'),
  ('Oliver', 'Ochoa', 'WO2BLSFN3'),
  ('Abigail', 'Rocha', 'MO3IVUJPN'),
  ('Noah', 'Herrera', 'H6DPYKG2J'),
  ('Ella', 'Bautista', 'ED4H2O726'),
  ('Lucas', 'Guerrero', 'XV0O4W6TX'),
  ('Harper', 'Ramos', 'JVV29C7FQ'),
  ('Mason', 'Suarez', 'B2Z5H0HB2'),
  ('Amelia', 'Montes', 'P8I92FI0P'),
  ('Liam', 'Moreno', 'WKX74UY6I'),
  ('Isabella', 'Salazar', 'W5MP2F5MV'),
  ('William', 'Perez', '6PQHBAAIZ'),
  ('Ava', 'Duran', 'SJ75M4AG3'),
  ('Benjamin', 'Mendoza', '3VFE4KWGY'),
  ('Mia', 'Machado', '8BDDNUUTI'),
  ('Jacob', 'Soto', 'BG1XJ59VA'),
  ('Emma', 'Benitez', 'HTJHVGR5Z'),
  ('Oliver', 'Padilla', '6OSNNL2RT'),
  ('Abigail', 'Meza', '6Z0RE54CE'),
  ('Noah', 'Macias', 'TO1GEQ84U'),
  ('Ella', 'Cabrera', 'RJ2EXP6NL'),
  ('Lucas', 'Barrera', 'DLM9L96RD'),
  ('Harper', 'Galvan', 'J3MLJ823Z'),
  ('Mason', 'Murillo', 'KU4TV71IL'),
  ('Amelia', 'Palacio', '0A03STN4W'),
  ('Liam', 'Quiros', 'M064SRHRD'),
  ('Isabella', 'Alfaro', '6VX5L2WK9'),
  ('William', 'Palacios', 'JBNHBGDHB'),
  ('Ava', 'Tamayo', 'DMP4XNC5Z'),
  ('Benjamin', 'Acosta', 'LB1RXNGFW'),
  ('Mia', 'Montiel', 'LU8Y9U8G8'),
  ('Jacob', 'Valenzuela', 'UTU2URP9W');

-- insert some flights
INSERT INTO Flight
( airplane_id, flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time, flight_status )
VALUES ( 1, 'AA100', 1, 2, '2024-11-18 03:30:00+00', '2024-11-19 08:30:00+00', 'on time' ),
( 2, 'NH215', 3, 4, '2024-11-19 08:30:00+00', '2024-11-20 08:30:00+00', 'on time' ),
( 3, 'SQ495', 5, 6, '2024-11-29 03:30:00+00', '2024-11-30 08:30:00+00', 'on time' ),
( 4, 'AA720', 7, 8, '2024-11-28 03:30:00+00', '2024-11-29 08:30:00+00', 'on time' );
