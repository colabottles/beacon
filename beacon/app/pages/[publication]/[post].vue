<template>
  <div class="post-page">
    <div v-if="loading" class="loading-state">
      <div class="container container-content py-16">
        <span class="spinner"></span>
        <p>Loading post...</p>
      </div>
    </div>

    <div v-else-if="error" class="error-state">
      <div class="container container-content py-16">
        <h1>Post Not Found</h1>
        <p>{{ error }}</p>
        <NuxtLink :to="`/${publicationSlug}`" class="btn btn-primary">
          Back to Publication
        </NuxtLink>
      </div>
    </div>

    <article v-else-if="post && publication" class="post-article">
      <!-- Post Header -->
      <header class="post-header">
        <div class="container container-prose">
          <NuxtLink :to="`/${publication.slug}`" class="publication-link">
            {{ publication.title }}
          </NuxtLink>
          
          <h1 class="post-title">{{ post.title }}</h1>
          
          <p v-if="post.subtitle" class="post-subtitle">
            {{ post.subtitle }}
          </p>

          <div class="post-meta">
            <time :datetime="post.published_at" class="post-date">
              {{ formatDate(post.published_at) }}
            </time>
            <span v-if="post.view_count" class="post-views">
              {{ post.view_count }} {{ post.view_count === 1 ? 'view' : 'views' }}
            </span>
          </div>
        </div>
      </header>

      <!-- Cover Image -->
      <div v-if="post.cover_image_url" class="post-cover">
        <div class="container container-prose">
          <img :src="post.cover_image_url" :alt="post.title" />
        </div>
      </div>

      <!-- Post Content -->
      <div class="post-content">
        <div class="container container-prose">
          <div class="prose" v-html="renderedContent"></div>
        </div>
      </div>

      <!-- Post Footer -->
      <footer class="post-footer">
        <div class="container container-prose">
          <div class="subscribe-cta">
            <h3>Enjoying this post?</h3>
            <p>Subscribe to {{ publication.title }} to get new posts in your inbox</p>
            <button
              v-if="!isSubscribed"
              @click="showSubscribeModal = true"
              class="btn btn-primary"
            >
              Subscribe
            </button>
            <div v-else class="subscribed-badge">
              ✓ Subscribed
            </div>
          </div>

          <div class="post-actions">
            <NuxtLink :to="`/${publication.slug}`" class="btn btn-secondary">
              ← More from {{ publication.title }}
            </NuxtLink>
          </div>
        </div>
      </footer>
    </article>

    <!-- Subscribe Modal -->
    <div v-if="showSubscribeModal" class="modal-overlay" @click.self="showSubscribeModal = false">
      <div class="modal" role="dialog" aria-labelledby="subscribe-modal-title" aria-modal="true">
        <button @click="showSubscribeModal = false" class="modal-close" aria-label="Close">
          ×
        </button>
        <h2 id="subscribe-modal-title">Subscribe to {{ publication?.title }}</h2>
        <p class="modal-description">
          Get new posts delivered to your inbox
        </p>
        <form @submit.prevent="handleSubscribe" class="subscribe-form">
          <div class="form-group">
            <label for="email" class="label label-required">Email</label>
            <input
              id="email"
              v-model="subscribeEmail"
              type="email"
              class="input"
              :class="{ 'input-error': subscribeError }"
              placeholder="you@example.com"
              required
            >
            <span v-if="subscribeError" class="form-error" role="alert">
              {{ subscribeError }}
            </span>
          </div>
          <button
            type="submit"
            class="btn btn-primary"
            style="width: 100%;"
            :disabled="isSubscribing"
          >
            <span v-if="isSubscribing" class="spinner" aria-hidden="true"></span>
            {{ isSubscribing ? 'Subscribing...' : 'Subscribe' }}
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

const route = useRoute()
const publicationSlug = route.params.publication as string
const postSlug = route.params.post as string

const { getPublicationBySlug } = usePublications()
const { getPostBySlug } = usePosts()
const { createSubscription, checkSubscription } = useSubscriptions()

const publication = ref(null)
const post = ref(null)
const loading = ref(true)
const error = ref('')
const isSubscribed = ref(false)
const showSubscribeModal = ref(false)
const subscribeEmail = ref('')
const subscribeError = ref('')
const isSubscribing = ref(false)

// Simple Markdown-like rendering (for MVP)
// TODO: Replace with proper Markdown library (marked.js or similar)
const renderedContent = computed(() => {
  if (!post.value) return ''
  
  let html = post.value.content
  
  // Convert Markdown to HTML (basic implementation)
  // Headings
  html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>')
  html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>')
  html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>')
  
  // Bold
  html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
  
  // Italic
  html = html.replace(/\*(.*?)\*/g, '<em>$1</em>')
  
  // Links
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
  
  // Line breaks
  html = html.replace(/\n\n/g, '</p><p>')
  html = `<p>${html}</p>`
  
  return html
})

onMounted(async () => {
  // Load publication
  const { data: pubData, error: pubError } = await getPublicationBySlug(publicationSlug)
  
  if (pubError || !pubData) {
    error.value = 'Publication not found'
    loading.value = false
    return
  }

  publication.value = pubData

  // Load post
  const { data: postData, error: postError } = await getPostBySlug(pubData.id, postSlug)
  
  if (postError || !postData) {
    error.value = 'This post does not exist'
    loading.value = false
    return
  }

  // Check if post is accessible
  if (postData.status !== 'published') {
    error.value = 'This post is not published'
    loading.value = false
    return
  }

  // TODO: Check if user has access based on visibility
  // For now, show all posts

  post.value = postData
  loading.value = false

  // TODO: Track view count
})

