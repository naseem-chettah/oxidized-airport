<script>
  export let cols;
  export let rows;
</script>

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
      {#each rows as row}
        <tr class="text-gray-700">
          <td class="border-b-2 p-4 dark:border-dark-5"> {row.model} </td>
          <td class="border-b-2 p-4 dark:border-dark-5"> {row.manufacturer}</td>
          <td class="border-b-2 p-4 dark:border-dark-5"> {row.capacity} </td>
        </tr>
      {/each}
    </tbody>
  </table>
</div>
