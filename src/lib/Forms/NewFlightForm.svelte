<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";

  let loading = false;
  let error = null;

  let airplane;
  let flightNumber;
  let departureAirport;
  let arrivalAirport;
  let departureTime;
  let arrivalTime;
  let flightStatus;

  let airplanes = [];

  async function getAirplanes() {
    loading = true;
    error = null;
    try {
      airplanes = JSON.parse(await invoke("fetch_airplanes_from_db", {}));
    } catch (err) {
      error = "Error fetching airplanes: " + err.message;
    } finally {
      loading = false;
    }
  }

  let airports = [];

  async function getAirports() {
    loading = true;
    error = null;
    try {
      airports = JSON.parse(await invoke("fetch_airports_from_db", {}));
    } catch (err) {
      error = "Error fetching airplanes: " + err.message;
    } finally {
      loading = false;
    }
  }

  async function insertNewFlight() {
    loading = true;
    error = null;
    try {
      await invoke("insert_flight_to_db", {
        airplane,
        flightNumber,
        departureAirport,
        arrivalAirport,
        departureTime,
        arrivalTime,
        flightStatus,
      });
    } catch (err) {
      error = "Error adding new flight: " + (err.message || err);
    } finally {
      loading = false;
      firstName = "";
      lastName = "";
      passportNumber = "";
    }
  }

  onMount(() => {
    getAirplanes();
    getAirports();
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
        <span class="px-2 text-gray-500 bg-white"> Add a new flight </span>
      </div>
    </div>
    <div class="mt-6">
      <div class="w-full space-y-6">
        <div class="w-full">
          <div class=" relative">
            <input
              type="text"
              class=" rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
              placeholder="Flight Number"
              bind:value={flightNumber}
            />
          </div>
        </div>
        <div class="w-full">
          <div class=" relative">
            <select
              type="text"
              class="rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
              bind:value={airplane}
            >
              <option value="" disabled selected hidden
                >Select an airplane</option
              >
              {#each airplanes as ap}
                <option value={ap.model}>{ap.model}</option>
              {/each}
            </select>
          </div>
        </div>
        <div class="flex space-x-4">
          <div class="w-1/2">
            <div class=" relative">
              <select
                type="text"
                class="rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
                bind:value={departureAirport}
              >
                <option value="" disabled selected hidden
                  >Departure airport</option
                >
                {#each airports as ap}
                  {#if ap.iata != arrivalAirport}
                    <option value={ap.iata}>{ap.iata}</option>
                  {/if}
                {/each}
              </select>
            </div>
          </div>
          <div class="w-1/2">
            <div class=" relative">
              <select
                type="text"
                class="rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
                bind:value={arrivalAirport}
              >
                <option value="" disabled selected hidden
                  >Arrival airport</option
                >
                {#each airports as ap}
                  {#if ap.iata != departureAirport}
                    <option value={ap.iata}>{ap.iata}</option>
                  {/if}
                {/each}
              </select>
            </div>
          </div>
        </div>
        <div class="flex space-x-4">
          <div class="w-1/2">
            <div class=" relative">
              <input
                type="datetime-local"
                class=" rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
                bind:value={departureTime}
              />
            </div>
          </div>
          <div class="w-1/2">
            <div class=" relative">
              <input
                type="datetime-local"
                class=" rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
                bind:value={arrivalTime}
              />
            </div>
          </div>
        </div>
        <div class="w-full">
          <div class=" relative">
            <select
              type="text"
              class="rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
              bind:value={flightStatus}
            >
              <option value="" disabled selected hidden>Flight Status</option>
              <option value="on time">On Time</option>
              <option value="delayed">Delayed</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>
        </div>
        <div>
          <span class="block w-full rounded-md shadow-sm">
            <button
              type="button"
              class="py-2 px-4 bg-indigo-600 hover:bg-indigo-700 focus:ring-indigo-500 focus:ring-offset-indigo-200 text-white w-full transition ease-in duration-200 text-center text-base font-semibold shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 rounded-lg"
              on:click={insertNewFlight}
            >
              {loading ? "Loading..." : "Add"}
            </button>
          </span>
        </div>
      </div>
    </div>
  </div>
  <div class="px-4 py-6 border-t-2 border-gray-200 bg-gray-50 sm:px-10">
    {#if error == null}
      <p class="text-xs leading-5 text-gray-500">
        Example: Boeing 737-800, AA100, JFK, LHR, 2024-11-18 03:30, 2024-11-19
        08:30, On Time
      </p>
    {:else}
      <p class="text-xs leading-5 text-red-500">
        {error}
      </p>
    {/if}
  </div>
</div>
