<template>
  <div class="site-wrapper">
    <a href="#main-content" class="skip-link">Skip to main content</a>
    
    <header class="site-header" role="banner">
      <div class="container container-wide">
        <nav class="header-nav" role="navigation" aria-label="Main navigation">
          <div class="nav-brand">
            <NuxtLink to="/" class="logo-link">
              <span class="logo-text">Beacon</span>
            </NuxtLink>
          </div>
          
          <div class="nav-links">
            <NuxtLink to="/explore" class="nav-link">Explore</NuxtLink>
            <NuxtLink to="/pricing" class="nav-link">Pricing</NuxtLink>
            <NuxtLink to="/about" class="nav-link">About</NuxtLink>
            
            <template v-if="user">
              <NuxtLink to="/dashboard" class="nav-link">Dashboard</NuxtLink>
              <NuxtLink to="/write" class="btn btn-primary btn-sm">Write</NuxtLink>
            </template>
            <template v-else>
              <NuxtLink to="/write" class="nav-link">Start Writing</NuxtLink>
              <NuxtLink to="/login" class="btn btn-secondary btn-sm">Sign In</NuxtLink>
            </template>
          </div>
        </nav>
      </div>
    </header>

    <main id="main-content" role="main">
      <slot />
    </main>

    <footer class="site-footer" role="contentinfo">
      <div class="container container-wide">
        <div class="footer-content">
          <div class="footer-section">
            <h3 class="footer-heading">Beacon</h3>
            <p class="footer-description">
              A publishing platform for independent writers and journalists who believe in truth, dignity, and the open web.
            </p>
          </div>
          
          <div class="footer-section">
            <h4 class="footer-heading">Platform</h4>
            <ul class="footer-links" role="list">
              <li><NuxtLink to="/explore">Explore</NuxtLink></li>
              <li><NuxtLink to="/write">Start Writing</NuxtLink></li>
              <li><NuxtLink to="/pricing">Pricing</NuxtLink></li>
            </ul>
          </div>
          
          <div class="footer-section">
            <h4 class="footer-heading">Company</h4>
            <ul class="footer-links" role="list">
              <li><NuxtLink to="/about">About</NuxtLink></li>
              <li><NuxtLink to="/content-policy">Content Policy</NuxtLink></li>
              <li><NuxtLink to="/privacy">Privacy</NuxtLink></li>
              <li><NuxtLink to="/terms">Terms</NuxtLink></li>
            </ul>
          </div>
          
          <div class="footer-section">
            <h4 class="footer-heading">Support</h4>
            <ul class="footer-links" role="list">
              <li><NuxtLink to="/help">Help Center</NuxtLink></li>
              <li><NuxtLink to="/contact">Contact</NuxtLink></li>
              <li><a href="mailto:support@beacon.pub">support@beacon.pub</a></li>
            </ul>
          </div>
        </div>
        
        <div class="footer-bottom">
          <p class="footer-copyright">
            &copy; {{ currentYear }} Beacon. All rights reserved.
          </p>
          <p class="footer-tagline text-secondary">
            Building a better web, one story at a time.
          </p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
const currentYear = new Date().getFullYear()
const { user } = useAuth()
</script>

<style scoped>
.site-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* Header */
.site-header {
  border-bottom: 1px solid var(--color-border);
  background-color: var(--color-bg-primary);
  position: sticky;
  top: 0;
  z-index: var(--z-sticky);
}

.header-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--space-4) 0;
}

.nav-brand {
  display: flex;
  align-items: center;
}

.logo-link {
  display: flex;
  align-items: center;
  text-decoration: none;
}

.logo-text {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-text-primary);
}

.nav-links {
  display: flex;
  align-items: center;
  gap: var(--space-6);
}

.nav-link {
  color: var(--color-text-secondary);
  text-decoration: none;
  font-weight: var(--font-weight-medium);
  transition: color var(--transition-fast);
}

.nav-link:hover {
  color: var(--color-text-primary);
}

/* Main content */
main {
  flex: 1;
}

/* Footer */
.site-footer {
  margin-top: auto;
  border-top: 1px solid var(--color-border);
  background-color: var(--color-bg-secondary);
  padding: var(--space-16) 0 var(--space-8);
}

.footer-content {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr;
  gap: var(--space-12);
  margin-bottom: var(--space-12);
}

.footer-section h3,
.footer-section h4 {
  font-size: var(--font-size-base);
  font-weight: var(--font-weight-semibold);
  margin-bottom: var(--space-4);
  color: var(--color-text-primary);
}

.footer-description {
  color: var(--color-text-secondary);
  max-width: 320px;
  line-height: var(--line-height-relaxed);
}

.footer-links {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-links li {
  margin-bottom: var(--space-2);
}

.footer-links a {
  color: var(--color-text-secondary);
  text-decoration: none;
  transition: color var(--transition-fast);
}

.footer-links a:hover {
  color: var(--color-text-primary);
}

.footer-bottom {
  padding-top: var(--space-8);
  border-top: 1px solid var(--color-border-light);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-copyright,
.footer-tagline {
  font-size: var(--font-size-sm);
  margin: 0;
}

/* Responsive */
@media (max-width: 1024px) {
  .footer-content {
    grid-template-columns: 1fr 1fr;
    gap: var(--space-8);
  }
}

@media (max-width: 768px) {
  .nav-links {
    gap: var(--space-4);
  }
  
  .nav-link {
    font-size: var(--font-size-sm);
  }
  
  .footer-content {
    grid-template-columns: 1fr;
    gap: var(--space-8);
  }
  
  .footer-bottom {
    flex-direction: column;
    gap: var(--space-2);
    text-align: center;
  }
}
</style>
