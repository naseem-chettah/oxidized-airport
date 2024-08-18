<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";

  let cols = ["City", "Country", "IATA"];
  let airports = [];
  let loading = false;
  let error = null;

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

  onMount(() => {
    getAirports();
  });
</script>

<div>
  <div class="flex justify-center">
    <!-- svelte-ignore a11y-click-events-have-key-events -->
    <!-- svelte-ignore a11y-no-static-element-interactions -->
    <i
      on:click={getAirports}
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
        {#each airports as airport}
          <tr class="text-gray-700">
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{airport.city}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{airport.country}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{airport.iata}</td
            >
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>
