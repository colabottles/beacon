<template>
  <div class="settings-page">
    <div class="container container-content py-12">
      <div class="page-header">
        <div>
          <NuxtLink to="/dashboard" class="back-link">
            ← Back to Dashboard
          </NuxtLink>
          <h1>Publication Settings</h1>
          <p v-if="publication" class="page-subtitle">
            {{ publication.title }}
          </p>
        </div>
      </div>

      <div v-if="loading" class="loading-state">
        <span class="spinner"></span>
        <p>Loading settings...</p>
      </div>

      <div v-else-if="error" class="alert alert-error">
        {{ error }}
      </div>

      <div v-else-if="publication" class="settings-content">
        <form @submit.prevent="handleSave" class="settings-form" novalidate>
          <div class="form-section">
            <h2 class="section-heading">Basic Information</h2>
            
            <div class="form-group">
              <label for="title" class="label label-required">Publication Title</label>
              <input
                id="title"
                v-model="form.title"
                type="text"
                class="input"
                :class="{ 'input-error': formErrors.title }"
                required
              >
              <span v-if="formErrors.title" class="form-error" role="alert">
                {{ formErrors.title }}
              </span>
            </div>

            <div class="form-group">
              <label for="description" class="label">Description</label>
              <textarea
                id="description"
                v-model="form.description"
                class="input textarea"
                rows="4"
                placeholder="What's your publication about?"
              ></textarea>
            </div>

            <div class="form-group">
              <label class="label">Publication URL</label>
              <div class="url-display">
                <span class="url-text">beacon.pub/{{ publication.slug }}</span>
                <span class="url-hint">URL cannot be changed after creation</span>
              </div>
            </div>
          </div>

          <div class="form-section">
            <h2 class="section-heading">Settings</h2>
            
            <div class="form-group">
              <label class="checkbox-label">
                <input
                  v-model="form.allowComments"
                  type="checkbox"
                  class="checkbox"
                >
                <span>Allow comments on posts</span>
              </label>
            </div>

            <div class="form-group">
              <label class="checkbox-label">
                <input
                  v-model="form.welcomeEmailEnabled"
                  type="checkbox"
                  class="checkbox"
                >
                <span>Send welcome email to new subscribers</span>
              </label>
            </div>
          </div>

          <div v-if="saveError" class="alert alert-error" role="alert">
            {{ saveError }}
          </div>

          <div v-if="saveSuccess" class="alert alert-success" role="alert">
            Settings saved successfully!
          </div>

          <div class="form-actions">
            <button
              type="submit"
              class="btn btn-primary"
              :disabled="isSaving"
            >
              <span v-if="isSaving" class="spinner" aria-hidden="true"></span>
              {{ isSaving ? 'Saving...' : 'Save Changes' }}
            </button>
            <NuxtLink :to="`/${publication.slug}`" class="btn btn-secondary" target="_blank">
              View Publication
            </NuxtLink>
          </div>
        </form>

        <div class="danger-zone">
          <h2 class="section-heading">Danger Zone</h2>
          <div class="danger-content">
            <div>
              <h3>Delete Publication</h3>
              <p>Once you delete a publication, there is no going back. Please be certain.</p>
            </div>
            <button @click="showDeleteConfirm = true" class="btn btn-secondary">
              Delete Publication
            </button>
          </div>
        </div>
      </div>

      <!-- Delete confirmation modal -->
      <div v-if="showDeleteConfirm" class="modal-overlay" @click.self="showDeleteConfirm = false">
        <div class="modal" role="dialog" aria-labelledby="delete-modal-title" aria-modal="true">
          <h2 id="delete-modal-title">Delete Publication?</h2>
          <p>
            This will permanently delete <strong>{{ publication?.title }}</strong> and all of its posts, subscribers, and settings.
          </p>
          <p class="warning-text">
            This action cannot be undone.
          </p>
          <div class="modal-actions">
            <button @click="handleDelete" class="btn btn-primary" :disabled="isDeleting">
              <span v-if="isDeleting" class="spinner" aria-hidden="true"></span>
              {{ isDeleting ? 'Deleting...' : 'Yes, Delete' }}
            </button>
            <button @click="showDeleteConfirm = false" class="btn btn-secondary">
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'

definePageMeta({
  middleware: 'auth',
})

const route = useRoute()
const publicationId = route.params.id as string

const { getPublication, updatePublication, deletePublication } = usePublications()

const publication = ref(null)
const loading = ref(true)
const error = ref('')
const isSaving = ref(false)
const isDeleting = ref(false)
const saveError = ref('')
const saveSuccess = ref(false)
const showDeleteConfirm = ref(false)

const form = reactive({
  title: '',
  description: '',
  allowComments: true,
  welcomeEmailEnabled: true,
})

