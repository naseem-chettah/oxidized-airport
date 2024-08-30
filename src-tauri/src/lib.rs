use chrono::{DateTime, Utc};
use envconfig::Envconfig;
use serde::Serialize;
use sqlx::{PgPool, Row};
use std::error::Error;

#[derive(Envconfig)]
struct Config {
    #[envconfig(from = "OADBCS")]
    url: String,
}

#[derive(Debug, Serialize)]
pub struct Airplane {
    pub model: String,
    pub manufacturer: String,
    pub capacity: i32,
}

#[derive(Debug, Serialize)]
pub struct Airport {
    pub city: String,
    pub country: String,
    pub iata: String,
}

#[derive(Debug, Serialize)]
pub struct Seat {
    pub airplane_id: i32,
    pub seat_number: String,
    pub class: String,
}

#[derive(Debug, Serialize)]
pub struct Passenger {
    pub first_name: String,
    pub last_name: String,
    pub passport_number: String,
}

#[derive(Debug, Serialize)]
pub struct Flight {
    pub airplane_id: i32,
    pub flight_number: String,
    pub departure_airport_id: i32,
    pub arrival_airport_id: i32,
    pub departure_time: DateTime<Utc>,
    pub arrival_time: DateTime<Utc>,
    pub flight_status: String,
}

#[derive(Debug, Serialize)]
pub struct FlightDetails {
    pub airplane_model: String,
    pub flight_number: String,
    pub departure_iata: String,
    pub arrival_iata: String,
    pub departure_time: DateTime<Utc>,
    pub arrival_time: DateTime<Utc>,
    pub flight_status: String,
}

#[derive(Debug, Serialize)]
pub struct CrewMember {
    pub first_name: String,
    pub last_name: String,
    pub role: String,
}

#[derive(Debug, Serialize)]
pub struct FlightCrewAssignment {
    pub flight_id: i32,
    pub crew_member_id: i32,
}

#[derive(Debug, Serialize)]
pub struct Booking {
    pub flight_id: i32,
    pub passenger_id: i32,
    pub seat_id: i32,
    pub booking_date: DateTime<Utc>,
    pub booking_status: String,
}

pub async fn connect_to_db() -> Result<PgPool, Box<dyn Error>> {
    let config = Config::init_from_env().expect("Failed to load configuration");

    let pool = sqlx::postgres::PgPool::connect(&config.url).await?;

    sqlx::migrate!("./migrations").run(&pool).await?;

    Ok(pool)
}

// CREATE
pub async fn create_airplane(
    airplane: &Airplane,
    pool: &sqlx::PgPool,
) -> Result<(), Box<dyn Error>> {
    let query = "INSERT INTO Airplane (model, manufacturer, capacity) VALUES ($1, $2, $3)";

    sqlx::query(query)
        .bind(&airplane.model)
        .bind(&airplane.manufacturer)
        .bind(&airplane.capacity)
        .execute(pool)
        .await?;

    Ok(())
}

pub async fn create_airport(airport: &Airport, pool: &sqlx::PgPool) -> Result<(), Box<dyn Error>> {
    let query = "INSERT INTO Airport (city, country, iata) VALUES ($1, $2, $3)";

    sqlx::query(query)
        .bind(&airport.city)
        .bind(&airport.country)
        .bind(&airport.iata)
        .execute(pool)
        .await?;

    Ok(())
}

pub async fn create_seat(seat: &Seat, pool: &sqlx::PgPool) -> Result<(), Box<dyn Error>> {
    let query = "INSERT INTO Seat (airplane_id, seat_number, class) VALUES ($1, $2, $3)";

    sqlx::query(query)
        .bind(&seat.airplane_id)
        .bind(&seat.seat_number)
        .bind(&seat.class)
        .execute(pool)
        .await?;

    Ok(())
}

pub async fn create_passenger(
    passenger: &Passenger,
    pool: &sqlx::PgPool,
) -> Result<(), Box<dyn Error>> {
    let query =
        "INSERT INTO Passenger (first_name, last_name, passport_number) VALUES ($1, $2, $3)";

    sqlx::query(query)
        .bind(&passenger.first_name)
        .bind(&passenger.last_name)
        .bind(&passenger.passport_number)
        .execute(pool)
        .await?;

    Ok(())
}

pub async fn create_flight(flight: &Flight, pool: &sqlx::PgPool) -> Result<(), Box<dyn Error>> {
    let query = "INSERT INTO Flight (airplane_id, flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time, flight_status) VALUES ($1, $2, $3, $4, $5, $6, $7)";

    sqlx::query(query)
        .bind(&flight.airplane_id)
        .bind(&flight.flight_number)
        .bind(&flight.departure_airport_id)
        .bind(&flight.arrival_airport_id)
        .bind(&flight.departure_time)
        .bind(&flight.arrival_time)
        .bind(&flight.flight_status)
        .execute(pool)
        .await?;

    Ok(())
}

pub async fn create_crewmember(
    crewmember: &CrewMember,
    pool: &sqlx::PgPool,
) -> Result<(), Box<dyn Error>> {
    let query = "INSERT INTO CrewMember (first_name, last_name, role) VALUES ($1, $2, $3)";

    sqlx::query(query)
        .bind(&crewmember.first_name)
        .bind(&crewmember.last_name)
        .bind(&crewmember.role)
        .execute(pool)
        .await?;

    Ok(())
}

