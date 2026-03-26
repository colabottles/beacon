# Beacon - Project Documentation

## Architecture Overview

### Technology Stack
- **Frontend**: Nuxt 4 (Vue 3) with TypeScript
- **Styling**: Vanilla CSS with CSS custom properties
- **Database**: PostgreSQL via Supabase
- **Authentication**: Supabase Auth
- **File Storage**: Supabase Storage
- **Email**: Resend/Postmark (transactional) + AWS SES (bulk newsletters)
- **Payments**: Stripe Connect
- **Hosting**: Netlify
- **Package Manager**: pnpm

### Design Principles
1. **Accessibility First**: WCAG 2.2 Level AA compliance
2. **Semantic HTML**: Proper HTML5 landmarks and structure
3. **Progressive Enhancement**: Works without JavaScript
4. **Performance**: Fast loading, optimized images
5. **Privacy**: Minimal tracking, user data control
6. **Ownership**: Users own their data and content

## Database Schema

### Core Tables
- `profiles` - User profiles (extends Supabase auth.users)
- `publications` - Writer publications/newsletters
- `posts` - Individual articles/posts
- `tiers` - Subscription pricing tiers
- `subscriptions` - Reader subscriptions
- `comments` - Post comments
- `likes` - Post likes/reactions
- `email_sends` - Newsletter analytics
- `reports` - Content moderation reports
- `post_views` - Analytics tracking

### Key Features
- Row Level Security (RLS) for multi-tenancy
- Automatic updated_at timestamps
- Indexed foreign keys for performance
- Check constraints for data validation

## CSS Architecture

### File Organization
```
assets/css/
├── reset.css       # Modern CSS reset
├── variables.css   # Design tokens (colors, spacing, typography)
├── typography.css  # Text styles and prose content
├── layout.css      # Layout utilities and grid
└── components.css  # Reusable component styles
```

### Design System
- **Colors**: Accessible palette with proper contrast ratios
- **Typography**: System font stack, serif for articles
- **Spacing**: 8px base unit scale (4, 8, 12, 16, 20, 24, 32...)
- **Breakpoints**: Mobile-first responsive design
- **Dark Mode**: Prepared with CSS custom properties

## Content Policy

Beacon's core differentiator is its clear stance against hate speech and harmful content:

### Zero Tolerance For:
- Hate speech, nazism, racism, fascism
- Harassment and coordinated abuse
- Deliberate misinformation campaigns
- Violence and extremism
- Child exploitation

### Support For:
- Political commentary across the spectrum
- Religious discussion and debate
- Scientific discussion
- Satire and humor
- Investigative journalism
- Advocacy and activism

## Completed Work

### Phase 1: Foundation ✅
- [x] Project structure
- [x] Nuxt 4 configuration
- [x] TypeScript setup
- [x] Vanilla CSS design system
- [x] Database schema (initial)
- [x] Row Level Security policies
- [x] TypeScript types for database
- [x] Default layout with header/footer
- [x] Homepage with hero and features
- [x] Content Policy page
- [x] Accessibility foundations (skip links, ARIA, semantic HTML)

## Next Steps

### Phase 2: Authentication & Profiles
- [ ] Supabase integration composable
- [ ] Sign up / sign in pages
- [ ] Profile creation flow
- [ ] Profile editing
- [ ] Avatar upload
- [ ] Email verification

### Phase 3: Publications
- [ ] Create publication flow
- [ ] Publication settings page
- [ ] Custom domain setup
- [ ] Publication theming options
- [ ] Slug generation and validation

### Phase 4: Writing & Publishing
- [ ] Rich text editor (TipTap with accessibility)
- [ ] Draft/publish/schedule functionality
- [ ] Image upload for posts
- [ ] SEO metadata editor
- [ ] Preview mode
- [ ] Post analytics view

### Phase 5: Reader Experience
- [ ] Publication homepage
- [ ] Post reading view
- [ ] Subscription widget
- [ ] RSS feed generation
- [ ] Search functionality
- [ ] Related posts

