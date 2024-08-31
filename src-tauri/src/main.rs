// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use app::{
    connect_to_db, create_airplane, create_flight, create_passenger, delete_flight,
    fetch_airplanes, fetch_airports, fetch_flights, fetch_passengers, Airplane, AirplaneDetails,
    AirportDetails, Flight, FlightDetails, Passenger,
};
use chrono::{DateTime, Utc};

#[tauri::command]
async fn fetch_airplanes_from_db() -> Result<String, String> {
    let pool = connect_to_db().await.map_err(|e| e.to_string())?;

    let airplanes: Vec<AirplaneDetails> =
        fetch_airplanes(&pool).await.map_err(|e| e.to_string())?;
    let json_string = serde_json::to_string(&airplanes).map_err(|e| e.to_string())?;
    Ok(json_string)
}

#[tauri::command]
async fn fetch_airports_from_db() -> Result<String, String> {
    let pool = connect_to_db().await.map_err(|e| e.to_string())?;

    let airports: Vec<AirportDetails> = fetch_airports(&pool).await.map_err(|e| e.to_string())?;
    let json_string = serde_json::to_string(&airports).map_err(|e| e.to_string())?;
    Ok(json_string)
}

#[tauri::command]
async fn fetch_passengers_from_db() -> Result<String, String> {
    let pool = connect_to_db().await.map_err(|e| e.to_string())?;

    let passengers: Vec<Passenger> = fetch_passengers(&pool).await.map_err(|e| e.to_string())?;
    let json_string = serde_json::to_string(&passengers).map_err(|e| e.to_string())?;
    Ok(json_string)
}

#[tauri::command]
async fn fetch_flights_from_db() -> Result<String, String> {
    let pool = connect_to_db().await.map_err(|e| e.to_string())?;

    let flights: Vec<FlightDetails> = fetch_flights(&pool).await.map_err(|e| e.to_string())?;
    let json_string = serde_json::to_string(&flights).map_err(|e| e.to_string())?;
    Ok(json_string)
}

#[tauri::command]
async fn insert_airplane_to_db(
    model: String,
    manufacturer: String,
    capacity: i32,
) -> Result<(), String> {
    let pool = connect_to_db().await.map_err(|e| e.to_string())?;

    let airplane = Airplane {
        model,
        manufacturer,
        capacity,
    };

    create_airplane(&airplane, &pool)
        .await
        .map_err(|e| e.to_string())?;
    Ok(())
}

#[tauri::command]
async fn insert_passenger_to_db(
    first_name: String,
    last_name: String,
    passport_number: String,
) -> Result<(), String> {
    let pool = connect_to_db().await.map_err(|e| e.to_string())?;

    let passenger = Passenger {
        first_name,
        last_name,
        passport_number,
    };

    create_passenger(&passenger, &pool)
        .await
        .map_err(|e| e.to_string())?;
    Ok(())
}

#[tauri::command]
async fn insert_flight_to_db(
    airplane_id: i32,
    flight_number: String,
    departure_airport_id: i32,
    arrival_airport_id: i32,
    departure_time: String,
    arrival_time: String,
    flight_status: String,
) -> Result<(), String> {
    let pool = connect_to_db().await.map_err(|e| e.to_string())?;

    let flight = Flight {
        airplane_id,
        flight_number,
        departure_airport_id,
        arrival_airport_id,
        departure_time: departure_time
            .parse::<DateTime<Utc>>()
            .map_err(|e| e.to_string())?,
        arrival_time: arrival_time
            .parse::<DateTime<Utc>>()
            .map_err(|e| e.to_string())?,
        flight_status,
    };

    create_flight(&flight, &pool)
        .await
        .map_err(|e| e.to_string())?;
    Ok(())
}

#[tauri::command]
async fn delete_flight_from_db(flight_id: i32) -> Result<(), String> {
    let pool = connect_to_db().await.map_err(|e| e.to_string())?;

    delete_flight(flight_id, &pool)
        .await
        .map_err(|e| e.to_string())?;
    Ok(())
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            fetch_airplanes_from_db,
            fetch_airports_from_db,
            fetch_passengers_from_db,
            fetch_flights_from_db,
            insert_airplane_to_db,
            insert_passenger_to_db,
            insert_flight_to_db,
            delete_flight_from_db
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
