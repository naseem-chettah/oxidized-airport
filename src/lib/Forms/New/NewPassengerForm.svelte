<script>
  import { invoke } from "@tauri-apps/api/tauri";

  let loading = false;
  let error = null;

  let firstName;
  let lastName;
  let passportNumber;

  async function insertNewPassenger() {
    loading = true;
    error = null;
    try {
      await invoke("insert_passenger_to_db", {
        firstName,
        lastName,
        passportNumber,
      });
    } catch (err) {
      error = "Error adding new passenger: " + (err.message || err);
    } finally {
      loading = false;
      firstName = "";
      lastName = "";
      passportNumber = "";
    }
  }
</script>

<div
  class="bg-white rounded-lg shadow sm:max-w-md sm:w-full sm:mx-auto sm:overflow-hidden my-5"
>
  <div class="px-4 py-8 sm:px-10">
    <div class="relative mt-6">
      <div class="absolute inset-0 flex items-center">
        <div class="w-full border-t border-gray-300"></div>
      </div>
      <div class="relative flex justify-center text-sm leading-5">
        <span class="px-2 text-gray-500 bg-white"> Add a new passenger </span>
      </div>
    </div>
    <div class="mt-6">
      <div class="w-full space-y-6">
        <div class="w-full">
          <div class=" relative">
            <input
              type="text"
              class=" rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
              placeholder="First Name"
              bind:value={firstName}
            />
          </div>
        </div>
        <div class="w-full">
          <div class=" relative">
            <input
              type="text"
              class=" rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
              placeholder="Last Name"
              bind:value={lastName}
            />
          </div>
        </div>
        <div class="w-full">
          <div class=" relative">
            <input
              type="text"
              class=" rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
              placeholder="Passport Number"
              bind:value={passportNumber}
            />
          </div>
        </div>
        <div>
          <span class="block w-full rounded-md shadow-sm">
            <button
              type="button"
              class="py-2 px-4 bg-indigo-600 hover:bg-indigo-700 focus:ring-indigo-500 focus:ring-offset-indigo-200 text-white w-full transition ease-in duration-200 text-center text-base font-semibold shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 rounded-lg"
              on:click={insertNewPassenger}
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
        Example: John, Doe, QCYBSM9F4
      </p>
    {:else}
      <p class="text-xs leading-5 text-red-500">
        {error}
      </p>
    {/if}
  </div>
</div>
