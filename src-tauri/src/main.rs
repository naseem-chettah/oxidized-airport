// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use app::{fetch_airplanes, Airplane};

#[tauri::command]
async fn fetch_airplanes_from_db() -> Result<String, String> {
    let url = "postgres://postgres:admin@192.168.122.54:5432/oxidized_airport";
    let pool = sqlx::postgres::PgPool::connect(url)
        .await
        .map_err(|e| e.to_string())?;

    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .map_err(|e| e.to_string())?;

    let airplanes: Vec<Airplane> = fetch_airplanes(&pool).await.map_err(|e| e.to_string())?;
    let json_string = serde_json::to_string(&airplanes).map_err(|e| e.to_string())?;
    Ok(json_string)
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![fetch_airplanes_from_db])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
