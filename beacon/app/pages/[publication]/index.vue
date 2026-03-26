<template>
  <div class="publication-page">
    <div v-if="loading" class="loading-state">
      <div class="container container-content py-16">
        <span class="spinner"></span>
        <p>Loading publication...</p>
      </div>
    </div>

    <div v-else-if="error" class="error-state">
      <div class="container container-content py-16">
        <h1>Publication Not Found</h1>
        <p>{{ error }}</p>
        <NuxtLink to="/" class="btn btn-primary">
          Return to Homepage
        </NuxtLink>
      </div>
    </div>

    <div v-else-if="publication" class="publication-content">
      <!-- Publication Header -->
      <header class="publication-header">
        <div class="container container-content">
          <div class="header-content">
            <h1 class="publication-title">{{ publication.title }}</h1>
            <p v-if="publication.description" class="publication-description">
              {{ publication.description }}
            </p>
            <div class="publication-meta">
              <span>{{ subscriberCount }} subscribers</span>
              <span>{{ publishedPosts.length }} posts</span>
            </div>
            <div class="subscribe-section">
              <button
                v-if="!isSubscribed"
                @click="showSubscribeModal = true"
                class="btn btn-primary btn-lg"
              >
                Subscribe
              </button>
              <div v-else class="subscribed-badge">
                ✓ Subscribed
              </div>
            </div>
          </div>
        </div>
      </header>

      <!-- Posts List -->
      <main class="posts-section">
        <div class="container container-content">
          <div v-if="publishedPosts.length === 0" class="empty-state">
            <h2>No posts yet</h2>
            <p>This publication hasn't published any posts yet. Subscribe to be notified when they do!</p>
          </div>

          <div v-else class="posts-list">
            <article
              v-for="post in publishedPosts"
              :key="post.id"
              class="post-card"
            >
              <NuxtLink :to="`/${publication.slug}/${post.slug}`" class="post-link">
                <div v-if="post.cover_image_url" class="post-cover">
                  <img :src="post.cover_image_url" :alt="post.title" />
                </div>
                <div class="post-content">
                  <h2 class="post-title">{{ post.title }}</h2>
                  <p v-if="post.subtitle" class="post-subtitle">
                    {{ post.subtitle }}
                  </p>
                  <p v-else-if="post.excerpt" class="post-excerpt">
                    {{ post.excerpt }}
                  </p>
                  <div class="post-meta">
                    <time :datetime="post.published_at">
                      {{ formatDate(post.published_at) }}
                    </time>
                    <span v-if="post.visibility !== 'free'" class="badge badge-paid">
                      {{ post.visibility === 'paid' ? 'Paid subscribers only' : 'Subscribers only' }}
                    </span>
                  </div>
                </div>
              </NuxtLink>
            </article>
          </div>
        </div>
      </main>
    </div>

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
              aria-describedby="subscribe-error"
              :aria-invalid="!!subscribeError"
            >
            <span v-if="subscribeError" id="subscribe-error" class="form-error" role="alert">
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

const { getPublicationBySlug } = usePublications()
const { getPublicationPosts } = usePosts()
const { createSubscription, getSubscriberCount, checkSubscription } = useSubscriptions()

const publication = ref(null)
const allPosts = ref([])
const loading = ref(true)
const error = ref('')
const subscriberCount = ref(0)
const isSubscribed = ref(false)
const showSubscribeModal = ref(false)
const subscribeEmail = ref('')
const subscribeError = ref('')
const isSubscribing = ref(false)

const publishedPosts = computed(() => {
  return allPosts.value.filter((post: any) => post.status === 'published')
})

onMounted(async () => {
  // Load publication
  const { data: pubData, error: pubError } = await getPublicationBySlug(publicationSlug)
  
  if (pubError || !pubData) {
    error.value = 'This publication does not exist'
    loading.value = false
    return
  }

  publication.value = pubData

  // Load published posts
  const { data: postsData, error: postsError } = await getPublicationPosts(pubData.id, 'published')
  
  if (postsError) {
    console.error('Failed to load posts:', postsError)
  } else {
    allPosts.value = postsData || []
  }

  // Get subscriber count
  const { count } = await getSubscriberCount(pubData.id)
  subscriberCount.value = count

  loading.value = false
})

useHead(() => ({
  title: publication.value 
    ? `${publication.value.title} - Beacon` 
    : 'Publication - Beacon',
  meta: publication.value ? [
    {
      name: 'description',
      content: publication.value.description || `Read ${publication.value.title} on Beacon`
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
    subscriberCount.value += 1

    // TODO: Send confirmation email
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

/* Publication Header */
.publication-header {
  background: linear-gradient(135deg, var(--color-bg-primary) 0%, var(--color-bg-secondary) 100%);
  padding: var(--space-16) 0 var(--space-12);
  border-bottom: 1px solid var(--color-border);
}

.header-content {
  text-align: center;
  max-width: 700px;
  margin: 0 auto;
}

.publication-title {
  font-size: var(--font-size-5xl);
  margin-bottom: var(--space-4);
  line-height: var(--line-height-tight);
}

.publication-description {
  font-size: var(--font-size-xl);
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
  margin-bottom: var(--space-6);
}

.publication-meta {
  display: flex;
  gap: var(--space-6);
  justify-content: center;
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
  margin-bottom: var(--space-8);
}

.subscribe-section {
  display: flex;
  justify-content: center;
}

.subscribed-badge {
  padding: var(--space-3) var(--space-6);
  background-color: var(--color-success-bg);
  color: var(--color-success);
  border-radius: var(--radius-full);
  font-weight: var(--font-weight-semibold);
}

/* Posts Section */
.posts-section {
  padding: var(--space-12) 0;
}

.empty-state {
  text-align: center;
  padding: var(--space-16);
  background: var(--color-bg-secondary);
  border-radius: var(--radius-xl);
}

.empty-state h2 {
  font-size: var(--font-size-2xl);
  margin-bottom: var(--space-3);
}

.empty-state p {
  color: var(--color-text-secondary);
}

.posts-list {
  display: grid;
  gap: var(--space-8);
}

.post-card {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  overflow: hidden;
  transition: transform var(--transition-base), box-shadow var(--transition-base);
}

.post-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.post-link {
  text-decoration: none;
  color: inherit;
  display: block;
}

.post-cover {
  width: 100%;
  height: 300px;
  overflow: hidden;
  background: var(--color-bg-secondary);
}

.post-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.post-content {
  padding: var(--space-8);
}

.post-title {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-3);
  line-height: var(--line-height-tight);
}

.post-subtitle {
  font-size: var(--font-size-xl);
  color: var(--color-text-secondary);
  margin-bottom: var(--space-4);
  line-height: var(--line-height-relaxed);
}

.post-excerpt {
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
  margin-bottom: var(--space-4);
}

.post-meta {
  display: flex;
  align-items: center;
  gap: var(--space-4);
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
}

.badge-paid {
  background-color: var(--color-warning-bg);
  color: var(--color-warning);
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

.subscribe-form {
  /* Form styles inherited from global */
}

@media (max-width: 768px) {
  .publication-header {
    padding: var(--space-12) 0 var(--space-8);
  }

  .publication-title {
    font-size: var(--font-size-3xl);
  }

  .publication-description {
    font-size: var(--font-size-lg);
  }

  .post-cover {
    height: 200px;
  }

  .post-title {
    font-size: var(--font-size-2xl);
  }
}
</style>
