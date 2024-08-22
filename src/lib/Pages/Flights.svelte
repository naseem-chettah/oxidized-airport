<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";

  let cols = [
    "Airplane",
    "Flight Number",
    "Departure Airport",
    "Arrival Airport",
    "Departure Time",
    "Arrival Time",
    "Flight Status",
  ];
  let flights = [];
  let loading = false;
  let error = null;

  async function getFlights() {
    loading = true;
    error = null;
    try {
      flights = JSON.parse(await invoke("fetch_flights_from_db", {}));
    } catch (err) {
      error = "Error fetching airplanes: " + err.message;
    } finally {
      loading = false;
    }
  }

  function formatDateTime(dateTimeString) {
    const dateTime = new Date(dateTimeString);
    return new Intl.DateTimeFormat("en-US", {
      year: "2-digit",
      month: "long",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      hour12: false,
    }).format(dateTime);
  }

  onMount(() => {
    getFlights();
  });
</script>

<div>
  <div class="flex justify-center">
    <!-- svelte-ignore a11y-click-events-have-key-events -->
    <!-- svelte-ignore a11y-no-static-element-interactions -->
    <i
      on:click={getFlights}
      class={loading
        ? "fa-solid fa-arrows-rotate fa-spin"
        : "fa-solid fa-arrows-rotate"}
    ></i>
  </div>
  {#if error}
    <p class="text-red-600">{error}</p>
  {/if}
  <div class="flex justify-center">
    <table class="table p-4 bg-white rounded-lg shadow">
      <thead>
        <tr>
          {#each cols as col}
            <th
              class="border-b-2 p-4 dark:border-dark-5 whitespace-nowrap font-normal text-gray-900"
            >
              {col}
            </th>
          {/each}
        </tr>
      </thead>
      <tbody>
        {#each flights as flight}
          <tr class="text-gray-700">
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{flight.airplane_model}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{flight.flight_number}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{flight.departure_iata}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{flight.arrival_iata}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{formatDateTime(flight.departure_time)}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{formatDateTime(flight.arrival_time)}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{flight.flight_status}</td
            >
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>
