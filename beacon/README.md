# Beacon - Ethical Publishing Platform

> A modern, accessible Substack alternative that doesn't platform nazis. Better economics (95/5 split), better ethics, better accessibility.

**Status:** Production Ready MVP | **Built with:** Nuxt 4, TypeScript, Vanilla CSS, Supabase

---

## Why Beacon?

### Better Economics
- **95/5 revenue split** vs Substack's 90/10
- Writers save **$5,000 per $100,000 earned**
- No custom domain fees (Substack charges $50/year)
- Direct Stripe Connect deposits

### Better Ethics
- **Zero tolerance for hate speech**
- Clear content moderation policy
- No nazis, no racists, no fascists
- Transparent appeals process

### Better Experience
- **WCAG 2.2 Level AA compliant** (Substack isn't)
- Full data export anytime
- Open RSS feeds (Substack limits them)
- True ownership of your content and subscribers

---

## Features

### ✅ Production Ready

**For Writers:**
- Email/password and magic link authentication
- Create and manage publications at beacon.pub/{your-slug}
- Write and publish posts with auto-save
- Markdown support (upgradeable to rich text editor)
- Visibility controls (free/paid/subscribers-only)
- Build and manage subscriber lists
- Track growth with analytics dashboard
- Export subscribers to CSV

**For Readers:**
- Discover publications at clean, fast URLs
- Read posts with beautiful typography
- Subscribe to publications via email
- SEO-optimized pages with social sharing

**Technical Excellence:**
- Server-side rendering with Nuxt 4
- PostgreSQL database with Row Level Security
- Secure authentication via Supabase
- Accessible by design (WCAG 2.2 AA)
- Vanilla CSS (no framework bloat)
- Full TypeScript type safety

### 🚧 Next Steps

**Phase 1 (Week 2):**
- Email delivery integration (Resend)
- Double opt-in confirmation
- Welcome emails for new subscribers
- Newsletter templates

**Phase 2 (Month 2):**
- Stripe Connect integration
- Paid subscription tiers
- Payment processing with 95/5 split
- Writer payouts

**Phase 3 (Month 3+):**
- Comments system with moderation
- Rich text editor (TipTap)
- Image uploads and management
- Advanced analytics (opens, clicks, revenue)

---

## Quick Start

### Prerequisites
- Node.js 18+ or 20+
- pnpm 8+
- Supabase account (free tier works)

### Installation

```bash
# Clone and install
git clone https://github.com/yourusername/beacon.git
cd beacon
pnpm install

# Configure environment
cp .env.example .env
# Edit .env with your Supabase credentials

# Apply database migrations
# (See DEPLOYMENT.md for detailed instructions)

# Start development server
pnpm dev
```

Visit http://localhost:3000

### Environment Variables

```env
NUXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NUXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...

# Future integrations
STRIPE_SECRET_KEY=(coming soon)
RESEND_API_KEY=(coming soon)
```

---

## Documentation

Comprehensive guides for every system:

- **[DEPLOYMENT.md](./DEPLOYMENT.md)** - Production deployment guide ← Start here!
- **[AUTHENTICATION.md](./AUTHENTICATION.md)** - Complete auth system
- **[PUBLICATIONS.md](./PUBLICATIONS.md)** - Publication management
- **[POSTS.md](./POSTS.md)** - Writing and publishing
- **[SUBSCRIPTIONS.md](./SUBSCRIPTIONS.md)** - Email subscriptions
- **[PUBLIC_PAGES.md](./PUBLIC_PAGES.md)** - Reader experience
- **[ECONOMICS.md](./ECONOMICS.md)** - Revenue comparison

---

## Project Structure

```
beacon/
├── app/
│   ├── assets/css/          # Vanilla CSS design system
│   ├── composables/         # Reusable logic (auth, pubs, posts, subs)
│   ├── layouts/             # Page layouts (default, minimal)
│   ├── middleware/          # Route guards (auth)
│   ├── pages/               # File-based routing
│   │   ├── [publication]/   # Public pages (:publication, :publication/:post)
│   │   ├── auth/            # Auth flows (login, signup, callback)
│   │   ├── publications/    # Writer dashboard
│   │   └── dashboard.vue    # Main dashboard
│   └── plugins/             # Init plugins (auth state)
├── supabase/
│   └── migrations/          # Database schema (10 tables)
├── types/                   # TypeScript definitions
└── public/                  # Static assets

Documentation:
├── README.md                # This file
├── DEPLOYMENT.md            # Deployment guide
├── AUTHENTICATION.md        # Auth docs
├── PUBLICATIONS.md          # Publications docs
├── POSTS.md                 # Posts system docs
├── SUBSCRIPTIONS.md         # Email subscriptions docs
├── PUBLIC_PAGES.md          # Reader pages docs
└── ECONOMICS.md             # Revenue comparison
```

---

## Tech Stack

### Frontend
- **Nuxt 4** - Vue framework with SSR/SSG
- **TypeScript** - Type safety throughout
- **Vanilla CSS** - Custom design system, zero dependencies
- **Semantic HTML** - Accessibility-first markup

### Backend
- **Supabase** - PostgreSQL + Authentication
- **Row Level Security** - Database-level permissions
- **PostgreSQL** - Robust, scalable relational database

### Deployment
- **Netlify** - Hosting with CI/CD
- **Supabase Cloud** - Managed database
- **Custom Domains** - Professional URLs

---

## Database Schema

10 tables with comprehensive relationships:

1. **profiles** - User accounts (linked to auth.users)
2. **publications** - Writer publications (has many posts)
3. **posts** - Published content (belongs to publication)
4. **tiers** - Subscription tiers (free, paid, custom)
5. **subscriptions** - Reader subscriptions (belongs to publication + tier)
6. **email_sends** - Email delivery tracking
7. **comments** - Post comments (with moderation)
8. **likes** - Post reactions
9. **reports** - Content moderation reports
10. **post_views** - Analytics tracking

All tables have Row Level Security policies enforcing access control.

See `supabase/migrations/` for complete schema.

---

## Design System

Custom vanilla CSS following accessibility best practices:

### Foundation
- **Colors** - 4.5:1 contrast ratios minimum
- **Typography** - System fonts + serif for reading
- **Spacing** - 8px base scale
- **Responsive** - Mobile-first breakpoints

### Components
- Buttons (primary, secondary, ghost, danger)
- Forms (inputs, labels, validation)
- Cards (publications, posts, stats)
- Badges (status, visibility, type)
- Modals (accessible dialogs)
- Loading states (spinners, skeletons)

All components are WCAG 2.2 Level AA compliant.

---

## Accessibility

### Standards
- ✅ WCAG 2.2 Level AA compliant
- ✅ Semantic HTML5 landmarks
- ✅ Proper heading hierarchy (h1-h6)
- ✅ ARIA labels and live regions
- ✅ Keyboard navigation (Tab, Enter, Escape)
- ✅ Focus management and visible focus states
- ✅ Color contrast validated (4.5:1+ for text)
- ✅ Screen reader optimized

### Testing Tools
- WAVE browser extension
- axe DevTools
- Lighthouse accessibility audit
- VoiceOver (Mac) / NVDA (Windows)

---

## Security

### Authentication
- Secure password hashing (bcrypt via Supabase)
- Email verification required
- Magic link authentication option
- Session auto-refresh
- Password reset flow

### Database
- Row Level Security on all tables
- Users can only access their own data
- SQL injection prevention
- Prepared statements throughout

### Application
- Environment variables for secrets
- HTTPS only in production
- CORS configured correctly
- Rate limiting via Supabase

---

## Performance

### Targets
- First Contentful Paint: < 1.5s
- Largest Contentful Paint: < 2.5s
- Time to Interactive: < 3.5s
- Lighthouse Score: > 90

### Optimizations
- Server-side rendering (SSR)
- Static site generation (SSG) capable
- Route-based code splitting
- Lazy loading for images
- Minimal JavaScript payload
- CSS tree-shaking

---

## Content Policy

### Zero Tolerance For:
- Hate speech (racism, antisemitism, islamophobia)
- Nazism and fascism
- Harassment and coordinated abuse
- Misinformation campaigns
- Violence, terrorism, and threats
- Child exploitation

### Explicitly Allowed:
- Political commentary (all perspectives within reason)
- Religious discussion
- Scientific debate
- Satire and parody
- Investigative journalism
- Advocacy and activism

Full policy available at `/content-policy` on the live site.

---

## Economics Breakdown

### Revenue Split Comparison

| Your Revenue | Substack Takes | Beacon Takes | You Save |
|-------------|----------------|--------------|----------|
| $1,000      | $100 (10%)     | $50 (5%)     | $50      |
| $10,000     | $1,000         | $500         | $500     |
| $100,000    | $10,000        | $5,000       | **$5,000**   |
| $1,000,000  | $100,000       | $50,000      | **$50,000**  |

### Additional Fees
- **Stripe**: ~2.9% + $0.30 per transaction (same for both platforms)
- **Custom Domain**: Free on Beacon, $50/year on Substack

See [ECONOMICS.md](./ECONOMICS.md) for detailed breakdown.

---

## Development Commands

```bash
# Development
pnpm dev          # Start dev server (localhost:3000)
pnpm build        # Build for production
pnpm preview      # Preview production build
pnpm generate     # Generate static site

# Code Quality
pnpm lint         # Lint with ESLint (future)
pnpm type-check   # TypeScript type checking (future)

# Database
# Migrations are in supabase/migrations/
# Apply via Supabase dashboard SQL editor
# See DEPLOYMENT.md for instructions
```

---

## Deployment

Full deployment guide in [DEPLOYMENT.md](./DEPLOYMENT.md)

**Quick steps:**
1. Create Supabase project (free tier)
2. Run database migrations
3. Push code to GitHub
4. Deploy to Netlify (free tier)
5. Configure custom domain (optional)
6. Test everything
7. Launch!

Estimated time: 30-45 minutes

---

## Roadmap

### Q1 2026 - MVP Launch ✅
- [x] Core platform (auth, publications, posts)
- [x] Public pages (reader experience)
- [x] Subscription system (email capture)
- [ ] Email delivery (Resend integration)
- [ ] Beta launch with 10-20 writers

### Q2 2026 - Monetization
- [ ] Stripe Connect integration
- [ ] Paid subscription tiers
- [ ] Payment processing (95/5 split)
- [ ] Writer payouts
- [ ] Public launch

### Q3 2026 - Enhancement
- [ ] Comments system with moderation
- [ ] Rich text editor (TipTap)
- [ ] Image uploads and management
- [ ] Analytics dashboard
- [ ] Mobile optimization

### Q4 2026 - Scale
- [ ] Search functionality
- [ ] Writer recommendations
- [ ] Team/multi-author support
- [ ] API for integrations
- [ ] Mobile apps (iOS/Android)

---

## Contributing

Currently in private development phase. Contributions will be welcomed after initial public launch.

Future areas:
- Bug reports and fixes
- Feature requests and implementation
- Documentation improvements
- Accessibility testing and improvements
- Translations (i18n)

---

## License

Copyright © 2026 Beacon

Proprietary and confidential. All rights reserved.

(Will consider open-sourcing portions after launch)

---

## Support

**Documentation**: Comprehensive guides in `/docs`

**Coming Soon:**
- GitHub Issues (after public launch)
- Community Discord
- Email support
- Documentation site

---

## Acknowledgments

Built with excellent open source tools:
- [Nuxt](https://nuxt.com) - The Vue framework
- [Supabase](https://supabase.com) - Open source Firebase alternative
- [TypeScript](https://typescriptlang.org) - JavaScript with types
- [pnpm](https://pnpm.io) - Fast package manager

Inspired by the need for ethical, accessible platforms that respect both writers and readers.

---

## Key Differentiators

**What makes Beacon special:**

1. **Better Economics** - 95/5 split saves writers thousands
2. **Better Ethics** - No nazis, clear content policy, transparent moderation
3. **Better Accessibility** - WCAG 2.2 AA compliant, reaching more readers
4. **True Ownership** - Full data export, portable subscribers, no lock-in
5. **Open Web** - RSS feeds, semantic HTML, future ActivityPub

**Technical Excellence:**
- Vanilla CSS (maintainable, no bloat)
- TypeScript (type safe)
- Accessible by default
- Fast (SSR/SSG)
- Secure (RLS, proper auth)

---

**Ready to launch. Ready to compete. Ready to build a better internet.** 🚀

For deployment instructions, see [DEPLOYMENT.md](./DEPLOYMENT.md)
