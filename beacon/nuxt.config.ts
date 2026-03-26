// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  
  future: {
    compatibilityVersion: 4
  },

  app: {
    head: {
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1',
      title: 'Beacon - Independent Publishing Platform',
      meta: [
        { name: 'description', content: 'A publishing platform for independent writers and journalists who believe in truth, dignity, and the open web.' }
      ],
      htmlAttrs: {
        lang: 'en'
      }
    }
  },

  modules: [
    '@nuxt/image',
    '@nuxt/eslint'
  ],

  css: [
    '~/assets/css/reset.css',
    '~/assets/css/variables.css',
    '~/assets/css/typography.css',
    '~/assets/css/layout.css',
    '~/assets/css/components.css'
  ],

  runtimeConfig: {
    // Private keys (server-only)
    supabaseServiceKey: '',
    stripeSecretKey: '',
    resendApiKey: '',
    
    // Public keys (client & server)
    public: {
      supabaseUrl: '',
      supabaseAnonKey: '',
      stripePublishableKey: '',
      siteUrl: process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3000'
    }
  },

  typescript: {
    strict: true,
    typeCheck: true
  },

  nitro: {
    preset: 'netlify'
  }
})
