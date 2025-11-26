import tsconfigPaths from 'vite-tsconfig-paths'
import { defineWorkersConfig } from '@cloudflare/vitest-pool-workers/config'

export default defineWorkersConfig({
  plugins: [tsconfigPaths()],
  test: {
    include: ['tests/**/*.test.ts'],
    globalSetup: './tests/global-setup.ts',
    pool: '@cloudflare/vitest-pool-workers',
    poolOptions: {
      workers: {
        main: './src/index.ts',
        wrangler: {
          configPath: './wrangler.toml',
        },
      },
    },
  },
})
