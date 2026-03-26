<template>
  <div class="dashboard-page">
    <div class="container container-wide py-12">
      <div class="dashboard-header">
        <div>
          <h1>Welcome to Your Dashboard</h1>
          <p class="dashboard-subtitle">
            {{ greeting }}
          </p>
        </div>
        <button @click="handleSignOut" class="btn btn-secondary">
          Sign Out
        </button>
      </div>

      <div class="dashboard-content">
        <div v-if="loading" class="loading-state">
          <span class="spinner"></span>
          <p>Loading your publications...</p>
        </div>

        <div v-else-if="error" class="alert alert-error">
          {{ error }}
        </div>

        <div v-else-if="!hasPublications" class="empty-state">
          <div class="empty-icon" aria-hidden="true">✍️</div>
          <h2>Ready to Start Publishing?</h2>
          <p>
            Create your first publication to start sharing your writing with the world.
          </p>
          <NuxtLink to="/publications/new" class="btn btn-primary btn-lg">
            Create Publication
          </NuxtLink>
        </div>

        <div v-else class="publications-list">
          <div class="publications-header">
            <h2>Your Publications</h2>
            <NuxtLink to="/publications/new" class="btn btn-primary">
              New Publication
            </NuxtLink>
          </div>

          <div class="publications-grid">
            <article
              v-for="publication in publications"
              :key="publication.id"
              class="publication-card"
            >
              <div class="publication-content">
                <h3 class="publication-title">
                  <NuxtLink :to="`/${publication.slug}`">
                    {{ publication.title }}
                  </NuxtLink>
                </h3>
                <p v-if="publication.description" class="publication-description">
                  {{ publication.description }}
                </p>
                <div class="publication-meta">
                  <span class="publication-url">beacon.pub/{{ publication.slug }}</span>
                  <span class="publication-date">
                    Created {{ formatDate(publication.created_at) }}
                  </span>
                </div>
              </div>
              <div class="publication-actions">
                <NuxtLink
                  :to="`/publications/${publication.id}/posts`"
                  class="btn btn-primary btn-sm"
                >
                  Posts
                </NuxtLink>
                <NuxtLink
                  :to="`/publications/${publication.id}/subscribers`"
                  class="btn btn-secondary btn-sm"
                >
                  Subscribers
                </NuxtLink>
                <NuxtLink
                  :to="`/publications/${publication.id}/settings`"
                  class="btn btn-ghost btn-sm"
                >
                  Settings
                </NuxtLink>
              </div>
            </article>
          </div>
        </div>

        <div v-if="!hasPublications" class="info-cards">
          <div class="info-card">
            <h3>🚀 Getting Started</h3>
            <ul role="list">
              <li>Create your first publication</li>
              <li>Customize your publication settings</li>
              <li>Write and publish your first post</li>
              <li>Share your publication URL</li>
            </ul>
          </div>

          <div class="info-card">
            <h3>💰 Monetization</h3>
            <ul role="list">
              <li>Set up subscription tiers</li>
              <li>Connect your Stripe account</li>
              <li>Keep 95% of revenue</li>
              <li>Start earning from your writing</li>
            </ul>
          </div>

          <div class="info-card">
            <h3>📊 Analytics</h3>
            <ul role="list">
              <li>Track your subscriber growth</li>
              <li>Monitor post performance</li>
              <li>See email open rates</li>
              <li>Understand your audience</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

definePageMeta({
  middleware: 'auth',
})

useHead({
  title: 'Dashboard - Beacon',
})

const { user, signOut } = useAuth()
const { getUserPublications } = usePublications()

const publications = ref([])
const loading = ref(true)
const error = ref('')

const greeting = computed(() => {
  if (user.value?.user_metadata?.display_name) {
    return `Welcome back, ${user.value.user_metadata.display_name}!`
  }
  return 'Welcome back!'
})

const hasPublications = computed(() => {
  return publications.value && publications.value.length > 0
})

onMounted(async () => {
  const { data, error: fetchError } = await getUserPublications()
  
  if (fetchError) {
    error.value = 'Failed to load publications'
    console.error(fetchError)
  } else {
    publications.value = data || []
  }
  
  loading.value = false
})

const handleSignOut = async () => {
  await signOut()
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}
</script>

<style scoped>
.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: var(--space-12);
  padding-bottom: var(--space-6);
  border-bottom: 1px solid var(--color-border);
}

.dashboard-header h1 {
  font-size: var(--font-size-4xl);
  margin-bottom: var(--space-2);
}

.dashboard-subtitle {
  color: var(--color-text-secondary);
  font-size: var(--font-size-lg);
}

.dashboard-content {
  max-width: 1200px;
  margin: 0 auto;
}

.loading-state {
  text-align: center;
  padding: var(--space-16);
}

.loading-state p {
  margin-top: var(--space-4);
  color: var(--color-text-secondary);
}

.empty-state {
  text-align: center;
  padding: var(--space-16) var(--space-8);
  background: var(--color-bg-secondary);
  border-radius: var(--radius-xl);
  margin-bottom: var(--space-12);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: var(--space-6);
}

.empty-state h2 {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-4);
}

.empty-state p {
  color: var(--color-text-secondary);
  font-size: var(--font-size-lg);
  margin-bottom: var(--space-8);
  max-width: 500px;
  margin-left: auto;
  margin-right: auto;
}

.publications-list {
  margin-bottom: var(--space-12);
}

.publications-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-6);
}

.publications-header h2 {
  font-size: var(--font-size-2xl);
}

.publications-grid {
  display: grid;
  gap: var(--space-6);
}

.publication-card {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: var(--space-6);
  transition: box-shadow var(--transition-base);
}

.publication-card:hover {
  box-shadow: var(--shadow-md);
}

.publication-content {
  flex: 1;
  min-width: 0;
}

.publication-title {
  font-size: var(--font-size-xl);
  margin-bottom: var(--space-2);
}

.publication-title a {
  color: var(--color-text-primary);
  text-decoration: none;
}

.publication-title a:hover {
  color: var(--color-brand-primary);
}

.publication-description {
  color: var(--color-text-secondary);
  margin-bottom: var(--space-3);
  line-height: var(--line-height-relaxed);
}

.publication-meta {
  display: flex;
  gap: var(--space-4);
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
}

.publication-url {
  font-family: var(--font-mono);
}

.publication-actions {
  display: flex;
  gap: var(--space-2);
  flex-shrink: 0;
}

.info-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--space-6);
}

.info-card {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
}

.info-card h3 {
  font-size: var(--font-size-xl);
  margin-bottom: var(--space-4);
}

.info-card ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.info-card li {
  padding: var(--space-2) 0;
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
}

.info-card li::before {
  content: '✓ ';
  color: var(--color-brand-primary);
  font-weight: bold;
  margin-right: var(--space-2);
}

@media (max-width: 768px) {
  .dashboard-header {
    flex-direction: column;
    gap: var(--space-4);
  }

  .publication-card {
    flex-direction: column;
  }

  .publication-actions {
    width: 100%;
    flex-wrap: wrap;
  }

  .publications-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-4);
  }

  .info-cards {
    grid-template-columns: 1fr;
  }
}
</style>
