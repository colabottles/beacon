<template>
  <div class="pricing-page">
    <section class="hero py-16">
      <div class="container container-content">
        <h1 class="hero-title">Simple, Fair Pricing</h1>
        <p class="hero-subtitle">
          Keep more of what you earn. No surprises. No hidden fees.
        </p>
      </div>
    </section>

    <section class="pricing-comparison py-12">
      <div class="container container-content">
        <div class="pricing-card">
          <div class="pricing-header">
            <h2>For Writers</h2>
            <div class="price">
              <span class="price-number">5%</span>
              <span class="price-label">platform fee</span>
            </div>
          </div>
          
          <div class="pricing-features">
            <ul role="list">
              <li>✅ Keep 95% of subscription revenue</li>
              <li>✅ Unlimited posts and subscribers</li>
              <li>✅ Email newsletters included</li>
              <li>✅ Custom domains supported</li>
              <li>✅ Full analytics dashboard</li>
              <li>✅ Comments and community features</li>
              <li>✅ Export data anytime</li>
              <li>✅ Direct Stripe Connect</li>
              <li>✅ No setup fees</li>
              <li>✅ No monthly minimums</li>
            </ul>
          </div>
          
          <div class="pricing-cta">
            <NuxtLink to="/write" class="btn btn-primary btn-lg">
              Start Writing Free
            </NuxtLink>
            <p class="pricing-note">
              Free until you enable paid subscriptions
            </p>
          </div>
        </div>
      </div>
    </section>

    <section class="savings-calculator py-16">
      <div class="container container-content">
        <h2 class="section-title">See How Much You Save</h2>
        <p class="section-subtitle">
          Compare what you'd keep on Beacon vs Substack
        </p>
        
        <div class="calculator-wrapper">
          <div class="calculator-input">
            <label for="revenue" class="label">
              Your Annual Subscription Revenue
            </label>
            <div class="input-group">
              <span class="input-prefix">$</span>
              <input
                id="revenue"
                v-model.number="annualRevenue"
                type="number"
                min="0"
                step="1000"
                class="input"
                placeholder="50000"
              >
            </div>
          </div>
          
          <div class="calculator-results">
            <div class="result-card">
              <div class="result-platform">Beacon (5% fee)</div>
              <div class="result-amount highlight">{{ formatCurrency(beaconTakeHome) }}</div>
              <div class="result-label">You keep</div>
            </div>
            
            <div class="result-card">
              <div class="result-platform">Substack (10% fee)</div>
              <div class="result-amount">{{ formatCurrency(substackTakeHome) }}</div>
              <div class="result-label">You keep</div>
            </div>
            
            <div class="result-card savings">
              <div class="result-platform">Your Savings</div>
              <div class="result-amount savings-amount">{{ formatCurrency(savings) }}</div>
              <div class="result-label">Extra income with Beacon</div>
            </div>
          </div>
        </div>
        
        <div class="calculator-examples">
          <p class="text-secondary">Common examples:</p>
          <div class="example-buttons">
            <button @click="setRevenue(12000)" class="btn btn-ghost btn-sm">
              $12k/year
            </button>
            <button @click="setRevenue(50000)" class="btn btn-ghost btn-sm">
              $50k/year
            </button>
            <button @click="setRevenue(100000)" class="btn btn-ghost btn-sm">
              $100k/year
            </button>
            <button @click="setRevenue(250000)" class="btn btn-ghost btn-sm">
              $250k/year
            </button>
          </div>
        </div>
      </div>
    </section>

    <section class="payment-details py-16">
      <div class="container container-content">
        <h2 class="section-title">How Payments Work</h2>
        
        <div class="details-grid">
          <div class="detail-card">
            <h3>Stripe Connect</h3>
            <p>
              You connect your own Stripe account directly. You control your money, 
              not us. Payments go straight to you.
            </p>
          </div>
          
          <div class="detail-card">
            <h3>Payment Processing</h3>
            <p>
              Stripe charges ~2.9% + $0.30 per transaction (standard rates). 
              This goes to Stripe, not Beacon.
            </p>
          </div>
          
          <div class="detail-card">
            <h3>Weekly Payouts</h3>
            <p>
              Money arrives in your bank account weekly via Stripe. 
              No waiting months for your earnings.
            </p>
          </div>
          
          <div class="detail-card">
            <h3>Full Transparency</h3>
            <p>
              See every transaction, every subscriber, every dollar. 
              Your analytics, your data, your business.
            </p>
          </div>
        </div>
      </div>
    </section>

    <section class="faq-section py-16">
      <div class="container container-content">
        <h2 class="section-title">Frequently Asked Questions</h2>
        
        <div class="faq-list">
          <details class="faq-item">
            <summary class="faq-question">
              Is there a monthly fee?
            </summary>
            <div class="faq-answer">
              No. Beacon is completely free until you enable paid subscriptions. 
              Then we only take 5% of what you earn. No setup fees, no monthly minimums.
            </div>
          </details>
          
          <details class="faq-item">
            <summary class="faq-question">
              How does the 5% fee work?
            </summary>
            <div class="faq-answer">
              When a subscriber pays you $10/month, Stripe takes their ~3% processing fee, 
              then Beacon takes 5% of the remaining amount. You get the rest (about $9.20). 
              Simple and transparent.
            </div>
          </details>
          
          <details class="faq-item">
            <summary class="faq-question">
              Can I export my subscribers?
            </summary>
            <div class="faq-answer">
              Yes! Export your full subscriber list (with emails) anytime. 
              You own your audience, not us. Leave whenever you want with all your data.
            </div>
          </details>
          
          <details class="faq-item">
            <summary class="faq-question">
              What if I'm currently on Substack?
            </summary>
            <div class="faq-answer">
              We'll build an import tool to help you migrate. Bring your subscribers, 
              bring your content, and start saving 5% on every subscription.
            </div>
          </details>
          
          <details class="faq-item">
            <summary class="faq-question">
              Do you offer custom domains?
            </summary>
            <div class="faq-answer">
              Yes. Connect your custom domain at no additional cost 
              (vs Substack's $50 fee). Your brand, your domain.
            </div>
          </details>
          
          <details class="faq-item">
            <summary class="faq-question">
              Why is Beacon cheaper than Substack?
            </summary>
            <div class="faq-answer">
              We believe writers should keep more of what they earn. Our 5% covers 
              infrastructure, moderation, and support. We don't need 10% to run a 
              great platform - and we can prove it.
            </div>
          </details>
        </div>
      </div>
    </section>

    <section class="cta-section py-16">
      <div class="container container-content">
        <h2 class="cta-title">Start keeping 95% of your revenue</h2>
        <p class="cta-subtitle">
          Join writers who value both ethics and economics.
        </p>
        <NuxtLink to="/write" class="btn btn-primary btn-lg">
          Create Your Publication
        </NuxtLink>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

useHead({
  title: 'Pricing - Keep 95% of Your Revenue | Beacon',
  meta: [
    {
      name: 'description',
      content: 'Beacon charges only 5% vs Substack\'s 10%. Save $5,000/year on every $100k earned. No setup fees, no monthly minimums. Start free.'
    }
  ]
})

const annualRevenue = ref(50000)

const beaconTakeHome = computed(() => {
  // 5% platform fee
  return annualRevenue.value * 0.95
})

const substackTakeHome = computed(() => {
  // 10% platform fee
  return annualRevenue.value * 0.90
})

const savings = computed(() => {
  return beaconTakeHome.value - substackTakeHome.value
})

const formatCurrency = (amount: number) => {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount)
}

