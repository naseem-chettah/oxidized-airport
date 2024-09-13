<script>
  import "@fortawesome/fontawesome-free/css/all.css";
  import "../app.css";

  import Header from "@/share/Header.svelte";
  import Footer from "@/share/Footer.svelte";
  import { ModeWatcher } from "mode-watcher";
</script>

<ModeWatcher />
<main class="flex flex-col min-h-screen">
  <Header></Header>

  <slot></slot>

  <Footer></Footer>
</main>
