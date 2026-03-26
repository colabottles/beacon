<template>
  <div class="create-publication-page">
    <div class="container container-content py-12">
      <div class="page-header">
        <h1>Create Your Publication</h1>
        <p class="page-subtitle">
          Start your independent newsletter and build your audience
        </p>
      </div>

      <form @submit.prevent="handleSubmit" class="publication-form" novalidate>
        <div class="form-section">
          <h2 class="section-heading">Basic Information</h2>
          
          <div class="form-group">
            <label for="title" class="label label-required">Publication Title</label>
            <input
              id="title"
              v-model="form.title"
              type="text"
              class="input"
              :class="{ 'input-error': errors.title }"
              placeholder="My Amazing Newsletter"
              required
              aria-describedby="title-hint title-error"
              :aria-invalid="!!errors.title"
              @input="handleTitleChange"
            >
            <span id="title-hint" class="form-hint">
              This is the name readers will see
            </span>
            <span v-if="errors.title" id="title-error" class="form-error" role="alert">
              {{ errors.title }}
            </span>
          </div>

          <div class="form-group">
            <label for="slug" class="label label-required">URL Slug</label>
            <div class="slug-input-wrapper">
              <span class="slug-prefix" aria-hidden="true">beacon.pub/</span>
              <input
                id="slug"
                v-model="form.slug"
                type="text"
                class="input slug-input"
                :class="{ 'input-error': errors.slug }"
                placeholder="my-newsletter"
                required
                aria-describedby="slug-hint slug-error"
                :aria-invalid="!!errors.slug"
                @blur="validateSlug"
              >
            </div>
            <span id="slug-hint" class="form-hint">
              Your publication will be at beacon.pub/{{ form.slug || 'your-slug' }}
            </span>
            <span v-if="errors.slug" id="slug-error" class="form-error" role="alert">
              {{ errors.slug }}
            </span>
            <span v-if="slugChecking" class="form-hint">
              <span class="spinner" style="width: 12px; height: 12px; display: inline-block; vertical-align: middle;"></span>
              Checking availability...
            </span>
            <span v-if="slugAvailable && !errors.slug && form.slug" class="form-success">
              ✓ This URL is available
            </span>
          </div>

          <div class="form-group">
            <label for="description" class="label">Description</label>
            <textarea
              id="description"
              v-model="form.description"
              class="input textarea"
              :class="{ 'input-error': errors.description }"
              placeholder="What's your publication about? (optional)"
              rows="4"
              aria-describedby="description-hint description-error"
              :aria-invalid="!!errors.description"
            ></textarea>
            <span id="description-hint" class="form-hint">
              Help readers understand what you'll be writing about
            </span>
            <span v-if="errors.description" id="description-error" class="form-error" role="alert">
              {{ errors.description }}
            </span>
          </div>
        </div>

        <div v-if="generalError" class="alert alert-error" role="alert">
          {{ generalError }}
        </div>

        <div class="form-actions">
          <button
            type="submit"
            class="btn btn-primary btn-lg"
            :disabled="isSubmitting || slugChecking"
          >
            <span v-if="isSubmitting" class="spinner" aria-hidden="true"></span>
            {{ isSubmitting ? 'Creating...' : 'Create Publication' }}
          </button>
          <NuxtLink to="/dashboard" class="btn btn-secondary btn-lg">
            Cancel
          </NuxtLink>
        </div>
      </form>

      <div class="help-box">
        <h3>What happens next?</h3>
        <ul role="list">
          <li>✓ Your publication will be created instantly</li>
          <li>✓ You can customize your settings and branding</li>
          <li>✓ Start writing and publishing immediately</li>
          <li>✓ Set up paid subscriptions whenever you're ready</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'

definePageMeta({
  middleware: 'auth',
})

useHead({
  title: 'Create Publication - Beacon',
})

const { createPublication, generateSlug, checkSlugAvailability } = usePublications()

const form = reactive({
  title: '',
  slug: '',
  description: '',
})

const errors = reactive({
  title: '',
  slug: '',
  description: '',
})

const generalError = ref('')
const isSubmitting = ref(false)
const slugChecking = ref(false)
const slugAvailable = ref(false)
const hasManuallyEditedSlug = ref(false)

const handleTitleChange = () => {
  // Auto-generate slug from title if user hasn't manually edited it
  if (!hasManuallyEditedSlug.value && form.title) {
    form.slug = generateSlug(form.title)
    validateSlug()
  }
}