const setRevenue = (amount: number) => {
  annualRevenue.value = amount
}
</script>

<style scoped>
.hero {
  text-align: center;
  background: linear-gradient(135deg, var(--color-bg-primary) 0%, var(--color-bg-secondary) 100%);
}

.hero-title {
  font-size: var(--font-size-4xl);
  margin-bottom: var(--space-4);
}

.hero-subtitle {
  font-size: var(--font-size-xl);
  color: var(--color-text-secondary);
}

/* Pricing card */
.pricing-card {
  background: var(--color-bg-primary);
  border: 2px solid var(--color-brand-primary);
  border-radius: var(--radius-xl);
  padding: var(--space-8);
  max-width: 500px;
  margin: 0 auto;
}

.pricing-header {
  text-align: center;
  padding-bottom: var(--space-6);
  border-bottom: 1px solid var(--color-border);
  margin-bottom: var(--space-6);
}

.pricing-header h2 {
  font-size: var(--font-size-2xl);
  margin-bottom: var(--space-4);
}

.price {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-2);
}

.price-number {
  font-size: var(--font-size-5xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-brand-primary);
}

.price-label {
  font-size: var(--font-size-lg);
  color: var(--color-text-secondary);
}

.pricing-features ul {
  list-style: none;
  padding: 0;
}

