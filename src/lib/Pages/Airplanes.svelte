<script>
  import { invoke } from "@tauri-apps/api/tauri";

  import Table from "../Table/Table.svelte";
  let cols = ["model", "man", "capacity"];

  let airplanes;
  let showTable = false;

  async function getAirplanes() {
    airplanes = JSON.parse(await invoke("fetch_airplanes_from_db", {}));
    showTable = true;
  }
</script>

<div>
  <button on:click={getAirplanes}>click</button>
  <p>{airplanes}</p>

  {#if showTable}
    <Table {cols} rows={airplanes} />
  {/if}
</div>
