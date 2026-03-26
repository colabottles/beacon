<template>
  <div class="auth-page">
    <div class="container container-content py-16">
      <div class="auth-card">
        <div class="auth-header">
          <h1>Reset Your Password</h1>
          <p class="auth-subtitle">
            Enter your email and we'll send you a link to reset your password
          </p>
        </div>

        <form v-if="!emailSent" @submit.prevent="handleResetPassword" class="auth-form" novalidate>
          <div class="form-group">
            <label for="email" class="label label-required">Email</label>
            <input
              id="email"
              v-model="email"
              type="email"
              class="input"
              :class="{ 'input-error': error }"
              placeholder="you@example.com"
              autocomplete="email"
              required
              aria-describedby="email-error"
              :aria-invalid="!!error"
            >
            <span v-if="error" id="email-error" class="form-error" role="alert">
              {{ error }}
            </span>
          </div>

          <button
            type="submit"
            class="btn btn-primary"
            style="width: 100%;"
            :disabled="isSubmitting"
          >
            <span v-if="isSubmitting" class="spinner" aria-hidden="true"></span>
            {{ isSubmitting ? 'Sending...' : 'Send Reset Link' }}
          </button>
        </form>

        <div v-else class="success-message">
          <div class="success-icon" aria-hidden="true">✓</div>
          <h2>Check Your Email</h2>
          <p>
            We've sent a password reset link to <strong>{{ email }}</strong>.
            Click the link in the email to reset your password.
          </p>
        </div>

        <div class="auth-footer">
          <p>
            Remember your password?
            <NuxtLink to="/login" class="auth-link">Sign in</NuxtLink>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

useHead({
  title: 'Reset Password - Beacon',
})

const { resetPassword } = useAuth()

const email = ref('')
const error = ref('')
const isSubmitting = ref(false)
const emailSent = ref(false)

const handleResetPassword = async () => {
  error.value = ''

  if (!email.value) {
    error.value = 'Email is required'
    return
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
    error.value = 'Please enter a valid email address'
    return
  }

  isSubmitting.value = true

  const { error: resetError } = await resetPassword(email.value)

  isSubmitting.value = false

  if (resetError) {
    error.value = resetError.message
    return
  }

  emailSent.value = true
}
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
  margin-bottom: var(--space-8);
}

.auth-header h1 {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-3);
}

.auth-subtitle {
  color: var(--color-text-secondary);
  font-size: var(--font-size-lg);
  line-height: var(--line-height-relaxed);
}

.auth-form {
  margin-bottom: var(--space-6);
}

.success-message {
  text-align: center;
  padding: var(--space-8) 0;
}

.success-icon {
  width: 64px;
  height: 64px;
  margin: 0 auto var(--space-6);
  background-color: var(--color-success-bg);
  color: var(--color-success);
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: var(--font-size-3xl);
  font-weight: var(--font-weight-bold);
}

.success-message h2 {
  font-size: var(--font-size-2xl);
  margin-bottom: var(--space-4);
}

.success-message p {
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
}

.auth-footer {
  margin-top: var(--space-6);
  padding-top: var(--space-6);
  border-top: 1px solid var(--color-border);
  text-align: center;
}

.auth-footer p {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
}

.auth-link {
  color: var(--color-brand-primary);
  text-decoration: none;
  font-weight: var(--font-weight-medium);
}

.auth-link:hover {
  text-decoration: underline;
}
</style>
