<script>
  import { createEventDispatcher } from "svelte";
  const dispatcher = createEventDispatcher();

  export let tabs;
  export let activeTab;
</script>

<div
  class="text-sm font-medium text-center text-gray-500 border-b border-gray-200"
>
  <ul class="flex flex-wrap justify-center -mb-px">
    {#each tabs as tab}
      <li class="mr-2">
        <!-- svelte-ignore a11y-click-events-have-key-events -->
        <!-- svelte-ignore a11y-no-static-element-interactions -->
        <div
          on:click={() => dispatcher("tabChange", tab)}
          class="tab"
          class:selected-tab={tab === activeTab}
          class:active={tab === activeTab}
        >
          {#if tab === "Airplanes"}
            <i class="fa-solid fa-plane"></i>
          {:else if tab === "Airports"}
            <i class="fa-solid fa-cart-flatbed-suitcase"></i>
          {:else if tab === "Passengers"}
            <i class="fa-solid fa-person-walking-luggage"></i>
          {:else if tab === "Flights"}
            <i class="fa-solid fa-plane-departure"></i>
          {/if}
          {tab}
        </div>
      </li>
    {/each}
  </ul>
</div>
