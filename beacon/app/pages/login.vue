<template>
  <div class="auth-page">
    <div class="container container-content py-16">
      <div class="auth-card">
        <div class="auth-header">
          <h1>Welcome Back</h1>
          <p class="auth-subtitle">
            Sign in to your Beacon account
          </p>
        </div>

        <form @submit.prevent="handleSignIn" class="auth-form" novalidate>
          <div class="form-group">
            <label for="email" class="label label-required">Email</label>
            <input
              id="email"
              v-model="form.email"
              type="email"
              class="input"
              :class="{ 'input-error': errors.email }"
              placeholder="you@example.com"
              autocomplete="email"
              required
              aria-describedby="email-error"
              :aria-invalid="!!errors.email"
            >
            <span v-if="errors.email" id="email-error" class="form-error" role="alert">
              {{ errors.email }}
            </span>
          </div>

          <div class="form-group">
            <div class="label-row">
              <label for="password" class="label label-required">Password</label>
              <NuxtLink to="/forgot-password" class="forgot-link">
                Forgot password?
              </NuxtLink>
            </div>
            <input
              id="password"
              v-model="form.password"
              type="password"
              class="input"
              :class="{ 'input-error': errors.password }"
              placeholder="••••••••"
              autocomplete="current-password"
              required
              aria-describedby="password-error"
              :aria-invalid="!!errors.password"
            >
            <span v-if="errors.password" id="password-error" class="form-error" role="alert">
              {{ errors.password }}
            </span>
          </div>

          <div v-if="generalError" class="alert alert-error" role="alert">
            {{ generalError }}
          </div>

          <button
            type="submit"
            class="btn btn-primary"
            style="width: 100%;"
            :disabled="isSubmitting"
          >
            <span v-if="isSubmitting" class="spinner" aria-hidden="true"></span>
            {{ isSubmitting ? 'Signing In...' : 'Sign In' }}
          </button>
        </form>

        <div class="auth-divider">
          <span>or</span>
        </div>

        <button
          @click="handleMagicLink"
          class="btn btn-secondary"
          style="width: 100%;"
          :disabled="isMagicLinkSending || !form.email"
        >
          Sign in with Magic Link
        </button>

        <div class="auth-footer">
          <p>
            Don't have an account?
            <NuxtLink to="/signup" class="auth-link">Sign up</NuxtLink>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'

definePageMeta({
  layout: 'default',
})

useHead({
  title: 'Sign In - Beacon',
  meta: [
    {
      name: 'description',
      content: 'Sign in to your Beacon account to manage your publications.'
    }
  ]
})

const { signIn, signInWithMagicLink } = useAuth()
const route = useRoute()

const form = reactive({
  email: '',
  password: '',
})

const errors = reactive({
  email: '',
  password: '',
})

const generalError = ref('')
const isSubmitting = ref(false)
const isMagicLinkSending = ref(false)

const validateForm = () => {
  errors.email = ''
  errors.password = ''
  generalError.value = ''

  let isValid = true

  if (!form.email) {
    errors.email = 'Email is required'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
    errors.email = 'Please enter a valid email address'
    isValid = false
  }

  if (!form.password) {
    errors.password = 'Password is required'
    isValid = false
  }

  return isValid
}

const handleSignIn = async () => {
  if (!validateForm()) {
    return
  }

  isSubmitting.value = true
  generalError.value = ''

  const { data, error } = await signIn(form.email, form.password)

  isSubmitting.value = false

  if (error) {
    if (error.message.includes('Invalid login credentials')) {
      generalError.value = 'Invalid email or password'
    } else if (error.message.includes('Email not confirmed')) {
      generalError.value = 'Please verify your email address before signing in'
    } else {
      generalError.value = error.message
    }
    return
  }

  if (data.user) {
    // Redirect to intended page or dashboard
    const redirect = route.query.redirect as string
    navigateTo(redirect || '/dashboard')
  }
}

const handleMagicLink = async () => {
  if (!form.email) {
    errors.email = 'Please enter your email address'
    return
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
    errors.email = 'Please enter a valid email address'
    return
  }

  isMagicLinkSending.value = true
  generalError.value = ''

  const { error } = await signInWithMagicLink(form.email)

  isMagicLinkSending.value = false

  if (error) {
    generalError.value = error.message
    return
  }

  navigateTo('/auth/check-email')
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
}

.auth-form {
  margin-bottom: var(--space-6);
}

.label-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-2);
}

.forgot-link {
  font-size: var(--font-size-sm);
  color: var(--color-brand-primary);
  text-decoration: none;
}

.forgot-link:hover {
  text-decoration: underline;
}

.auth-divider {
  position: relative;
  text-align: center;
  margin: var(--space-6) 0;
}

.auth-divider::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  height: 1px;
  background-color: var(--color-border);
  z-index: 0;
}

.auth-divider span {
  position: relative;
  background-color: var(--color-bg-primary);
  padding: 0 var(--space-4);
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  z-index: 1;
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

.alert {
  margin-bottom: var(--space-4);
}
</style>
