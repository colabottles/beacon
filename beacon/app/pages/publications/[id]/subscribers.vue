<template>
  <div class="subscribers-page">
    <div class="container container-wide py-12">
      <div class="page-header">
        <div>
          <NuxtLink to="/dashboard" class="back-link">
            ← Back to Dashboard
          </NuxtLink>
          <h1 v-if="publication">{{ publication.title }}</h1>
          <p class="page-subtitle">
            Manage your subscribers
          </p>
        </div>
      </div>

      <div v-if="loading" class="loading-state">
        <span class="spinner"></span>
        <p>Loading subscribers...</p>
      </div>

      <div v-else-if="error" class="alert alert-error">
        {{ error }}
      </div>

      <div v-else class="subscribers-content">
        <!-- Stats -->
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-value">{{ totalSubscribers }}</div>
            <div class="stat-label">Total Subscribers</div>
          </div>
          <div class="stat-card">
            <div class="stat-value">{{ freeSubscribers }}</div>
            <div class="stat-label">Free Subscribers</div>
          </div>
          <div class="stat-card">
            <div class="stat-value">{{ paidSubscribers }}</div>
            <div class="stat-label">Paid Subscribers</div>
          </div>
          <div class="stat-card">
            <div class="stat-value">{{ growthRate }}</div>
            <div class="stat-label">30-Day Growth</div>
          </div>
        </div>

        <!-- Subscribers Table -->
        <div class="subscribers-section">
          <div class="section-header">
            <h2>Subscribers</h2>
            <div class="actions">
              <button @click="exportSubscribers" class="btn btn-secondary btn-sm">
                Export CSV
              </button>
            </div>
          </div>

          <div v-if="subscribers.length === 0" class="empty-state">
            <h3>No subscribers yet</h3>
            <p>Share your publication to start building your audience</p>
          </div>

          <div v-else class="table-container">
            <table class="subscribers-table">
              <thead>
                <tr>
                  <th>Email</th>
                  <th>Status</th>
                  <th>Type</th>
                  <th>Subscribed</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="subscriber in subscribers" :key="subscriber.id">
                  <td class="email-cell">{{ subscriber.email }}</td>
                  <td>
                    <span class="badge" :class="`badge-${subscriber.status}`">
                      {{ subscriber.status }}
                    </span>
                  </td>
                  <td>
                    <span class="badge badge-type">
                      {{ subscriber.tier_id ? 'Paid' : 'Free' }}
                    </span>
                  </td>
                  <td class="date-cell">
                    {{ formatDate(subscriber.created_at) }}
                  </td>
                </tr>
              </tbody>
            </table>
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

const route = useRoute()
const publicationId = route.params.id as string

const { getPublication } = usePublications()
const { getPublicationSubscriptions } = useSubscriptions()

const publication = ref(null)
const subscribers = ref([])
const loading = ref(true)
const error = ref('')

const totalSubscribers = computed(() => {
  return subscribers.value.filter((s: any) => s.status === 'active').length
})

const freeSubscribers = computed(() => {
  return subscribers.value.filter((s: any) => s.status === 'active' && !s.tier_id).length
})

const paidSubscribers = computed(() => {
  return subscribers.value.filter((s: any) => s.status === 'active' && s.tier_id).length
})

const growthRate = computed(() => {
  // Calculate 30-day growth
  const thirtyDaysAgo = new Date()
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)
  
  const newSubscribers = subscribers.value.filter((s: any) => {
    return new Date(s.created_at) > thirtyDaysAgo && s.status === 'active'
  }).length

  return `+${newSubscribers}`
})

onMounted(async () => {
  // Load publication
  const { data: pubData, error: pubError } = await getPublication(publicationId)
  
  if (pubError || !pubData) {
    error.value = 'Publication not found'
    loading.value = false
    return
  }

  publication.value = pubData

  // Load subscribers
  const { data: subsData, error: subsError } = await getPublicationSubscriptions(publicationId)
  
  if (subsError) {
    error.value = 'Failed to load subscribers'
    console.error(subsError)
  } else {
    subscribers.value = subsData || []
  }

  loading.value = false
})

useHead(() => ({
  title: publication.value ? `${publication.value.title} Subscribers - Beacon` : 'Subscribers - Beacon'
}))

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const exportSubscribers = () => {
  // Create CSV
  const csv = [
    ['Email', 'Status', 'Type', 'Subscribed'],
    ...subscribers.value.map((s: any) => [
      s.email,
      s.status,
      s.tier_id ? 'Paid' : 'Free',
      formatDate(s.created_at)
    ])
  ].map(row => row.join(',')).join('\n')

  // Download
  const blob = new Blob([csv], { type: 'text/csv' })
  const url = window.URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `subscribers-${publication.value.slug}-${new Date().toISOString().split('T')[0]}.csv`
  a.click()
  window.URL.revokeObjectURL(url)
}
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: var(--space-8);
}

.back-link {
  display: inline-block;
  color: var(--color-brand-primary);
  text-decoration: none;
  margin-bottom: var(--space-3);
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

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: var(--space-6);
  margin-bottom: var(--space-12);
}

.stat-card {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  text-align: center;
}

.stat-value {
  font-size: var(--font-size-4xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-brand-primary);
  margin-bottom: var(--space-2);
}

.stat-label {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  font-weight: var(--font-weight-medium);
}

.subscribers-section {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-6);
  padding-bottom: var(--space-4);
  border-bottom: 1px solid var(--color-border);
}

.section-header h2 {
  font-size: var(--font-size-2xl);
}

.empty-state {
  text-align: center;
  padding: var(--space-16);
}

.empty-state h3 {
  font-size: var(--font-size-xl);
  margin-bottom: var(--space-3);
}

.empty-state p {
  color: var(--color-text-secondary);
}

.table-container {
  overflow-x: auto;
}

.subscribers-table {
  width: 100%;
  border-collapse: collapse;
}

.subscribers-table th {
  text-align: left;
  padding: var(--space-3) var(--space-4);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-secondary);
  border-bottom: 1px solid var(--color-border);
}

.subscribers-table td {
  padding: var(--space-4);
  border-bottom: 1px solid var(--color-border-light);
}

.subscribers-table tr:last-child td {
  border-bottom: none;
}

.email-cell {
  font-family: var(--font-mono);
  font-size: var(--font-size-sm);
}

.date-cell {
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
}

.badge-active {
  background-color: var(--color-success-bg);
  color: var(--color-success);
}

.badge-canceled {
  background-color: var(--color-bg-tertiary);
  color: var(--color-text-secondary);
}

.badge-type {
  background-color: var(--color-info-bg);
  color: var(--color-info);
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .table-container {
    overflow-x: scroll;
  }
}
</style>
