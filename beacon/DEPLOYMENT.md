# Beacon Deployment Guide

## Overview

This guide walks you through deploying Beacon to production. We'll use:
- **Supabase** - Database and authentication
- **Netlify** - Hosting and deployment
- **Custom Domain** - beacon.pub (or your domain)

Estimated time: 30-45 minutes

---

## Prerequisites

### Required Accounts
- [ ] GitHub account (free)
- [ ] Supabase account (free tier)
- [ ] Netlify account (free tier)
- [ ] Domain registrar (optional, for custom domain)

### Required Tools
```bash
# Node.js 18+ and pnpm
node --version  # Should be 18.x or higher
pnpm --version  # Should be 8.x or higher

# Git
git --version
```

---

## Step 1: Supabase Setup (Database)

### 1.1 Create Supabase Project

1. Go to https://supabase.com
2. Click "Start your project"
3. Sign in with GitHub
4. Click "New Project"
5. Fill in:
   - **Name**: beacon-production
   - **Database Password**: Generate strong password (save this!)
   - **Region**: Choose closest to your users
   - **Pricing Plan**: Free (or Pro if you prefer)
6. Click "Create new project"
7. Wait 2-3 minutes for provisioning

### 1.2 Get Your Credentials

Once project is ready:

1. Go to **Settings** → **API**
2. Copy these values (you'll need them later):
   ```
   Project URL: https://xxxxx.supabase.co
   anon/public key: eyJhbGc...
   service_role key: eyJhbGc... (keep secret!)
   ```

### 1.3 Run Database Migrations

1. Go to **SQL Editor** in Supabase dashboard
2. Click "New query"
3. Copy contents of `beacon/supabase/migrations/001_initial_schema.sql`
4. Paste and click "Run"
5. Repeat for `002_rls_policies.sql`

**Verify:**
- Go to **Table Editor**
- Should see: profiles, publications, posts, tiers, subscriptions, etc.

### 1.4 Configure Authentication

1. Go to **Authentication** → **Providers**
2. **Email** provider (should be enabled by default)
3. **Email Templates**:
   - Customize confirmation email (optional)
   - Customize magic link email (optional)
4. **URL Configuration**:
   - Site URL: `https://your-domain.com` (update after deployment)
   - Redirect URLs: Add `https://your-domain.com/**`

---

## Step 2: Prepare Repository

### 2.1 Create Git Repository

```bash
cd beacon
git init
git add .
git commit -m "Initial commit - Beacon platform"
```

### 2.2 Create GitHub Repository

1. Go to https://github.com/new
2. Name: `beacon`
3. Description: "Ethical Substack alternative"
4. **Private** or Public (your choice)
5. Click "Create repository"

### 2.3 Push to GitHub

```bash
# Replace with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/beacon.git
git branch -M main
git push -u origin main
```

---

## Step 3: Netlify Deployment

### 3.1 Connect Repository

1. Go to https://netlify.com
2. Sign in with GitHub
3. Click "Add new site" → "Import an existing project"
4. Click "GitHub" → Authorize Netlify
5. Select your `beacon` repository

### 3.2 Configure Build Settings

**Build settings:**
```
Base directory: (leave empty)
Build command: pnpm build
Publish directory: .output/public
```

**Advanced: Node version**
- Add environment variable: `NODE_VERSION = 18`

### 3.3 Add Environment Variables

Click "Add environment variables":

```bash
# Supabase (from Step 1.2)
NUXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NUXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...

# Optional: For future Stripe integration
STRIPE_SECRET_KEY=(leave empty for now)
STRIPE_PUBLISHABLE_KEY=(leave empty for now)

# Optional: For future email integration
RESEND_API_KEY=(leave empty for now)
```

**Important:** Never use `service_role` key in frontend environment variables!

### 3.4 Deploy

1. Click "Deploy site"
2. Wait 2-3 minutes for build
3. Site will be live at: `https://random-name-123.netlify.app`

---

## Step 4: Custom Domain (Optional)

### 4.1 Purchase Domain

Recommended registrars:
- Namecheap (cheapest)
- Google Domains
- Cloudflare Registrar

Example: `beacon.pub` or `yourname.com`

### 4.2 Configure Netlify

1. In Netlify, go to **Domain settings**
2. Click "Add custom domain"
3. Enter your domain: `beacon.pub`
4. Click "Verify"

### 4.3 Update DNS Records

In your domain registrar's DNS settings:

**Option A: Netlify DNS (Recommended)**
1. Netlify will show nameservers
2. Copy nameservers (e.g., dns1.p03.nsone.net)
3. Update your domain's nameservers
4. Wait 24-48 hours for propagation

**Option B: External DNS**
Add these records:
```
Type: A
Name: @
Value: 75.2.60.5 (Netlify's load balancer)

Type: CNAME
Name: www
Value: your-site.netlify.app
```

### 4.4 Enable HTTPS

1. In Netlify, go to **Domain settings**
2. Under HTTPS, click "Verify DNS configuration"
3. Once verified, click "Provision certificate"
4. Wait 1-2 minutes
5. Enable "Force HTTPS"

---

## Step 5: Update Supabase URLs

Now that you have your domain:

1. Go to Supabase dashboard
2. **Authentication** → **URL Configuration**
3. Update:
   - Site URL: `https://beacon.pub` (your domain)
   - Redirect URLs: `https://beacon.pub/**`

---

## Step 6: Test Deployment

### 6.1 Basic Functionality

Visit your site: `https://beacon.pub`

Test these flows:

**Authentication:**
- [ ] Sign up with email/password
- [ ] Receive verification email
- [ ] Verify email (click link)
- [ ] Sign in
- [ ] Sign out
- [ ] Password reset
- [ ] Magic link sign in

**Publications:**
- [ ] Create publication
- [ ] Edit publication settings
- [ ] Delete publication

**Posts:**
- [ ] Create draft post
- [ ] Save draft
- [ ] Publish post
- [ ] View published post on public page
- [ ] Edit post

**Subscriptions:**
- [ ] Subscribe from publication page
- [ ] Subscribe from post page
- [ ] View subscribers dashboard
- [ ] Export subscribers CSV

### 6.2 Performance Check

Use these tools:
- **Lighthouse**: https://pagespeed.web.dev/
  - Target: Score > 90
- **GTmetrix**: https://gtmetrix.com/
- **WebPageTest**: https://webpagetest.org/

### 6.3 Accessibility Check

- **WAVE**: https://wave.webaim.org/
- **axe DevTools**: Browser extension
- Screen reader test (VoiceOver on Mac, NVDA on Windows)

---

## Step 7: Monitoring & Analytics

### 7.1 Netlify Analytics (Optional - $9/month)

1. Netlify Dashboard → **Analytics**
2. Enable Netlify Analytics
3. View:
   - Page views
   - Unique visitors
   - Top pages
   - Bandwidth

### 7.2 Supabase Logs

1. Supabase Dashboard → **Logs**
2. Monitor:
   - API requests
   - Auth events
   - Errors

### 7.3 Error Tracking (Recommended)

**Sentry** (free tier):
```bash
pnpm add @sentry/nuxt
```

`nuxt.config.ts`:
```typescript
export default defineNuxtConfig({
  modules: ['@sentry/nuxt/module'],
  sentry: {
    dsn: 'https://xxxxx@sentry.io/xxxxx'
  }
})
```

---

## Step 8: Post-Deployment Checklist

### Required
- [ ] All tests passing (from Step 6.1)
- [ ] HTTPS enabled and working
- [ ] Email verification working
- [ ] Database migrations applied
- [ ] Environment variables set correctly
- [ ] Custom domain configured (if applicable)

### Recommended
- [ ] Set up monitoring/alerts
- [ ] Create backup strategy
- [ ] Document any custom configurations
- [ ] Set up staging environment
- [ ] Create runbook for common issues

### Optional
- [ ] Add favicon
- [ ] Add social media images (OG images)
- [ ] Set up CDN for assets
- [ ] Configure caching headers

---

## Troubleshooting

### Build Fails

**Error: "Module not found"**
```bash
# Locally, clear cache and reinstall
rm -rf node_modules .nuxt .output
pnpm install
pnpm dev
```

**Error: "Environment variable not set"**
- Check Netlify environment variables
- Ensure all required vars are set
- Redeploy after adding vars

### Authentication Not Working

**Users can't sign up:**
- Check Supabase auth settings
- Verify email provider is enabled
- Check email rate limits

**Email verification fails:**
- Update Site URL in Supabase
- Check redirect URLs
- Verify email template is correct

### Database Errors

**RLS policy errors:**
- Check policies in Supabase
- Verify user is authenticated
- Check table permissions

**Unique constraint violations:**
- Check for duplicate data
- Verify slug uniqueness logic

### Performance Issues

**Slow page loads:**
- Check database queries
- Add indexes to frequently queried columns
- Enable Netlify CDN
- Optimize images

---

## Scaling Considerations

### When to Upgrade

**Supabase:**
- Free tier: 500MB database, 2GB bandwidth, 50,000 monthly active users
- Upgrade at: ~1,000 active writers or 10,000 posts

**Netlify:**
- Free tier: 100GB bandwidth, 300 build minutes/month
- Upgrade at: ~50,000 monthly visitors

### Database Optimization

As you grow:
```sql
-- Add indexes for common queries
CREATE INDEX idx_posts_publication_status 
  ON posts(publication_id, status);

CREATE INDEX idx_subscriptions_publication_active 
  ON subscriptions(publication_id, status) 
  WHERE status = 'active';

-- Add full-text search
CREATE INDEX idx_posts_search 
  ON posts USING gin(to_tsvector('english', title || ' ' || content));
```

### Caching Strategy

Add caching headers in `nuxt.config.ts`:
```typescript
export default defineNuxtConfig({
  nitro: {
    routeRules: {
      '/_nuxt/**': { headers: { 'cache-control': 'public, max-age=31536000, immutable' } },
      '/api/**': { headers: { 'cache-control': 'no-cache' } },
      '/**': { headers: { 'cache-control': 'public, max-age=600, s-maxage=3600' } }
    }
  }
})
```

---

## Backup Strategy

### Database Backups

**Supabase automatic backups:**
- Free tier: Daily backups (7 days retention)
- Pro tier: Point-in-time recovery

**Manual backup:**
```bash
# Install Supabase CLI
brew install supabase/tap/supabase

# Login
supabase login

# Dump database
supabase db dump --project-ref xxxxx > backup.sql
```

### Repository Backups

GitHub automatically backs up your code, but also:
```bash
# Create releases
git tag -a v1.0.0 -m "Production release"
git push origin v1.0.0
```

---

## Security Hardening

### 1. Environment Variables
- Never commit `.env` files
- Use different keys for production
- Rotate keys regularly

### 2. Supabase Security
- Enable RLS on all tables
- Review policies regularly
- Monitor auth logs
- Enable 2FA on your Supabase account

### 3. Netlify Security
- Enable "Restrict to Netlify" for environment variables
- Set up deploy notifications
- Enable branch deploys for testing

### 4. Content Security Policy

Add to `nuxt.config.ts`:
```typescript
export default defineNuxtConfig({
  app: {
    head: {
      meta: [
        {
          'http-equiv': 'Content-Security-Policy',
          content: "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';"
        }
      ]
    }
  }
})
```

---

## Staging Environment

### Create Staging Site

1. In Netlify, click "Add new site"
2. Connect same GitHub repo
3. Choose branch: `staging`
4. Same build settings as production
5. Different environment variables:
   ```
   NUXT_PUBLIC_SUPABASE_URL=https://staging-xxxxx.supabase.co
   ```

### Workflow

```bash
# Develop on feature branches
git checkout -b feature/new-feature
# ... make changes
git commit -m "Add new feature"

# Merge to staging
git checkout staging
git merge feature/new-feature
git push origin staging
# Test on staging site

# Merge to production
git checkout main
git merge staging
git push origin main
# Auto-deploys to production
```

---

## Launch Checklist

### Pre-Launch
- [ ] All features tested on staging
- [ ] Database backed up
- [ ] Monitoring set up
- [ ] Error tracking configured
- [ ] Performance tested (Lighthouse > 90)
- [ ] Accessibility tested (WCAG 2.2 AA)
- [ ] Security reviewed
- [ ] DNS propagated (if custom domain)
- [ ] SSL certificate valid

### Launch Day
- [ ] Deploy to production
- [ ] Verify all functionality
- [ ] Monitor error logs
- [ ] Check performance
- [ ] Test from multiple devices
- [ ] Test from multiple locations

### Post-Launch
- [ ] Monitor for 24 hours
- [ ] Review analytics
- [ ] Check error rates
- [ ] Gather user feedback
- [ ] Create incident response plan

---

## Support & Maintenance

### Regular Tasks

**Daily:**
- Check error logs
- Monitor uptime

**Weekly:**
- Review analytics
- Check database growth
- Review user feedback

**Monthly:**
- Database optimization
- Dependency updates
- Security patches
- Backup verification

### Useful Commands

```bash
# Update dependencies
pnpm update

# Check for security vulnerabilities
pnpm audit

# Build locally to test
pnpm build
pnpm preview

# Clear all caches
rm -rf node_modules .nuxt .output
pnpm install
```

---

## Getting Help

### Resources

**Supabase:**
- Docs: https://supabase.com/docs
- Discord: https://discord.supabase.com
- GitHub: https://github.com/supabase/supabase

**Netlify:**
- Docs: https://docs.netlify.com
- Community: https://answers.netlify.com
- Support: https://www.netlify.com/support

**Nuxt:**
- Docs: https://nuxt.com/docs
- Discord: https://discord.nuxt.com
- GitHub: https://github.com/nuxt/nuxt

### Community

Start a discussion:
- Supabase Discord
- Netlify Community
- Nuxt Discord

---

## Next Steps

After successful deployment:

1. **Add Email Delivery** (Week 2)
   - Integrate Resend
   - Create email templates
   - Set up welcome emails

2. **Add Stripe Integration** (Week 3-4)
   - Connect Stripe accounts
   - Create subscription tiers
   - Process payments

3. **Enhance Features** (Month 2)
   - Rich text editor
   - Image uploads
   - Comments system
   - Analytics dashboard

4. **Scale & Optimize** (Month 3+)
   - Performance optimization
   - SEO improvements
   - Marketing integrations
   - Advanced analytics

---

## Success Metrics

Track these to measure success:

### User Metrics
- New writers per week
- New publications created
- Posts published per week
- Active publications (published in last 30 days)

### Reader Metrics
- Page views
- Unique visitors
- Subscription rate
- Return visitor rate

### Technical Metrics
- Uptime percentage (target: 99.9%)
- Average response time (target: < 1s)
- Error rate (target: < 0.1%)
- Lighthouse score (target: > 90)

---

**Congratulations!** 🎉

You've successfully deployed Beacon to production. Writers can now create publications, publish posts, and build their audiences. You've built something real and valuable.

Now go find your first users and start competing with Substack!
