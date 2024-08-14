<script>
  import { invoke } from "@tauri-apps/api/tauri";

  let flights;

  async function getFlights() {
    flights = await invoke("fetch_flights_from_db", {});
    console.log(flights[0]);
  }
</script>

<div>
  <button on:click={getFlights}>click</button>
  <p>{flights}</p>
</div>
