<template>
  <div class="posts-page">
    <div class="container container-wide py-12">
      <div class="page-header">
        <div>
          <NuxtLink to="/dashboard" class="back-link">
            ← Back to Dashboard
          </NuxtLink>
          <h1 v-if="publication">{{ publication.title }}</h1>
          <p class="page-subtitle">
            Manage your posts
          </p>
        </div>
        <NuxtLink :to="`/publications/${publicationId}/posts/new`" class="btn btn-primary">
          New Post
        </NuxtLink>
      </div>

      <div v-if="loading" class="loading-state">
        <span class="spinner"></span>
        <p>Loading posts...</p>
      </div>

      <div v-else-if="error" class="alert alert-error">
        {{ error }}
      </div>

      <div v-else class="posts-content">
        <!-- Tabs -->
        <div class="tabs" role="tablist">
          <button
            class="tab"
            :class="{ active: activeTab === 'all' }"
            @click="activeTab = 'all'"
            role="tab"
            :aria-selected="activeTab === 'all'"
          >
            All Posts ({{ allPosts.length }})
          </button>
          <button
            class="tab"
            :class="{ active: activeTab === 'published' }"
            @click="activeTab = 'published'"
            role="tab"
            :aria-selected="activeTab === 'published'"
          >
            Published ({{ publishedPosts.length }})
          </button>
          <button
            class="tab"
            :class="{ active: activeTab === 'drafts' }"
            @click="activeTab = 'drafts'"
            role="tab"
            :aria-selected="activeTab === 'drafts'"
          >
            Drafts ({{ draftPosts.length }})
          </button>
        </div>

        <!-- Posts list -->
        <div v-if="filteredPosts.length === 0" class="empty-state">
          <div class="empty-icon" aria-hidden="true">📝</div>
          <h2>No {{ activeTab }} posts yet</h2>
          <p>
            {{ activeTab === 'all' ? 'Write your first post to get started' : `No ${activeTab} posts` }}
          </p>
          <NuxtLink
            v-if="activeTab === 'all'"
            :to="`/publications/${publicationId}/posts/new`"
            class="btn btn-primary"
          >
            Write Your First Post
          </NuxtLink>
        </div>

        <div v-else class="posts-list">
          <article
            v-for="post in filteredPosts"
            :key="post.id"
            class="post-card"
          >
            <div class="post-content">
              <div class="post-header">
                <h3 class="post-title">
                  <NuxtLink :to="`/${publication?.slug}/${post.slug}`" target="_blank">
                    {{ post.title }}
                  </NuxtLink>
                </h3>
                <div class="post-badges">
                  <span class="badge" :class="`badge-${post.status}`">
                    {{ post.status }}
                  </span>
                  <span v-if="post.visibility !== 'free'" class="badge badge-visibility">
                    {{ post.visibility }}
                  </span>
                </div>
              </div>
              
              <p v-if="post.subtitle" class="post-subtitle">
                {{ post.subtitle }}
              </p>
              
              <p v-else-if="post.excerpt" class="post-excerpt">
                {{ post.excerpt }}
              </p>

              <div class="post-meta">
                <span v-if="post.published_at" class="meta-item">
                  Published {{ formatDate(post.published_at) }}
                </span>
                <span v-else class="meta-item">
                  Created {{ formatDate(post.created_at) }}
                </span>
                <span class="meta-item">
                  {{ post.view_count || 0 }} views
                </span>
              </div>
            </div>

            <div class="post-actions">
              <NuxtLink
                :to="`/publications/${publicationId}/posts/${post.id}/edit`"
                class="btn btn-secondary btn-sm"
              >
                Edit
              </NuxtLink>
              <NuxtLink
                v-if="post.status === 'published'"
                :to="`/${publication?.slug}/${post.slug}`"
                class="btn btn-ghost btn-sm"
                target="_blank"
              >
                View
              </NuxtLink>
            </div>
          </article>
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
const { getPublicationPosts } = usePosts()

