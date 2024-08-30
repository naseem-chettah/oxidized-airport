<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";

  let loading = false;
  let error = null;

  let flightId;

  let flights = [];

  async function getFlights() {
    loading = true;
    error = null;
    try {
      flights = JSON.parse(await invoke("fetch_flights_from_db", {}));
    } catch (err) {
      error = "Error fetching flights: " + err.message;
    } finally {
      loading = false;
    }
  }

  async function delFlights() {
    loading = true;
    error = null;
    try {
      await invoke("delete_flight_from_db", { flightId });
    } catch (err) {
      error = "Error deleting flight: " + err.message;
    } finally {
      loading = false;
    }
  }

  onMount(() => {
    getFlights();
  });
</script>

<div
  class="bg-white rounded-lg shadow sm:max-w-md sm:w-full sm:mx-auto sm:overflow-hidden my-14"
>
  <div class="px-4 py-8 sm:px-10">
    <div class="relative mt-6">
      <div class="absolute inset-0 flex items-center">
        <div class="w-full border-t border-gray-300"></div>
      </div>
      <div class="relative flex justify-center text-sm leading-5">
        <span class="px-2 text-gray-500 bg-white"> Delete a flight </span>
      </div>
    </div>
    <div class="mt-6">
      <div class="w-full space-y-6">
        <div class="w-full">
          <div class=" relative">
            <select
              type="text"
              class="rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-red-600 focus:border-transparent"
              bind:value={flightId}
            >
              <option value="" disabled selected hidden>Select a flight</option>
              {#each flights as flight}
                <option value={flight.flight_id}>{flight.flight_number}</option>
              {/each}
            </select>
          </div>
        </div>
        <div>
          <span class="block w-full rounded-md shadow-sm">
            <button
              on:click={delFlights}
              type="button"
              class="py-2 px-4 bg-red-600 hover:bg-red-700 focus:ring-red-500 focus:ring-offset-indigo-200 text-white w-full transition ease-in duration-200 text-center text-base font-semibold shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 rounded-lg"
            >
              {loading ? "Loading..." : "Delete"}
            </button>
          </span>
        </div>
      </div>
    </div>
  </div>
  <div
    class="text-center px-4 py-6 border-t-2 border-gray-200 bg-gray-50 sm:px-10"
  >
    {#if error == null}
      <p class="text-xs leading-5 text-gray-500">
        <b>THIS ACTION CAN NOT BE UNDONE!</b>
      </p>
    {:else}
      <p class="text-xs leading-5 text-red-500">
        {error}
      </p>
    {/if}
  </div>
</div>
