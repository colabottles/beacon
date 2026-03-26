export default defineNuxtPlugin(async () => {
  const { initAuth } = useAuth()
  
  // Initialize auth state when app loads
  await initAuth()
})