### Phase 6: Email Newsletters
- [ ] Email template system
- [ ] Newsletter sending (free subscribers)
- [ ] Email analytics (opens, clicks)
- [ ] Subscriber management
- [ ] Unsubscribe flow

### Phase 7: Monetization
- [ ] Stripe Connect onboarding
- [ ] Subscription tier management
- [ ] Payment processing
- [ ] Subscriber-only content
- [ ] Revenue dashboard
- [ ] Payout management

### Phase 8: Community Features
- [ ] Comments system
- [ ] Comment moderation tools
- [ ] Likes/reactions
- [ ] Reader profiles
- [ ] Following publications

### Phase 9: Moderation
- [ ] Content reporting
- [ ] Moderation dashboard
- [ ] Moderator roles
- [ ] Appeal system
- [ ] Transparency reports

### Phase 10: Analytics & Growth
- [ ] Writer analytics dashboard
- [ ] Traffic sources
- [ ] Subscriber growth charts
- [ ] Email performance metrics
- [ ] Referral tracking

## Development Workflow

### Local Development
```bash
# Install dependencies
pnpm install

# Set up environment variables
cp .env.example .env
# Edit .env with your Supabase credentials

# Run dev server
pnpm dev

# Type checking
pnpm typecheck
```

### Database Migrations
1. Create migration file in `supabase/migrations/`
2. Run in Supabase SQL editor
3. Test with sample data
4. Document changes in migration file

### Deployment
- Push to main branch
- Netlify auto-deploys
- Environment variables set in Netlify dashboard

## Accessibility Checklist

### Every Component Must Have:
- [ ] Semantic HTML elements
- [ ] Proper ARIA labels where needed
- [ ] Keyboard navigation support
- [ ] Focus visible styles
- [ ] Skip links for main content
- [ ] Alt text for images
- [ ] Form labels and error messages
- [ ] Color contrast minimum 4.5:1
- [ ] No reliance on color alone
- [ ] Respects prefers-reduced-motion

## Performance Targets
- [ ] First Contentful Paint < 1.5s
- [ ] Time to Interactive < 3.5s
- [ ] Lighthouse score > 90
- [ ] Images lazy-loaded
- [ ] CSS optimized (no unused styles)
- [ ] JavaScript minimal (Vue SSR)

## Security Checklist
- [ ] RLS enabled on all tables
- [ ] HTTPS only
- [ ] Content Security Policy headers
- [ ] XSS protection
- [ ] CSRF tokens on forms
- [ ] Rate limiting on API endpoints
- [ ] Input validation and sanitization
- [ ] Secure password requirements
- [ ] 2FA support (future)

## Revenue Model

### Platform Fees
- **5% of subscription revenue** (vs Substack's 10%)
- Covers infrastructure, moderation, support
- Direct Stripe Connect to writers
- **Writers save $5,000/year per $100k earned vs Substack**

### Cost Structure
- Hosting: Netlify + Supabase (~$50-200/mo initially)
- Email: SES ($0.10/1000 emails)
- Support: Part-time moderators
- Development: Open source contributors

### Sustainability
- Aim for 1,000-2,000 active publications
- Average $50/mo per publication (writer revenue)
- Platform revenue at 5%: $2,500-5,000/mo
- Covers operations + modest team
- Growth through word-of-mouth ("save $5k/year!")

## Open Questions

1. **Editor Choice**: TipTap vs ProseMirror vs custom?
2. **Email Provider**: Resend vs Postmark for transactional?
3. **ActivityPub**: Implement in Phase 1 or wait?
4. **Mobile Apps**: Web-first or native?
5. **Collaborative Writing**: Add multiple authors per publication?
6. **Import Tool**: Support for Substack/Medium imports?

## Resources

### Documentation
- Nuxt: https://nuxt.com/docs
- Supabase: https://supabase.com/docs
- Stripe Connect: https://stripe.com/docs/connect
- WCAG 2.2: https://www.w3.org/WAI/WCAG22/quickref/

### Inspiration
- Substack (what to improve)
- Ghost (open source model)
- Medium (reading experience)
- Write.as (simplicity)

---

Last Updated: February 10, 2026
