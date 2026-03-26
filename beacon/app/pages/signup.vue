<template>
  <div class="auth-page">
    <div class="container container-content py-16">
      <div class="auth-card">
        <div class="auth-header">
          <h1>Create Your Account</h1>
          <p class="auth-subtitle">
            Start your independent publishing journey on Beacon
          </p>
        </div>

        <form @submit.prevent="handleSignUp" class="auth-form" novalidate>
          <div class="form-group">
            <label for="username" class="label label-required">Username</label>
            <input
              id="username"
              v-model="form.username"
              type="text"
              class="input"
              :class="{ 'input-error': errors.username }"
              placeholder="your-username"
              autocomplete="username"
              required
              aria-describedby="username-hint username-error"
              :aria-invalid="!!errors.username"
            >
            <span id="username-hint" class="form-hint">
              3-30 characters. Letters, numbers, hyphens, and underscores only.
            </span>
            <span v-if="errors.username" id="username-error" class="form-error" role="alert">
              {{ errors.username }}
            </span>
          </div>

          <div class="form-group">
            <label for="display-name" class="label label-required">Display Name</label>
            <input
              id="display-name"
              v-model="form.displayName"
              type="text"
              class="input"
              :class="{ 'input-error': errors.displayName }"
              placeholder="Your Name"
              autocomplete="name"
              required
              aria-describedby="display-name-error"
              :aria-invalid="!!errors.displayName"
            >
            <span v-if="errors.displayName" id="display-name-error" class="form-error" role="alert">
              {{ errors.displayName }}
            </span>
          </div>

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
            <label for="password" class="label label-required">Password</label>
            <input
              id="password"
              v-model="form.password"
              type="password"
              class="input"
              :class="{ 'input-error': errors.password }"
              placeholder="••••••••"
              autocomplete="new-password"
              required
              aria-describedby="password-hint password-error"
              :aria-invalid="!!errors.password"
            >
            <span id="password-hint" class="form-hint">
              At least 8 characters
            </span>
            <span v-if="errors.password" id="password-error" class="form-error" role="alert">
              {{ errors.password }}
            </span>
          </div>

          <div v-if="generalError" class="alert alert-error" role="alert">
            {{ generalError }}
          </div>

          <div v-if="successMessage" class="alert alert-success" role="alert">
            {{ successMessage }}
          </div>

          <button
            type="submit"
            class="btn btn-primary"
            style="width: 100%;"
            :disabled="isSubmitting"
          >
            <span v-if="isSubmitting" class="spinner" aria-hidden="true"></span>
            {{ isSubmitting ? 'Creating Account...' : 'Create Account' }}
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
          Sign up with Magic Link
        </button>

        <div class="auth-footer">
          <p>
            Already have an account?
            <NuxtLink to="/login" class="auth-link">Sign in</NuxtLink>
          </p>
          <p class="auth-terms">
            By signing up, you agree to our
            <NuxtLink to="/terms">Terms of Service</NuxtLink> and
            <NuxtLink to="/privacy">Privacy Policy</NuxtLink>
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
  title: 'Sign Up - Beacon',
  meta: [
    {
      name: 'description',
      content: 'Create your Beacon account and start publishing your independent newsletter.'
    }
  ]
})

const { signUp, signInWithMagicLink } = useAuth()

const form = reactive({
  username: '',
  displayName: '',
  email: '',
  password: '',
})

const errors = reactive({
  username: '',
  displayName: '',
  email: '',
  password: '',
})

const generalError = ref('')
const successMessage = ref('')
const isSubmitting = ref(false)
const isMagicLinkSending = ref(false)

const validateForm = () => {
  // Reset errors
  errors.username = ''
  errors.displayName = ''
  errors.email = ''
  errors.password = ''
  generalError.value = ''

  let isValid = true

  // Validate username
  if (!form.username) {
    errors.username = 'Username is required'
    isValid = false
  } else if (form.username.length < 3 || form.username.length > 30) {
    errors.username = 'Username must be 3-30 characters'
    isValid = false
  } else if (!/^[a-z0-9_-]+$/.test(form.username)) {
    errors.username = 'Username can only contain lowercase letters, numbers, hyphens, and underscores'
    isValid = false
  }

  // Validate display name
  if (!form.displayName) {
    errors.displayName = 'Display name is required'
    isValid = false
  } else if (form.displayName.length < 2) {
    errors.displayName = 'Display name must be at least 2 characters'
    isValid = false
  }

  // Validate email
  if (!form.email) {
    errors.email = 'Email is required'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
    errors.email = 'Please enter a valid email address'
    isValid = false
  }

  // Validate password
  if (!form.password) {
    errors.password = 'Password is required'
    isValid = false
  } else if (form.password.length < 8) {
    errors.password = 'Password must be at least 8 characters'
    isValid = false
  }

  return isValid
}

const handleSignUp = async () => {
  if (!validateForm()) {
    return
  }

  isSubmitting.value = true
  generalError.value = ''
  successMessage.value = ''

  const { data, error } = await signUp(
    form.email,
    form.password,
    {
      username: form.username,
      display_name: form.displayName,
    }
  )

  isSubmitting.value = false

  if (error) {
    if (error.message.includes('User already registered')) {
      generalError.value = 'This email is already registered. Please sign in instead.'
    } else if (error.message.includes('Username')) {
      errors.username = 'This username is already taken'
    } else {
      generalError.value = error.message
    }
    return
  }

  if (data.user) {
    successMessage.value = 'Account created! Please check your email to verify your account.'
    
    // Clear form
    form.username = ''
    form.displayName = ''
    form.email = ''
    form.password = ''

    // Redirect after 2 seconds
    setTimeout(() => {
      navigateTo('/auth/check-email')
    }, 2000)
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
  successMessage.value = ''

  const { error } = await signInWithMagicLink(form.email)

  isMagicLinkSending.value = false

  if (error) {
    generalError.value = error.message
    return
  }

  successMessage.value = 'Magic link sent! Check your email to sign up.'
  
  setTimeout(() => {
    navigateTo('/auth/check-email')
  }, 2000)
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
  margin-bottom: var(--space-3);
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

.auth-terms {
  font-size: var(--font-size-xs);
}

.auth-terms a {
  color: var(--color-brand-primary);
  text-decoration: none;
}

.auth-terms a:hover {
  text-decoration: underline;
}

/* Alert styles */
.alert {
  margin-bottom: var(--space-4);
}
</style>
