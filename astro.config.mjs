import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  integrations: [tailwind()],
  // Set this to your repo name if deploying to username.github.io/repo-name
  // base: '/resume',
});
