<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";

  let dbConnectionError = null;
  let loading = false;

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
        connection and <button class="underline" on:click={checkConnection}
          >try again</button
        > later.
      </p>
    </div>
  {:else if !dbConnectionError}
    hello
  {/if}
{:else}
  <div
    class="fixed inset-0 w-full h-full bg-purple-700 text-white flex flex-col items-center justify-center"
  >
    <i class="text-9xl fa-solid fa-tower-cell fa-beat"></i>
  </div>
{/if}
