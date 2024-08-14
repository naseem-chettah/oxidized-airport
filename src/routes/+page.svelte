<script>
  import Header from "../lib/Header.svelte";
  import Airplanes from "../lib/Pages/Airplanes.svelte" 
    import Flights from "../lib/Pages/Flights.svelte";

  let tabs = ["Airplanes", "Airports", "Passengers", "Flights"];
  let activeTab = "Airplanes";

  const tabChange = (e) => {
    activeTab = e.detail;
  };

</script>

<Header {tabs} {activeTab} on:tabChange={tabChange} />
<br />
{#if activeTab === "Airplanes"}
  <Airplanes />
{:else if activeTab === "Airports"}
  <!-- content here -->
{:else if activeTab === "Airports"}
  <!-- content here -->
{:else if activeTab === "Passengers"}
  <!-- content here -->
{:else if activeTab === "Flights"}
  <Flights />
{/if}