pub async fn create_assignment(
    assignment: &FlightCrewAssignment,
    pool: &sqlx::PgPool,
) -> Result<(), Box<dyn Error>> {
    let query = "INSERT INTO FlightCrewAssignment (flight_id, crew_member_id) VALUES ($1, $2)";

    sqlx::query(query)
        .bind(&assignment.flight_id)
        .bind(&assignment.crew_member_id)
        .execute(pool)
        .await?;

    Ok(())
}

pub async fn create_booking(booking: &Booking, pool: &sqlx::PgPool) -> Result<(), Box<dyn Error>> {
    let query = "INSERT INTO Booking (flight_id, passenger_id, seat_id, booking_date, booking_status) VALUES ($1, $2, $3, $4, $5)";

    sqlx::query(query)
        .bind(&booking.flight_id)
        .bind(&booking.passenger_id)
        .bind(&booking.seat_id)
        .bind(&booking.booking_date)
        .bind(&booking.booking_status)
        .execute(pool)
        .await?;

    Ok(())
}

// READ
pub async fn fetch_airplanes(pool: &sqlx::PgPool) -> Result<Vec<Airplane>, Box<dyn Error>> {
    let q = "SELECT model, manufacturer, capacity FROM airplane";
    let query = sqlx::query(q);

    let rows = query.fetch_all(pool).await?;

    let airplanes = rows
        .iter()
        .map(|row| Airplane {
            model: row.get("model"),
            manufacturer: row.get("manufacturer"),
            capacity: row.get("capacity"),
        })
        .collect();

    Ok(airplanes)
}

pub async fn fetch_airports(pool: &sqlx::PgPool) -> Result<Vec<Airport>, Box<dyn Error>> {
    let q = "SELECT city, country, iata FROM airport";
    let query = sqlx::query(q);

    let rows = query.fetch_all(pool).await?;

    let airport = rows
        .iter()
        .map(|row| Airport {
            city: row.get("city"),
            country: row.get("country"),
            iata: row.get("iata"),
        })
        .collect();

    Ok(airport)
}

pub async fn fetch_seats(pool: &sqlx::PgPool) -> Result<Vec<Seat>, Box<dyn Error>> {
    let q = "SELECT airplane_id, seat_number, class FROM seat";
    let query = sqlx::query(q);

    let rows = query.fetch_all(pool).await?;

    let seats = rows
        .iter()
        .map(|row| Seat {
            airplane_id: row.get("airplane_id"),
            seat_number: row.get("seat_number"),
            class: row.get("class"),
        })
        .collect();

    Ok(seats)
}

pub async fn fetch_passengers(pool: &sqlx::PgPool) -> Result<Vec<Passenger>, Box<dyn Error>> {
    let q = "SELECT first_name, last_name, passport_number FROM passenger";
    let query = sqlx::query(q);

    let rows = query.fetch_all(pool).await?;

    let passengers = rows
        .iter()
        .map(|row| Passenger {
            first_name: row.get("first_name"),
            last_name: row.get("last_name"),
            passport_number: row.get("passport_number"),
        })
        .collect();

    Ok(passengers)
}

pub async fn fetch_flights(pool: &sqlx::PgPool) -> Result<Vec<FlightDetails>, Box<dyn Error>> {
    let q = "SELECT a.model AS airplane_model, f.flight_number, dep.iata AS departure_iata, arr.iata AS arrival_iata, departure_time, arrival_time, flight_status FROM flight f INNER JOIN airplane a ON f.airplane_id = a.airplane_id INNER JOIN airport dep ON f.departure_airport_id = dep.airport_id INNER JOIN airport arr ON f.arrival_airport_id = arr.airport_id";
    let query = sqlx::query(q);

    let rows = query.fetch_all(pool).await?;

    let flights = rows
        .iter()
        .map(|row| FlightDetails {
            airplane_model: row.get("airplane_model"),
            flight_number: row.get("flight_number"),
            departure_iata: row.get("departure_iata"),
            arrival_iata: row.get("arrival_iata"),
            departure_time: row.get("departure_time"),
            arrival_time: row.get("arrival_time"),
            flight_status: row.get("flight_status"),
        })
        .collect();

    Ok(flights)
}

pub async fn fetch_crewmembers(pool: &sqlx::PgPool) -> Result<Vec<CrewMember>, Box<dyn Error>> {
    let q = "SELECT first_name, last_name, role FROM crewmember";
    let query = sqlx::query(q);

    let rows = query.fetch_all(pool).await?;

    let crewmembers = rows
        .iter()
        .map(|row| CrewMember {
            first_name: row.get("first_name"),
            last_name: row.get("last_name"),
            role: row.get("role"),
        })
        .collect();

    Ok(crewmembers)
}

pub async fn fetch_assignments(
    pool: &sqlx::PgPool,
) -> Result<Vec<FlightCrewAssignment>, Box<dyn Error>> {
    let q = "SELECT flight_id, crew_member_id FROM flightcrewassignment";
    let query = sqlx::query(q);

    let rows = query.fetch_all(pool).await?;

    let assignments = rows
        .iter()
        .map(|row| FlightCrewAssignment {
            flight_id: row.get("flight_id"),
            crew_member_id: row.get("crew_member_id"),
        })
        .collect();

    Ok(assignments)
}
