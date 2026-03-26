<template>
  <div class="homepage">
    <section class="hero" aria-labelledby="hero-heading">
      <div class="container container-content">
        <h1 id="hero-heading" class="hero-title">
          Your voice. Your audience. Your terms.
        </h1>
        <p class="hero-subtitle">
          Beacon is a publishing platform for independent writers and journalists who believe in truth, dignity, and the open web.
        </p>
        <div class="hero-cta">
          <NuxtLink to="/write" class="btn btn-primary btn-lg">
            Start Writing
          </NuxtLink>
          <NuxtLink to="/explore" class="btn btn-secondary btn-lg">
            Explore Publications
          </NuxtLink>
        </div>
      </div>
    </section>

    <section class="features" aria-labelledby="features-heading">
      <div class="container container-wide">
        <h2 id="features-heading" class="section-title">Why Beacon?</h2>
        
        <div class="features-grid">
          <article class="feature-card">
            <div class="feature-icon" aria-hidden="true">✍️</div>
            <h3 class="feature-title">Own Your Content</h3>
            <p class="feature-description">
              Your writing, your subscribers, your revenue. Export everything, anytime. No lock-in.
            </p>
          </article>

          <article class="feature-card">
            <div class="feature-icon" aria-hidden="true">💰</div>
            <h3 class="feature-title">Better Economics</h3>
            <p class="feature-description">
              Keep 95% of your subscription revenue (vs Substack's 90%). Direct Stripe connection means you control your payments. Save $5,000/year on every $100k earned.
            </p>
          </article>

          <article class="feature-card">
            <div class="feature-icon" aria-hidden="true">🚫</div>
            <h3 class="feature-title">Clear Values</h3>
            <p class="feature-description">
              Zero tolerance for hate speech, nazism, racism, or harassment. Transparent moderation with appeals.
            </p>
          </article>

          <article class="feature-card">
            <div class="feature-icon" aria-hidden="true">🌐</div>
            <h3 class="feature-title">Open Web</h3>
            <p class="feature-description">
              Full RSS feeds, semantic HTML, and potential ActivityPub integration. Built for the open web.
            </p>
          </article>

          <article class="feature-card">
            <div class="feature-icon" aria-hidden="true">♿</div>
            <h3 class="feature-title">Accessible</h3>
            <p class="feature-description">
              WCAG 2.2 Level AA compliant. Reach more readers with keyboard navigation and screen reader support.
            </p>
          </article>

          <article class="feature-card">
            <div class="feature-icon" aria-hidden="true">📧</div>
            <h3 class="feature-title">Email Newsletters</h3>
            <p class="feature-description">
              Built-in email delivery for free and paid subscribers. Own your subscriber relationships.
            </p>
          </article>
        </div>
      </div>
    </section>

    <section class="comparison" aria-labelledby="comparison-heading">
      <div class="container container-content">
        <h2 id="comparison-heading" class="section-title">Better Than The Alternatives</h2>
        
        <div class="comparison-table">
          <div class="comparison-row comparison-header">
            <div class="comparison-cell"></div>
            <div class="comparison-cell">Beacon</div>
            <div class="comparison-cell">Others</div>
          </div>
          
          <div class="comparison-row">
            <div class="comparison-cell">Revenue Split</div>
            <div class="comparison-cell highlight">95/5 (save $5k per $100k)</div>
            <div class="comparison-cell">90/10</div>
          </div>
          
          <div class="comparison-row">
            <div class="comparison-cell">Data Export</div>
            <div class="comparison-cell highlight">Full export anytime</div>
            <div class="comparison-cell">Limited</div>
          </div>
          
          <div class="comparison-row">
            <div class="comparison-cell">Content Policy</div>
            <div class="comparison-cell highlight">No hate speech</div>
            <div class="comparison-cell">Platforms nazis</div>
          </div>
          
          <div class="comparison-row">
            <div class="comparison-cell">Accessibility</div>
            <div class="comparison-cell highlight">WCAG 2.2 AA</div>
            <div class="comparison-cell">Basic</div>
          </div>
          
          <div class="comparison-row">
            <div class="comparison-cell">RSS Feeds</div>
            <div class="comparison-cell highlight">Full-text</div>
            <div class="comparison-cell">Limited/Paywalled</div>
          </div>
        </div>
      </div>
    </section>

    <section class="cta-section" aria-labelledby="cta-heading">
      <div class="container container-content">
        <h2 id="cta-heading" class="cta-title">Ready to share your voice?</h2>
        <p class="cta-subtitle">
          Join writers who believe in building a better web.
        </p>
        <NuxtLink to="/write" class="btn btn-primary btn-lg">
          Start Writing for Free
        </NuxtLink>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
useHead({
  title: 'Beacon - Independent Publishing Platform',
  meta: [
    {
      name: 'description',
      content: 'A publishing platform for independent writers and journalists who believe in truth, dignity, and the open web. No hate speech. Fair economics. Full ownership.'
    }
  ]
})
</script>

<style scoped>
/* Hero section */
.hero {
  background: linear-gradient(135deg, var(--color-bg-primary) 0%, var(--color-bg-secondary) 100%);
  padding: var(--space-24) 0 var(--space-20);
  text-align: center;
}

.hero-title {
  font-size: var(--font-size-5xl);
  margin-bottom: var(--space-6);
  line-height: var(--line-height-tight);
}

.hero-subtitle {
  font-size: var(--font-size-xl);
  color: var(--color-text-secondary);
  max-width: 600px;
  margin: 0 auto var(--space-8);
  line-height: var(--line-height-relaxed);
}

.hero-cta {
  display: flex;
  gap: var(--space-4);
  justify-content: center;
  flex-wrap: wrap;
}

/* Features section */
.features {
  padding: var(--space-20) 0;
}

.section-title {
  text-align: center;
  font-size: var(--font-size-4xl);
  margin-bottom: var(--space-12);
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: var(--space-8);
}

.feature-card {
  text-align: center;
  padding: var(--space-8);
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: var(--space-4);
}

.feature-title {
  font-size: var(--font-size-xl);
  margin-bottom: var(--space-3);
}

.feature-description {
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
}

/* Comparison section */
.comparison {
  padding: var(--space-20) 0;
  background-color: var(--color-bg-secondary);
}

.comparison-table {
  margin-top: var(--space-8);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
  background-color: var(--color-bg-primary);
}

.comparison-row {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  border-bottom: 1px solid var(--color-border);
}

.comparison-row:last-child {
  border-bottom: none;
}

.comparison-header {
  background-color: var(--color-bg-secondary);
  font-weight: var(--font-weight-semibold);
}

.comparison-cell {
  padding: var(--space-4) var(--space-6);
  text-align: center;
}

.comparison-cell:first-child {
  text-align: left;
  font-weight: var(--font-weight-medium);
}

.comparison-cell.highlight {
  color: var(--color-brand-primary);
  font-weight: var(--font-weight-semibold);
}

/* CTA section */
.cta-section {
  padding: var(--space-20) 0;
  text-align: center;
}

.cta-title {
  font-size: var(--font-size-4xl);
  margin-bottom: var(--space-4);
}

.cta-subtitle {
  font-size: var(--font-size-xl);
  color: var(--color-text-secondary);
  margin-bottom: var(--space-8);
}

/* Responsive */
@media (max-width: 768px) {
  .hero {
    padding: var(--space-16) 0 var(--space-12);
  }
  
  .hero-title {
    font-size: var(--font-size-3xl);
  }
  
  .hero-subtitle {
    font-size: var(--font-size-lg);
  }
  
  .section-title {
    font-size: var(--font-size-3xl);
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
  
  .comparison-row {
    grid-template-columns: 1fr;
  }
  
  .comparison-cell {
    text-align: left;
    border-bottom: 1px solid var(--color-border-light);
  }
  
  .comparison-cell:last-child {
    border-bottom: none;
  }
  
  .comparison-header .comparison-cell:not(:first-child) {
    display: none;
  }
  
  .comparison-cell:not(:first-child)::before {
    content: attr(data-label);
    font-weight: var(--font-weight-semibold);
    margin-right: var(--space-2);
  }
}
</style>
