use sqlx::{PgPool, Row, Error};

pub async fn read_from_db() -> Result<(), sqlx::Error> {
    let pool = sqlx::postgres::PgPool::connect(
        "postgres://postgres:admin@192.168.122.54:5432/oxidized_airport",
    )
    .await?;

    let query = "SELECT 1 + 1;";

    Ok(())
}
