<template>
  <div class="editor-page">
    <div class="editor-container">
      <div class="editor-header">
        <div class="header-left">
          <NuxtLink :to="`/publications/${publicationId}/settings`" class="back-link">
            ← Back to Publication
          </NuxtLink>
        </div>
        <div class="header-actions">
          <span v-if="lastSaved" class="save-indicator">
            Saved {{ lastSaved }}
          </span>
          <button
            @click="saveDraft"
            class="btn btn-secondary btn-sm"
            :disabled="isSaving"
          >
            {{ isSaving ? 'Saving...' : 'Save Draft' }}
          </button>
          <button
            @click="showPublishModal = true"
            class="btn btn-primary btn-sm"
            :disabled="!canPublish"
          >
            Publish
          </button>
        </div>
      </div>

      <div v-if="error" class="alert alert-error">
        {{ error }}
      </div>

      <form @submit.prevent="saveDraft" class="editor-form">
        <div class="form-group">
          <input
            v-model="form.title"
            type="text"
            class="title-input"
            placeholder="Post title..."
            aria-label="Post title"
            @input="handleTitleChange"
          >
        </div>

        <div class="form-group">
          <input
            v-model="form.subtitle"
            type="text"
            class="subtitle-input"
            placeholder="Subtitle (optional)"
            aria-label="Post subtitle"
          >
        </div>

        <div class="form-group">
          <textarea
            v-model="form.content"
            class="content-editor"
            placeholder="Write your story..."
            aria-label="Post content"
            rows="20"
          ></textarea>
          <div class="editor-hint">
            Supports Markdown. You can use **bold**, *italic*, # headings, and more.
          </div>
        </div>

        <details class="settings-section">
          <summary class="settings-toggle">
            Post Settings
          </summary>
          <div class="settings-content">
            <div class="form-group">
              <label for="slug" class="label">URL Slug</label>
              <input
                id="slug"
                v-model="form.slug"
                type="text"
                class="input"
                placeholder="post-url-slug"
                @blur="validateSlug"
              >
              <span class="form-hint">
                Post will be at: /{{ publication?.slug }}/{{ form.slug || 'your-slug' }}
              </span>
              <span v-if="slugError" class="form-error" role="alert">
                {{ slugError }}
              </span>
            </div>

            <div class="form-group">
              <label for="excerpt" class="label">Excerpt</label>
              <textarea
                id="excerpt"
                v-model="form.excerpt"
                class="input textarea"
                placeholder="Brief description for preview cards and SEO"
                rows="3"
              ></textarea>
              <span class="form-hint">
                Auto-generated if left empty
              </span>
            </div>

            <div class="form-group">
              <label for="visibility" class="label">Visibility</label>
              <select
                id="visibility"
                v-model="form.visibility"
                class="input"
              >
                <option value="free">Free - Anyone can read</option>
                <option value="subscribers">Subscribers - Free & paid subscribers</option>
                <option value="paid">Paid - Paid subscribers only</option>
              </select>
            </div>

            <div class="form-group">
              <label class="checkbox-label">
                <input
                  v-model="form.sendEmail"
                  type="checkbox"
                  class="checkbox"
                >
                <span>Send email to subscribers when published</span>
              </label>
            </div>
          </div>
        </details>
      </form>
    </div>

    <!-- Publish Modal -->
    <div v-if="showPublishModal" class="modal-overlay" @click.self="showPublishModal = false">
      <div class="modal" role="dialog" aria-labelledby="publish-modal-title" aria-modal="true">
        <h2 id="publish-modal-title">Ready to Publish?</h2>
        <div class="publish-preview">
          <h3>{{ form.title || 'Untitled Post' }}</h3>
          <p v-if="form.subtitle" class="subtitle">{{ form.subtitle }}</p>
          <div class="meta">
            <span class="badge">{{ form.visibility }}</span>
            <span v-if="form.sendEmail">📧 Will send email to subscribers</span>
          </div>
        </div>
        <div class="modal-actions">
          <button @click="handlePublish" class="btn btn-primary" :disabled="isPublishing">
            <span v-if="isPublishing" class="spinner" aria-hidden="true"></span>
            {{ isPublishing ? 'Publishing...' : 'Publish Now' }}
          </button>
          <button @click="showPublishModal = false" class="btn btn-secondary">
            Cancel
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onBeforeUnmount } from 'vue'

