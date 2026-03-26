<template>
  <div class="auth-page">
    <div class="container container-content py-16">
      <div class="auth-card">
        <div class="auth-header">
          <div class="loading-icon">
            <span class="spinner"></span>
          </div>
          <h1>Confirming Your Account</h1>
          <p class="auth-subtitle">
            Please wait while we verify your email...
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const { user } = useAuth()

onMounted(async () => {
  // Supabase automatically handles the email confirmation
  // We just need to wait a moment and check if user is authenticated
  
  await new Promise(resolve => setTimeout(resolve, 2000))
  
  if (user.value) {
    // User is authenticated, redirect to dashboard
    navigateTo('/dashboard')
  } else {
    // Something went wrong
    navigateTo('/login?error=confirmation_failed')
  }
})

useHead({
  title: 'Confirming Email - Beacon',
})
</script>

<style scoped>
.auth-page {
  min-height: calc(100vh - 200px);
  display: flex;
  align-items: center;
}

.auth-card {
  max-width: 480px;
  margin: 0 auto;
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-8);
}

.auth-header {
  text-align: center;
}

.loading-icon {
  margin-bottom: var(--space-6);
}

.loading-icon .spinner {
  width: 48px;
  height: 48px;
  border-width: 4px;
}

.auth-header h1 {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-3);
}

.auth-subtitle {
  color: var(--color-text-secondary);
  font-size: var(--font-size-lg);
}
</style>