.pricing-features li {
  padding: var(--space-3) 0;
  border-bottom: 1px solid var(--color-border-light);
}

.pricing-features li:last-child {
  border-bottom: none;
}

.pricing-cta {
  margin-top: var(--space-8);
  text-align: center;
}

.pricing-note {
  margin-top: var(--space-3);
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
}

/* Calculator */
.savings-calculator {
  background-color: var(--color-bg-secondary);
}

.section-title {
  text-align: center;
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-4);
}

.section-subtitle {
  text-align: center;
  font-size: var(--font-size-lg);
  color: var(--color-text-secondary);
  margin-bottom: var(--space-12);
}

.calculator-wrapper {
  background: var(--color-bg-primary);
  border-radius: var(--radius-lg);
  padding: var(--space-8);
  margin-bottom: var(--space-8);
}

.calculator-input {
  margin-bottom: var(--space-8);
}

.input-group {
  position: relative;
  display: flex;
  align-items: center;
}

.input-prefix {
  position: absolute;
  left: var(--space-4);
  font-size: var(--font-size-lg);
  color: var(--color-text-secondary);
  pointer-events: none;
}

.input-group .input {
  padding-left: var(--space-8);
  font-size: var(--font-size-lg);
}

.calculator-results {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: var(--space-6);
}

.result-card {
  text-align: center;
  padding: var(--space-6);
  background: var(--color-bg-secondary);
  border-radius: var(--radius-md);
}

.result-card.savings {
  background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
}

.result-platform {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-secondary);
  margin-bottom: var(--space-2);
}

.result-amount {
  font-size: var(--font-size-3xl);
  font-weight: var(--font-weight-bold);
  margin-bottom: var(--space-2);
}

.result-amount.highlight {
  color: var(--color-brand-primary);
}

.result-amount.savings-amount {
  color: var(--color-success);
}

.result-label {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
}

.calculator-examples {
  text-align: center;
}

.calculator-examples p {
  margin-bottom: var(--space-4);
}

.example-buttons {
  display: flex;
  gap: var(--space-3);
  justify-content: center;
  flex-wrap: wrap;
}

/* Payment details */
.details-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: var(--space-8);
  margin-top: var(--space-8);
}

.detail-card {
  text-align: center;
}

.detail-card h3 {
  font-size: var(--font-size-xl);
  margin-bottom: var(--space-4);
}

.detail-card p {
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
}

/* FAQ */
.faq-section {
  background-color: var(--color-bg-secondary);
}

.faq-list {
  margin-top: var(--space-8);
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
}

.faq-item {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  margin-bottom: var(--space-4);
  overflow: hidden;
}

.faq-question {
  padding: var(--space-4) var(--space-6);
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  cursor: pointer;
  list-style: none;
  user-select: none;
}

.faq-question::-webkit-details-marker {
  display: none;
}

.faq-question::after {
  content: '+';
  float: right;
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-normal);
  transition: transform var(--transition-base);
}

details[open] .faq-question::after {
  transform: rotate(45deg);
}

.faq-answer {
  padding: 0 var(--space-6) var(--space-4);
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
}

/* CTA section */
.cta-section {
  text-align: center;
}

.cta-title {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-4);
}

.cta-subtitle {
  font-size: var(--font-size-lg);
  color: var(--color-text-secondary);
  margin-bottom: var(--space-8);
}

/* Responsive */
@media (max-width: 768px) {
  .calculator-results {
    grid-template-columns: 1fr;
  }
  
  .details-grid {
    grid-template-columns: 1fr;
  }
}
</style>
