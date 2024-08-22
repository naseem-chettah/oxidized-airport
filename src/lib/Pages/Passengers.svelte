<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";

  let cols = ["First Name", "Last Name", "Passport Number"];
  let passengers = [];
  let loading = false;
  let error = null;

  async function getPassengers() {
    loading = true;
    error = null;
    try {
      passengers = JSON.parse(await invoke("fetch_passengers_from_db", {}));
    } catch (err) {
      error = "Error fetching airplanes: " + err.message;
    } finally {
      loading = false;
    }
  }

  onMount(() => {
    getPassengers();
  });
</script>

<div>
  <div class="flex justify-center cursor-pointer">
    <!-- svelte-ignore a11y-click-events-have-key-events -->
    <!-- svelte-ignore a11y-no-static-element-interactions -->
    <i
      on:click={getPassengers}
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
        {#each passengers as passenger}
          <tr class="text-gray-700">
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{passenger.first_name}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{passenger.last_name}</td
            >
            <td class="border-b-2 p-4 dark:border-dark-5"
              >{passenger.passport_number}</td
            >
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>
