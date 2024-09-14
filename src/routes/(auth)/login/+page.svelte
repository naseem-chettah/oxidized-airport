<script lang="ts">
  import { Button } from "$lib/components/ui/button/index.js";
  import { Input } from "$lib/components/ui/input/index.js";
  import { Label } from "$lib/components/ui/label/index.js";
</script>

<div class="w-full lg:grid lg:min-h-[600px] lg:grid-cols-2 xl:min-h-[800px]">
  <div class="flex items-center justify-center py-12">
    <div class="mx-auto grid w-[350px] gap-6">
      <div class="grid gap-2 text-center">
        <h1 class="text-3xl font-bold">Login</h1>
      </div>
      <div class="grid gap-4">
        <div class="grid gap-2">
          <Label for="email">Email</Label>
          <Input id="email" type="email" placeholder="m@example.com" required />
        </div>
        <div class="grid gap-2">
          <div class="flex items-center">
            <Label for="password">Password</Label>
          </div>
          <Input id="password" type="password" required />
        </div>
        <a href="##" class="ml-auto inline-block text-sm underline">
          Forgot your password?
        </a>
        <Button type="submit" class="w-full">Login</Button>
      </div>
      <div class="mt-4 text-center text-sm">
        Don&apos;t have an account?
        <a href="/signup" class="underline"> Sign up </a>
      </div>
    </div>
  </div>
  <div class="bg-muted hidden lg:block">
    <img
      src="/logo.jpeg"
      alt="placeholder"
      class="h-full w-full object-cover dark:brightness-[0.2] dark:grayscale"
    />
  </div>
</div>
