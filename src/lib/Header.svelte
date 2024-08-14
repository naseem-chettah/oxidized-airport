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
          {tab}
        </div>
      </li>
    {/each}
  </ul>
</div>