definePageMeta({
  middleware: 'auth',
  layout: false, // No header/footer for focused writing
})

const route = useRoute()
const publicationId = route.params.id as string

const { getPublication } = usePublications()
const { createPost, generateSlug, checkSlugAvailability } = usePosts()

const publication = ref(null)
const error = ref('')
const isSaving = ref(false)
const isPublishing = ref(false)
const lastSaved = ref('')
const showPublishModal = ref(false)
const slugError = ref('')
const hasManuallyEditedSlug = ref(false)

const form = reactive({
  title: '',
  subtitle: '',
  content: '',
  slug: '',
  excerpt: '',
  visibility: 'free' as 'free' | 'subscribers' | 'paid',
  sendEmail: true,
})

const canPublish = computed(() => {
  return form.title.trim() && form.content.trim() && form.slug.trim() && !slugError.value
})

onMounted(async () => {
  // Load publication
  const { data, error: fetchError } = await getPublication(publicationId)
  
  if (fetchError || !data) {
    error.value = 'Publication not found'
    return
  }

  publication.value = data

  // Auto-save every 30 seconds
  const autoSaveInterval = setInterval(() => {
    if (form.title || form.content) {
      saveDraft(true) // Silent save
    }
  }, 30000)

  onBeforeUnmount(() => {
    clearInterval(autoSaveInterval)
  })
})

useHead(() => ({
  title: form.title ? `${form.title} - Beacon Editor` : 'New Post - Beacon Editor'
}))

const handleTitleChange = () => {
  // Auto-generate slug from title if not manually edited
  if (!hasManuallyEditedSlug.value && form.title) {
    form.slug = generateSlug(form.title)
    validateSlug()
  }
}

const validateSlug = async () => {
  if (!form.slug) return

  hasManuallyEditedSlug.value = true
  slugError.value = ''

  // Client-side validation
  if (!/^[a-z0-9-]+$/.test(form.slug)) {
    slugError.value = 'Slug can only contain lowercase letters, numbers, and hyphens'
    return
  }

  if (form.slug.length < 3) {
    slugError.value = 'Slug must be at least 3 characters'
    return
  }

  // Check availability
  const { available } = await checkSlugAvailability(publicationId, form.slug)

  if (!available) {
    slugError.value = 'This slug is already used by another post'
  }
}

const saveDraft = async (silent: boolean = false) => {
  if (!form.title.trim() || !form.slug.trim()) {
    if (!silent) {
      error.value = 'Title and slug are required'
    }
    return
  }

  isSaving.value = true
  error.value = ''

  const { data, error: saveError } = await createPost(publicationId, {
    title: form.title.trim(),
    slug: form.slug.trim(),
    subtitle: form.subtitle.trim() || undefined,
    content: form.content,
    excerpt: form.excerpt.trim() || undefined,
    visibility: form.visibility,
    status: 'draft',
    send_email: form.sendEmail,
  })

  isSaving.value = false

  if (saveError) {
    error.value = saveError.message
    return
  }

  if (data) {
    lastSaved.value = 'just now'
    
    // Redirect to edit page for this post
    if (!silent) {
      navigateTo(`/publications/${publicationId}/posts/${data.id}/edit`)
    }
  }
}

