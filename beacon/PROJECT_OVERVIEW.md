# Beacon - Project Overview

## What We've Built

Beacon is a **Substack alternative** built with ethical values at its core. It's a publishing platform for independent writers and journalists who refuse to share space with nazis, racists, and fascists.

## Core Differentiators

### 1. **Clear Values**
- Zero tolerance for hate speech, harassment, and misinformation
- Transparent content moderation with appeals
- Documented content policy

### 2. **Better Economics**
- **95/5 revenue split** (vs Substack's 90/10)
- Writers save **$5,000/year on every $100k earned**
- Direct Stripe Connect (writers control their money)
- No hidden fees

### 3. **True Ownership**
- Full data export anytime
- Portable subscriber lists
- No platform lock-in

### 4. **Accessibility First**
- WCAG 2.2 Level AA compliant
- Semantic HTML throughout
- Keyboard navigation
- Screen reader optimized

### 5. **Open Web**
- Full-text RSS feeds
- Potential ActivityPub integration
- No walled garden

## Tech Stack

- **Framework**: Nuxt 4 with TypeScript
- **Styling**: Vanilla CSS (no frameworks, clean and maintainable)
- **Database**: PostgreSQL via Supabase
- **Authentication**: Supabase Auth
- **Payments**: Stripe Connect
- **Email**: Resend + AWS SES
- **Package Manager**: pnpm

## What's Implemented (MVP Foundation)

### Infrastructure ✅
- Nuxt 4 project structure
- TypeScript configuration
- Vanilla CSS design system with 5 modular files
- Environment variable setup
- Git configuration

### Database ✅
- Comprehensive schema (10 tables)
- Row Level Security policies
- Automatic timestamps
- TypeScript types
- Multi-tenancy support

### Design System ✅
- CSS reset for consistency
- Design tokens (colors, spacing, typography)
- Component styles (buttons, forms, cards, etc.)
- Layout utilities
- Accessible focus styles
- Dark mode ready

### Core Pages ✅
- Homepage with hero and features
- Content Policy page (detailed moderation guidelines)
- Responsive layout with header/footer
- Proper semantic HTML and ARIA labels

### Accessibility ✅
- Skip links for keyboard users
- Semantic HTML5 landmarks
- Focus-visible styles
- Alt text requirements built-in
- Color contrast validated

## Project Structure

```
beacon/
├── app/
│   ├── composables/
│   │   └── useSupabase.ts          # Supabase client
│   ├── layouts/
│   │   └── default.vue              # Header/footer layout
│   ├── pages/
│   │   ├── index.vue                # Homepage
│   │   └── content-policy.vue       # Content policy
│   └── server/
│       ├── api/                     # Future API routes
│       └── utils/                   # Future utilities
├── assets/css/
│   ├── reset.css                    # Modern CSS reset
│   ├── variables.css                # Design tokens
│   ├── typography.css               # Text styles
│   ├── layout.css                   # Layout utilities
│   └── components.css               # Component styles
├── supabase/migrations/
│   ├── 001_initial_schema.sql       # Database tables
│   └── 002_rls_policies.sql         # Security policies
├── types/
│   └── database.ts                  # TypeScript types
├── app.vue                          # App entry point
├── nuxt.config.ts                   # Nuxt configuration
├── package.json                     # Dependencies (pnpm)
├── tsconfig.json                    # TypeScript config
├── README.md                        # Project README
└── DEVELOPMENT.md                   # Development docs
```

## Database Schema

### Tables
1. **profiles** - User accounts and profiles
2. **publications** - Writer publications/newsletters
3. **posts** - Individual articles
4. **tiers** - Subscription pricing
5. **subscriptions** - Reader subscriptions
6. **email_sends** - Newsletter analytics
7. **comments** - Post comments
8. **likes** - Post reactions
9. **reports** - Content moderation
10. **post_views** - Analytics

### Key Features
- Proper foreign keys and indexes
- Row Level Security on all tables
- Automatic updated_at triggers
- Data validation with constraints

## CSS Design System

### Variables (Design Tokens)
- **Colors**: Accessible palette (4.5:1 contrast minimum)
- **Typography**: System fonts, 9 size scale
- **Spacing**: 8px base unit (13 sizes)
- **Shadows**: 4 levels
- **Transitions**: 3 speeds
- **Z-index**: Organized scale

### Components
- Buttons (primary, secondary, ghost)
- Forms (inputs, textareas, labels, errors)
- Cards (with hover effects)
- Badges and alerts
- Avatars
- Loading spinners
- Proper focus states

### Layout
- Container widths (prose, content, wide, full)
- Flexbox utilities
- Grid utilities
- Spacing utilities
- Responsive breakpoints

## Next Steps (Priority Order)

### Immediate (Week 1-2)
1. **Authentication**
   - Sign up/sign in pages
   - Email verification
   - Profile creation

2. **Publications**
   - Create publication flow
   - Basic publication page
   - Slug validation

### Short Term (Week 3-4)
3. **Writing & Publishing**
   - Rich text editor (TipTap)
   - Draft/publish flow
   - Image uploads
   - Post pages

4. **Reading Experience**
   - Publication homepage
   - Post detail pages
   - RSS feed generation

### Medium Term (Month 2)
5. **Email Newsletters**
   - Email templates
   - Free subscriber sending
   - Basic analytics

6. **Subscriptions**
   - Stripe Connect setup
   - Tier management
   - Payment processing

### Long Term (Month 3+)
7. **Community**
   - Comments
   - Moderation tools
   - User following

8. **Analytics**
   - Writer dashboard
   - Traffic analytics
   - Revenue tracking

## Key Files to Review

### Configuration
- `nuxt.config.ts` - App configuration
- `package.json` - Dependencies
- `.env.example` - Required environment variables

### Database
- `supabase/migrations/001_initial_schema.sql` - Table definitions
- `supabase/migrations/002_rls_policies.sql` - Security policies
- `types/database.ts` - TypeScript types

### Styling
- `assets/css/variables.css` - Design tokens
- `assets/css/components.css` - Reusable components
- `assets/css/typography.css` - Text styles

### Pages
- `app/pages/index.vue` - Homepage
- `app/pages/content-policy.vue` - Content policy
- `app/layouts/default.vue` - Site layout

### Documentation
- `README.md` - Project overview and setup
- `DEVELOPMENT.md` - Detailed development guide

## Installation & Setup

```bash
# Navigate to project
cd /home/claude/beacon

# Install dependencies
pnpm install

# Set up environment variables
cp .env.example .env
# Edit .env with your credentials:
# - Supabase URL and keys
# - Stripe keys
# - Resend API key

# Run database migrations
# (Copy SQL from supabase/migrations/ to Supabase SQL editor)

# Start development server
pnpm dev
```

## Why This Matters

Beacon isn't just another publishing platform. It's a statement that **we can build better tools** that don't compromise on values for growth. 

Writers shouldn't have to choose between:
- Reach and ethical platform
- Monetization and ownership
- Community and safety

With Beacon, they get all three.

## Philosophy

### On Content Moderation
"We believe in free expression AND believe that hate speech harms everyone. These aren't contradictory - they're complementary. A platform that platforms nazis isn't truly free; it's hostile to everyone they target."

### On Economics
"Writers create the value. They should keep as much as possible. Our 5% platform fee covers infrastructure, moderation, and support - everything needed to run an ethical platform. Writers keep 95%. That extra 5% vs Substack is $5,000 saved per $100k earned."

### On Technology
"Vanilla CSS isn't trendy but it's maintainable. Semantic HTML isn't sexy but it's accessible. PostgreSQL isn't new but it's reliable. We choose boring technology that works."

### On the Open Web
"RSS feeds, data exports, and portable formats aren't features - they're rights. The web works best when users control their data."

## Success Metrics

### Launch Goals (6 months)
- 100 active publications
- 10,000 total subscribers across platform
- 90% writer satisfaction
- Zero successful hate speech appeals
- <24hr moderation response time

### Long Term (2 years)
- 1,000 active publications
- 500,000 subscribers
- Profitable platform operations
- Industry-leading content moderation
- Open source contributions

---

**Let's build a better web.** 🎯