const formErrors = reactive({
  title: '',
})

onMounted(async () => {
  const { data, error: fetchError } = await getPublication(publicationId)
  
  if (fetchError || !data) {
    error.value = 'Publication not found'
    loading.value = false
    return
  }

  publication.value = data
  
  // Populate form
  form.title = data.title
  form.description = data.description || ''
  form.allowComments = data.allow_comments
  form.welcomeEmailEnabled = data.welcome_email_enabled
  
  loading.value = false
})

useHead(() => ({
  title: publication.value ? `${publication.value.title} Settings - Beacon` : 'Settings - Beacon'
}))

const validateForm = (): boolean => {
  formErrors.title = ''
  
  if (!form.title.trim()) {
    formErrors.title = 'Title is required'
    return false
  }
  
  return true
}

const handleSave = async () => {
  if (!validateForm()) return
  
  isSaving.value = true
  saveError.value = ''
  saveSuccess.value = false

  const { data, error: updateError } = await updatePublication(publicationId, {
    title: form.title.trim(),
    description: form.description.trim() || null,
    allow_comments: form.allowComments,
    welcome_email_enabled: form.welcomeEmailEnabled,
  })

  isSaving.value = false

  if (updateError) {
    saveError.value = updateError.message
    return
  }

  if (data) {
    publication.value = data
    saveSuccess.value = true
    
    // Hide success message after 3 seconds
    setTimeout(() => {
      saveSuccess.value = false
    }, 3000)
  }
}

const handleDelete = async () => {
  isDeleting.value = true
  
  const { error: deleteError } = await deletePublication(publicationId)
  
  isDeleting.value = false

  if (deleteError) {
    alert('Failed to delete publication: ' + deleteError.message)
    showDeleteConfirm.value = false
    return
  }

  // Redirect to dashboard
  navigateTo('/dashboard')
}
</script>

<style scoped>
.page-header {
  margin-bottom: var(--space-8);
}

.back-link {
  display: inline-block;
  color: var(--color-brand-primary);
  text-decoration: none;
  margin-bottom: var(--space-4);
  font-size: var(--font-size-sm);
}

.back-link:hover {
  text-decoration: underline;
}

.page-header h1 {
  font-size: var(--font-size-4xl);
  margin-bottom: var(--space-2);
}

.page-subtitle {
  color: var(--color-text-secondary);
  font-size: var(--font-size-lg);
}

.loading-state {
  text-align: center;
  padding: var(--space-16);
}

.loading-state p {
  margin-top: var(--space-4);
  color: var(--color-text-secondary);
}

.settings-content {
  max-width: 700px;
}

.settings-form {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-8);
  margin-bottom: var(--space-8);
}

.form-section {
  margin-bottom: var(--space-8);
}

.form-section:last-child {
  margin-bottom: 0;
}

.section-heading {
  font-size: var(--font-size-xl);
  margin-bottom: var(--space-6);
  padding-bottom: var(--space-4);
  border-bottom: 1px solid var(--color-border);
}

.url-display {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
  padding: var(--space-3) var(--space-4);
  background: var(--color-bg-secondary);
  border-radius: var(--radius-md);
}

.url-text {
  font-family: var(--font-mono);
  font-size: var(--font-size-base);
  color: var(--color-text-primary);
}

.url-hint {
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  cursor: pointer;
}

.checkbox {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.form-actions {
  display: flex;
  gap: var(--space-4);
  padding-top: var(--space-6);
  border-top: 1px solid var(--color-border);
}

.danger-zone {
  background: var(--color-bg-primary);
  border: 2px solid var(--color-error);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
}

.danger-zone .section-heading {
  color: var(--color-error);
}

.danger-content {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: var(--space-6);
}

.danger-content h3 {
  font-size: var(--font-size-lg);
  margin-bottom: var(--space-2);
}

.danger-content p {
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: var(--z-modal-backdrop);
}

.modal {
  background: var(--color-bg-primary);
  border-radius: var(--radius-xl);
  padding: var(--space-8);
  max-width: 500px;
  margin: var(--space-4);
  z-index: var(--z-modal);
}

.modal h2 {
  font-size: var(--font-size-2xl);
  margin-bottom: var(--space-4);
}

.modal p {
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
  margin-bottom: var(--space-4);
}

.warning-text {
  color: var(--color-error);
  font-weight: var(--font-weight-semibold);
}

.modal-actions {
  display: flex;
  gap: var(--space-3);
  margin-top: var(--space-6);
}

@media (max-width: 768px) {
  .form-actions {
    flex-direction: column;
  }

  .danger-content {
    flex-direction: column;
  }

  .modal-actions {
    flex-direction: column-reverse;
  }
}
</style>
