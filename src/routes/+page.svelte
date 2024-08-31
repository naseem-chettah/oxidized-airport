<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";

  import Header from "../lib/Header.svelte";
  import Airplanes from "../lib/Pages/Airplanes.svelte";
  import Airports from "../lib/Pages/Airports.svelte";
  import Passengers from "../lib/Pages/Passengers.svelte";
  import Flights from "../lib/Pages/Flights.svelte";

  let dbConnectionError = null;
  let loading = false;

  let tabs = ["Airplanes", "Airports", "Passengers", "Flights"];
  let activeTab = "Airplanes";

  const tabChange = (e) => {
    activeTab = e.detail;
  };

  async function checkConnection() {
    dbConnectionError = null;
    loading = true;
    try {
      dbConnectionError = await invoke("check_connection_to_db", {});
    } catch (err) {
      dbConnectionError = true;
    } finally {
      loading = false;
    }
  }

  onMount(() => {
    checkConnection();
  });
</script>

{#if !loading}
  {#if dbConnectionError}
    <div
      class="fixed inset-0 w-full h-full bg-purple-700 text-white flex flex-col items-center justify-center"
    >
      <h1 class="text-4xl font-bold">ERROR 503</h1>
      <p class="mt-4 text-center">
        We faced an error connecting to the database, please check your
        connection and <button class="underline" on:click={checkConnection}>try again</button> later.
      </p>
    </div>
  {:else if !dbConnectionError}
    <Header {tabs} {activeTab} on:tabChange={tabChange} />
    <br />
    {#if activeTab === "Airplanes"}
      <Airplanes />
    {:else if activeTab === "Airports"}
      <Airports />
    {:else if activeTab === "Passengers"}
      <Passengers />
    {:else if activeTab === "Flights"}
      <Flights />
    {/if}
  {/if}
{:else}
  <div
    class="fixed inset-0 w-full h-full bg-purple-700 text-white flex flex-col items-center justify-center"
  >
    <i class="text-9xl fa-solid fa-tower-cell fa-beat"></i>
  </div>
{/if}