useHead(() => ({
  title: post.value 
    ? `${post.value.title} - ${publication.value?.title} - Beacon` 
    : 'Post - Beacon',
  meta: post.value ? [
    {
      name: 'description',
      content: post.value.excerpt || post.value.subtitle || post.value.title
    },
    // Open Graph
    {
      property: 'og:title',
      content: post.value.title
    },
    {
      property: 'og:description',
      content: post.value.excerpt || post.value.subtitle || ''
    },
    {
      property: 'og:type',
      content: 'article'
    },
    {
      property: 'og:image',
      content: post.value.cover_image_url || ''
    },
    // Twitter Card
    {
      name: 'twitter:card',
      content: 'summary_large_image'
    },
    {
      name: 'twitter:title',
      content: post.value.title
    },
    {
      name: 'twitter:description',
      content: post.value.excerpt || post.value.subtitle || ''
    },
    {
      name: 'twitter:image',
      content: post.value.cover_image_url || ''
    }
  ] : []
}))

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const handleSubscribe = async () => {
  subscribeError.value = ''

  if (!subscribeEmail.value) {
    subscribeError.value = 'Email is required'
    return
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(subscribeEmail.value)) {
    subscribeError.value = 'Please enter a valid email address'
    return
  }

  isSubscribing.value = true

  // Check if already subscribed
  const { isSubscribed: alreadySubscribed } = await checkSubscription(
    publication.value.id,
    subscribeEmail.value
  )

  if (alreadySubscribed) {
    subscribeError.value = 'This email is already subscribed'
    isSubscribing.value = false
    return
  }

  // Create subscription
  const { data, error: subError } = await createSubscription(
    publication.value.id,
    subscribeEmail.value
  )

  isSubscribing.value = false

  if (subError) {
    if (subError.message.includes('duplicate key')) {
      subscribeError.value = 'This email is already subscribed'
    } else {
      subscribeError.value = 'Failed to subscribe. Please try again.'
    }
    return
  }

  if (data) {
    isSubscribed.value = true
    showSubscribeModal.value = false
    subscribeEmail.value = ''

    alert('Thanks for subscribing! You\'ll receive new posts in your inbox.')
  }
}
</script>

<style scoped>
.loading-state,
.error-state {
  min-height: 60vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
}

.loading-state p {
  margin-top: var(--space-4);
  color: var(--color-text-secondary);
}

.error-state h1 {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-4);
}

.error-state p {
  color: var(--color-text-secondary);
  margin-bottom: var(--space-6);
}

/* Post Header */
.post-header {
  padding: var(--space-12) 0 var(--space-8);
  border-bottom: 1px solid var(--color-border-light);
}

.publication-link {
  display: inline-block;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-semibold);
  color: var(--color-brand-primary);
  text-decoration: none;
  margin-bottom: var(--space-6);
  transition: opacity var(--transition-fast);
}

.publication-link:hover {
  opacity: 0.8;
}

.post-title {
  font-size: var(--font-size-5xl);
  line-height: var(--line-height-tight);
  margin-bottom: var(--space-4);
}

.post-subtitle {
  font-size: var(--font-size-2xl);
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
  margin-bottom: var(--space-6);
}

.post-meta {
  display: flex;
  gap: var(--space-4);
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
}

/* Cover Image */
.post-cover {
  padding: var(--space-8) 0;
}

.post-cover img {
  width: 100%;
  border-radius: var(--radius-xl);
}

/* Post Content */
.post-content {
  padding: var(--space-8) 0 var(--space-16);
}

/* Already have .prose styles from typography.css */

/* Post Footer */
.post-footer {
  border-top: 1px solid var(--color-border);
  padding: var(--space-12) 0;
  background: var(--color-bg-secondary);
}

.subscribe-cta {
  text-align: center;
  padding: var(--space-8);
  background: var(--color-bg-primary);
  border-radius: var(--radius-xl);
  margin-bottom: var(--space-8);
}

.subscribe-cta h3 {
  font-size: var(--font-size-2xl);
  margin-bottom: var(--space-3);
}

.subscribe-cta p {
  color: var(--color-text-secondary);
  margin-bottom: var(--space-6);
}

.subscribed-badge {
  display: inline-block;
  padding: var(--space-3) var(--space-6);
  background-color: var(--color-success-bg);
  color: var(--color-success);
  border-radius: var(--radius-full);
  font-weight: var(--font-weight-semibold);
}

.post-actions {
  text-align: center;
}

/* Subscribe Modal */
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
  width: 100%;
  margin: var(--space-4);
  position: relative;
  z-index: var(--z-modal);
}

.modal-close {
  position: absolute;
  top: var(--space-4);
  right: var(--space-4);
  width: 32px;
  height: 32px;
  border-radius: var(--radius-full);
  background: var(--color-bg-secondary);
  border: none;
  font-size: var(--font-size-2xl);
  line-height: 1;
  cursor: pointer;
  transition: background-color var(--transition-fast);
}

.modal-close:hover {
  background: var(--color-bg-tertiary);
}

.modal h2 {
  font-size: var(--font-size-2xl);
  margin-bottom: var(--space-3);
}

.modal-description {
  color: var(--color-text-secondary);
  margin-bottom: var(--space-6);
}

@media (max-width: 768px) {
  .post-title {
    font-size: var(--font-size-3xl);
  }

  .post-subtitle {
    font-size: var(--font-size-xl);
  }
}
</style>