const validateSlug = async () => {
  if (!form.slug) return

  hasManuallyEditedSlug.value = true
  errors.slug = ''

  // Client-side validation
  if (!/^[a-z0-9-]+$/.test(form.slug)) {
    errors.slug = 'Slug can only contain lowercase letters, numbers, and hyphens'
    slugAvailable.value = false
    return
  }

  if (form.slug.length < 3) {
    errors.slug = 'Slug must be at least 3 characters'
    slugAvailable.value = false
    return
  }

  if (form.slug.startsWith('-') || form.slug.endsWith('-')) {
    errors.slug = 'Slug cannot start or end with a hyphen'
    slugAvailable.value = false
    return
  }

  // Check availability
  slugChecking.value = true
  const { available, error } = await checkSlugAvailability(form.slug)
  slugChecking.value = false

  if (error) {
    errors.slug = 'Error checking availability'
    slugAvailable.value = false
    return
  }

  if (!available) {
    errors.slug = 'This URL is already taken'
    slugAvailable.value = false
  } else {
    slugAvailable.value = true
  }
}

const validateForm = (): boolean => {
  // Reset errors
  errors.title = ''
  errors.slug = ''
  errors.description = ''
  generalError.value = ''

  let isValid = true

  // Validate title
  if (!form.title.trim()) {
    errors.title = 'Publication title is required'
    isValid = false
  } else if (form.title.length < 3) {
    errors.title = 'Title must be at least 3 characters'
    isValid = false
  } else if (form.title.length > 100) {
    errors.title = 'Title must be less than 100 characters'
    isValid = false
  }

  // Validate slug
  if (!form.slug.trim()) {
    errors.slug = 'URL slug is required'
    isValid = false
  } else if (!/^[a-z0-9-]+$/.test(form.slug)) {
    errors.slug = 'Slug can only contain lowercase letters, numbers, and hyphens'
    isValid = false
  } else if (form.slug.length < 3) {
    errors.slug = 'Slug must be at least 3 characters'
    isValid = false
  } else if (!slugAvailable.value) {
    errors.slug = 'This URL is not available'
    isValid = false
  }

  // Validate description (optional)
  if (form.description && form.description.length > 500) {
    errors.description = 'Description must be less than 500 characters'
    isValid = false
  }

  return isValid
}

const handleSubmit = async () => {
  if (!validateForm()) {
    return
  }

  isSubmitting.value = true
  generalError.value = ''

  const { data, error } = await createPublication({
    title: form.title.trim(),
    slug: form.slug.trim(),
    description: form.description.trim() || undefined,
  })

  isSubmitting.value = false

  if (error) {
    if (error.message.includes('duplicate key')) {
      errors.slug = 'This URL is already taken'
    } else {
      generalError.value = error.message
    }
    return
  }

  if (data) {
    // Success! Redirect to publication settings
    navigateTo(`/publications/${data.id}/settings`)
  }
}
</script>

<style scoped>
.page-header {
  text-align: center;
  margin-bottom: var(--space-12);
}

.page-header h1 {
  font-size: var(--font-size-4xl);
  margin-bottom: var(--space-3);
}

.page-subtitle {
  font-size: var(--font-size-lg);
  color: var(--color-text-secondary);
}

.publication-form {
  max-width: 700px;
  margin: 0 auto var(--space-12);
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-8);
}

.form-section {
  margin-bottom: var(--space-8);
}

.section-heading {
  font-size: var(--font-size-xl);
  margin-bottom: var(--space-6);
  padding-bottom: var(--space-4);
  border-bottom: 1px solid var(--color-border);
}

.slug-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.slug-prefix {
  position: absolute;
  left: var(--space-4);
  color: var(--color-text-tertiary);
  font-size: var(--font-size-base);
  pointer-events: none;
  user-select: none;
}

.slug-input {
  padding-left: 115px;
}

.form-success {
  display: block;
  font-size: var(--font-size-sm);
  color: var(--color-success);
  margin-top: var(--space-2);
}

.form-actions {
  display: flex;
  gap: var(--space-4);
  padding-top: var(--space-6);
  border-top: 1px solid var(--color-border);
}

.help-box {
  max-width: 700px;
  margin: 0 auto;
  background: var(--color-bg-secondary);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
}

.help-box h3 {
  font-size: var(--font-size-lg);
  margin-bottom: var(--space-4);
}

.help-box ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.help-box li {
  padding: var(--space-2) 0;
  color: var(--color-text-secondary);
}

@media (max-width: 768px) {
  .form-actions {
    flex-direction: column;
  }

  .slug-prefix {
    font-size: var(--font-size-sm);
  }

  .slug-input {
    padding-left: 100px;
  }
}
</style>
