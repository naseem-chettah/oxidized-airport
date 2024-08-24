// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use app::{
    connect_to_db, create_airplane, create_passenger, fetch_airplanes, fetch_airports,
    fetch_flights, fetch_passengers, Airplane, Airport, FlightDetails, Passenger,
};

#[tauri::command]
async fn fetch_airplanes_from_db() -> Result<String, String> {
    let pool = connect_to_db("postgres://postgres:admin@192.168.122.54:5432/oxidized_airport".to_string())
        .await
        .map_err(|e| e.to_string())?;

    let airplanes: Vec<Airplane> = fetch_airplanes(&pool).await.map_err(|e| e.to_string())?;
    let json_string = serde_json::to_string(&airplanes).map_err(|e| e.to_string())?;
    Ok(json_string)
}

#[tauri::command]
async fn fetch_airports_from_db() -> Result<String, String> {
    let url = "postgres://postgres:admin@192.168.122.54:5432/oxidized_airport";
    let pool = sqlx::postgres::PgPool::connect(url)
        .await
        .map_err(|e| e.to_string())?;

    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .map_err(|e| e.to_string())?;

    let airports: Vec<Airport> = fetch_airports(&pool).await.map_err(|e| e.to_string())?;
    let json_string = serde_json::to_string(&airports).map_err(|e| e.to_string())?;
    Ok(json_string)
}

#[tauri::command]
async fn fetch_passengers_from_db() -> Result<String, String> {
    let url = "postgres://postgres:admin@192.168.122.54:5432/oxidized_airport";
    let pool = sqlx::postgres::PgPool::connect(url)
        .await
        .map_err(|e| e.to_string())?;

    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .map_err(|e| e.to_string())?;

    let passengers: Vec<Passenger> = fetch_passengers(&pool).await.map_err(|e| e.to_string())?;
    let json_string = serde_json::to_string(&passengers).map_err(|e| e.to_string())?;
    Ok(json_string)
}

#[tauri::command]
async fn fetch_flights_from_db() -> Result<String, String> {
    let url = "postgres://postgres:admin@192.168.122.54:5432/oxidized_airport";
    let pool = sqlx::postgres::PgPool::connect(url)
        .await
        .map_err(|e| e.to_string())?;

    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .map_err(|e| e.to_string())?;

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
    let url = "postgres://postgres:admin@192.168.122.54:5432/oxidized_airport";
    let pool = sqlx::postgres::PgPool::connect(url)
        .await
        .map_err(|e| e.to_string())?;

    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .map_err(|e| e.to_string())?;

    let airplane = Airplane {
        model: String::from(model),
        manufacturer: String::from(manufacturer),
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
    let url = "postgres://postgres:admin@192.168.122.54:5432/oxidized_airport";
    let pool = sqlx::postgres::PgPool::connect(url)
        .await
        .map_err(|e| e.to_string())?;

    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .map_err(|e| e.to_string())?;

    let passenger = Passenger {
        first_name: String::from(first_name),
        last_name: String::from(last_name),
        passport_number: String::from(passport_number),
    };

    create_passenger(&passenger, &pool)
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
            insert_passenger_to_db
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