const handlePublish = async () => {
  if (!form.title.trim() || !form.content.trim() || !form.slug.trim()) {
    error.value = 'Title, content, and slug are required'
    return
  }

  isPublishing.value = true
  error.value = ''

  const { data, error: publishError } = await createPost(publicationId, {
    title: form.title.trim(),
    slug: form.slug.trim(),
    subtitle: form.subtitle.trim() || undefined,
    content: form.content,
    excerpt: form.excerpt.trim() || undefined,
    visibility: form.visibility,
    status: 'published',
    published_at: new Date().toISOString(),
    send_email: form.sendEmail,
  })

  isPublishing.value = false

  if (publishError) {
    error.value = publishError.message
    showPublishModal.value = false
    return
  }

  if (data) {
    // Redirect to published post
    navigateTo(`/${publication.value.slug}/${data.slug}`)
  }
}
</script>

<style scoped>
.editor-page {
  min-height: 100vh;
  background: var(--color-bg-primary);
}

.editor-container {
  max-width: 800px;
  margin: 0 auto;
  padding: var(--space-4);
}

.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-4) 0;
  margin-bottom: var(--space-6);
  border-bottom: 1px solid var(--color-border);
}

.back-link {
  color: var(--color-text-secondary);
  text-decoration: none;
  font-size: var(--font-size-sm);
}

.back-link:hover {
  color: var(--color-brand-primary);
}

.header-actions {
  display: flex;
  align-items: center;
  gap: var(--space-3);
}

.save-indicator {
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
}

.editor-form {
  margin-bottom: var(--space-12);
}

.title-input,
.subtitle-input {
  width: 100%;
  border: none;
  outline: none;
  padding: var(--space-4) 0;
  font-family: var(--font-sans);
  background: transparent;
}

.title-input {
  font-size: var(--font-size-4xl);
  font-weight: var(--font-weight-bold);
  line-height: var(--line-height-tight);
}

.title-input::placeholder {
  color: var(--color-text-tertiary);
}

.subtitle-input {
  font-size: var(--font-size-xl);
  color: var(--color-text-secondary);
  margin-bottom: var(--space-6);
}

.subtitle-input::placeholder {
  color: var(--color-text-tertiary);
}

.content-editor {
  width: 100%;
  min-height: 500px;
  border: none;
  outline: none;
  padding: var(--space-4) 0;
  font-family: var(--font-serif);
  font-size: var(--font-size-lg);
  line-height: var(--line-height-relaxed);
  resize: vertical;
  background: transparent;
}

.content-editor::placeholder {
  color: var(--color-text-tertiary);
}

.editor-hint {
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
  margin-top: var(--space-2);
}

.settings-section {
  margin-top: var(--space-8);
  padding: var(--space-6);
  background: var(--color-bg-secondary);
  border-radius: var(--radius-lg);
}

.settings-toggle {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  cursor: pointer;
  user-select: none;
  list-style: none;
}

.settings-toggle::-webkit-details-marker {
  display: none;
}

.settings-content {
  margin-top: var(--space-6);
  padding-top: var(--space-6);
  border-top: 1px solid var(--color-border-light);
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
}

.checkbox {
  width: 18px;
  height: 18px;
  cursor: pointer;
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
  margin-bottom: var(--space-6);
}

.publish-preview {
  padding: var(--space-6);
  background: var(--color-bg-secondary);
  border-radius: var(--radius-md);
  margin-bottom: var(--space-6);
}

.publish-preview h3 {
  font-size: var(--font-size-xl);
  margin-bottom: var(--space-2);
}

.publish-preview .subtitle {
  color: var(--color-text-secondary);
  margin-bottom: var(--space-4);
}

.publish-preview .meta {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
}

.modal-actions {
  display: flex;
  gap: var(--space-3);
}

@media (max-width: 768px) {
  .editor-container {
    padding: var(--space-2);
  }

  .title-input {
    font-size: var(--font-size-3xl);
  }

  .subtitle-input {
    font-size: var(--font-size-lg);
  }

  .header-actions {
    flex-wrap: wrap;
  }

  .modal-actions {
    flex-direction: column-reverse;
  }
}
</style>