const publication = ref(null)
const allPosts = ref([])
const loading = ref(true)
const error = ref('')
const activeTab = ref<'all' | 'published' | 'drafts'>('all')

const publishedPosts = computed(() => {
  return allPosts.value.filter((post: any) => post.status === 'published')
})

const draftPosts = computed(() => {
  return allPosts.value.filter((post: any) => post.status === 'draft')
})

const filteredPosts = computed(() => {
  if (activeTab.value === 'published') return publishedPosts.value
  if (activeTab.value === 'drafts') return draftPosts.value
  return allPosts.value
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

  // Load posts
  const { data: postsData, error: postsError } = await getPublicationPosts(publicationId)
  
  if (postsError) {
    error.value = 'Failed to load posts'
    console.error(postsError)
  } else {
    allPosts.value = postsData || []
  }

  loading.value = false
})

useHead(() => ({
  title: publication.value ? `${publication.value.title} Posts - Beacon` : 'Posts - Beacon'
}))

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

.tabs {
  display: flex;
  gap: var(--space-4);
  border-bottom: 1px solid var(--color-border);
  margin-bottom: var(--space-8);
}

.tab {
  padding: var(--space-3) var(--space-4);
  background: none;
  border: none;
  border-bottom: 2px solid transparent;
  color: var(--color-text-secondary);
  font-weight: var(--font-weight-medium);
  cursor: pointer;
  transition: color var(--transition-fast);
}

.tab:hover {
  color: var(--color-text-primary);
}

.tab.active {
  color: var(--color-brand-primary);
  border-bottom-color: var(--color-brand-primary);
}

.empty-state {
  text-align: center;
  padding: var(--space-16) var(--space-8);
  background: var(--color-bg-secondary);
  border-radius: var(--radius-xl);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: var(--space-6);
}

.empty-state h2 {
  font-size: var(--font-size-2xl);
  margin-bottom: var(--space-3);
}

.empty-state p {
  color: var(--color-text-secondary);
  margin-bottom: var(--space-6);
}

.posts-list {
  display: grid;
  gap: var(--space-4);
}

.post-card {
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

.post-card:hover {
  box-shadow: var(--shadow-md);
}

.post-content {
  flex: 1;
  min-width: 0;
}

.post-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: var(--space-3);
  margin-bottom: var(--space-2);
}

.post-title {
  font-size: var(--font-size-xl);
  margin: 0;
  flex: 1;
}

.post-title a {
  color: var(--color-text-primary);
  text-decoration: none;
}

.post-title a:hover {
  color: var(--color-brand-primary);
}

.post-badges {
  display: flex;
  gap: var(--space-2);
  flex-shrink: 0;
}

.badge-draft {
  background-color: var(--color-bg-tertiary);
  color: var(--color-text-secondary);
}

.badge-published {
  background-color: var(--color-success-bg);
  color: var(--color-success);
}

.badge-scheduled {
  background-color: var(--color-info-bg);
  color: var(--color-info);
}

.badge-visibility {
  background-color: var(--color-warning-bg);
  color: var(--color-warning);
}

.post-subtitle {
  color: var(--color-text-secondary);
  margin-bottom: var(--space-3);
  font-size: var(--font-size-base);
}

.post-excerpt {
  color: var(--color-text-secondary);
  margin-bottom: var(--space-3);
  font-size: var(--font-size-sm);
  line-height: var(--line-height-relaxed);
}

.post-meta {
  display: flex;
  gap: var(--space-4);
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
}

.post-actions {
  display: flex;
  gap: var(--space-2);
  flex-shrink: 0;
}

@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    gap: var(--space-4);
  }

  .post-card {
    flex-direction: column;
  }

  .post-actions {
    width: 100%;
  }

  .tabs {
    overflow-x: auto;
  }
}
</style>
