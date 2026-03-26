<template>
  <div class="auth-page">
    <div class="container container-content py-16">
      <div class="auth-card">
        <div class="auth-header">
          <div class="success-icon" aria-hidden="true">📧</div>
          <h1>Check Your Email</h1>
          <p class="auth-subtitle">
            We've sent you a confirmation email. Click the link in the email to continue.
          </p>
        </div>

        <div class="info-box">
          <h2>What's next?</h2>
          <ol class="steps-list">
            <li>Check your inbox (and spam folder)</li>
            <li>Click the confirmation link in the email</li>
            <li>You'll be redirected back to Beacon</li>
            <li>Start publishing your first post!</li>
          </ol>
        </div>

        <div class="help-section">
          <p class="text-secondary">
            Didn't receive the email?
          </p>
          <ul class="help-list" role="list">
            <li>Check your spam or junk folder</li>
            <li>Make sure you entered the correct email</li>
            <li>Wait a few minutes - emails can be delayed</li>
          </ul>
        </div>

        <div class="auth-footer">
          <NuxtLink to="/" class="btn btn-secondary">
            Return to Homepage
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
useHead({
  title: 'Check Your Email - Beacon',
  meta: [
    {
      name: 'description',
      content: 'Please check your email to confirm your Beacon account.'
    }
  ]
})
</script>

<style scoped>
.auth-page {
  min-height: calc(100vh - 200px);
  display: flex;
  align-items: center;
}

.auth-card {
  max-width: 560px;
  margin: 0 auto;
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-8);
}

.auth-header {
  text-align: center;
  margin-bottom: var(--space-8);
}

.success-icon {
  font-size: 4rem;
  margin-bottom: var(--space-4);
}

.auth-header h1 {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-3);
}

.auth-subtitle {
  color: var(--color-text-secondary);
  font-size: var(--font-size-lg);
  line-height: var(--line-height-relaxed);
}

.info-box {
  background-color: var(--color-bg-secondary);
  border-radius: var(--radius-md);
  padding: var(--space-6);
  margin-bottom: var(--space-6);
}

.info-box h2 {
  font-size: var(--font-size-lg);
  margin-bottom: var(--space-4);
}

.steps-list {
  padding-left: var(--space-6);
  margin: 0;
}

.steps-list li {
  margin-bottom: var(--space-2);
  color: var(--color-text-secondary);
}

.help-section {
  text-align: center;
  padding: var(--space-6) 0;
  margin-bottom: var(--space-6);
}

.help-section p {
  margin-bottom: var(--space-4);
  font-weight: var(--font-weight-medium);
}

.help-list {
  list-style: none;
  padding: 0;
  text-align: left;
  max-width: 400px;
  margin: 0 auto;
}

.help-list li {
  padding: var(--space-2) 0;
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
}

.help-list li::before {
  content: '• ';
  color: var(--color-brand-primary);
  font-weight: bold;
  margin-right: var(--space-2);
}

.auth-footer {
  text-align: center;
  padding-top: var(--space-6);
  border-top: 1px solid var(--color-border);
}
</style>
