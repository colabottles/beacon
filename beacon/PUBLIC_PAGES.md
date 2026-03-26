# Public Pages Documentation

## Overview

Public pages are what readers see - the publication homepage and individual post pages. These are the SEO-optimized, accessible pages that make content discoverable.

## Features Implemented

### Publication Homepage ✅
- Clean, professional design
- Publication header with title, description
- Subscriber count and post count
- Subscribe button (with modal)
- List of published posts
- Post cards with cover images, titles, excerpts
- Empty state for new publications

### Post Reading Page ✅
- Full post content with Markdown rendering
- Publication breadcrumb link
- Post metadata (date, views)
- Cover image support
- Subscribe CTA at bottom
- SEO meta tags (Open Graph, Twitter Cards)
- Accessible semantic HTML

### Subscribe Modal ✅
- Email capture form
- Validation
- Success handling (placeholder)
- Accessible (ARIA labels, keyboard nav)

## File Structure

```
app/
└── pages/
    └── [publication]/
        ├── index.vue           # Publication homepage
        └── [post].vue          # Post reading page
```

## URL Structure

```
beacon.pub/                    # Platform homepage
beacon.pub/my-newsletter       # Publication homepage
beacon.pub/my-newsletter/post  # Individual post
```

## Dynamic Routing

Nuxt automatically creates routes from file structure:

```
[publication]/index.vue   → /:publication
[publication]/[post].vue  → /:publication/:post
```

Route params accessible via:
```typescript
const route = useRoute()
const publicationSlug = route.params.publication as string
const postSlug = route.params.post as string
```

## Publication Homepage

### Layout
1. **Header Section**
   - Publication title (h1)
   - Description
   - Subscriber count
   - Post count
   - Subscribe button

2. **Posts List**
   - Chronological order (newest first)
   - Post cards with:
     - Cover image (if available)
     - Title
     - Subtitle or excerpt
     - Published date
     - Visibility badge (if paid/subscribers)

3. **Empty State**
   - Shown when no published posts
   - Encourages subscription

### SEO
```html
<title>Publication Title - Beacon</title>
<meta name="description" content="Publication description">
```

## Post Reading Page

### Layout
1. **Header**
   - Publication link (breadcrumb)
   - Post title (h1)
   - Subtitle
   - Metadata (date, views)

2. **Cover Image**
   - Full width
   - Responsive
   - Optional

3. **Content**
   - Markdown rendered to HTML
   - Prose typography styles
   - Max-width for readability

4. **Footer**
   - Subscribe CTA
   - Back to publication link

### Markdown Rendering

Current implementation (basic):
```typescript
const renderedContent = computed(() => {
  let html = post.value.content
  
  // Headings
  html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>')
  html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>')
  html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>')
  
  // Bold, italic, links
  html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
  html = html.replace(/\*(.*?)\*/g, '<em>$1</em>')
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
  
  // Paragraphs
  html = html.replace(/\n\n/g, '</p><p>')
  html = `<p>${html}</p>`
  
  return html
})
```

**TODO: Replace with proper Markdown library (marked.js, markdown-it)**

### SEO Meta Tags

```typescript
useHead(() => ({
  title: `${post.title} - ${publication.title} - Beacon`,
  meta: [
    { name: 'description', content: post.excerpt },
    // Open Graph
    { property: 'og:title', content: post.title },
    { property: 'og:description', content: post.excerpt },
    { property: 'og:type', content: 'article' },
    { property: 'og:image', content: post.cover_image_url },
    // Twitter Card
    { name: 'twitter:card', content: 'summary_large_image' },
    { name: 'twitter:title', content: post.title },
    { name: 'twitter:description', content: post.excerpt },
    { name: 'twitter:image', content: post.cover_image_url }
  ]
}))
```

## Subscribe Modal

Shared component between publication and post pages.

### Features
- Email input with validation
- Error messages
- Loading state
- Success handling
- Close button
- Click outside to close
- Accessible (ARIA, keyboard)

### Implementation (Current)
```typescript
const handleSubscribe = async () => {
  // Validate email
  // Call subscription API (TODO)
  // Show success message
  // Close modal
}
```

## Access Control

Posts have visibility settings:
- **free** - Anyone can read
- **subscribers** - Requires free subscription
- **paid** - Requires paid subscription

Current implementation shows all posts (TODO: Implement access control).

## Analytics Tracking

TODO: Track when posts are viewed:
```typescript
// Increment view_count on post load
// Track unique visitors
// Log view in post_views table
```

## Performance

### Optimizations
- Static site generation (SSG) for published posts
- Image optimization (@nuxt/image)
- Code splitting per route
- Lazy loading images

### Caching Strategy
- Cache publication data (short TTL)
- Cache post content (longer TTL)
- Invalidate on publish/update

## Accessibility

### Semantic HTML
```html
<article>
  <header>
    <h1>Post Title</h1>
    <time datetime="2026-02-10">February 10, 2026</time>
  </header>
  <div class="prose">
    <!-- Content -->
  </div>
  <footer>
    <!-- Subscribe CTA -->
  </footer>
</article>
```

### ARIA Labels
- Modal dialogs
- Form inputs
- Error messages
- Loading states

### Keyboard Navigation
- Tab through links
- Escape to close modal
- Enter to submit forms

### Screen Readers
- Proper heading hierarchy
- Alt text for images
- Form labels
- Live regions for errors

## Responsive Design

### Breakpoints
- Desktop: 1024px+
- Tablet: 768px - 1023px
- Mobile: < 768px

### Mobile Optimizations
- Smaller text sizes
- Stacked layouts
- Touch-friendly buttons (44px minimum)
- Reduced spacing

## Error Handling

### Publication Not Found
```
Publication Not Found
This publication does not exist
[Return to Homepage]
```

### Post Not Found
```
Post Not Found
This post does not exist
[Back to Publication]
```

### Access Denied (Future)
```
Subscribers Only
Subscribe to read this post
[Subscribe Button]
```

## Future Enhancements

### Publication Page
- [ ] Pagination for posts
- [ ] Filter by category/tag
- [ ] Search functionality
- [ ] Archive view
- [ ] Featured posts
- [ ] Custom branding (logo, colors)
- [ ] Custom About page

### Post Page
- [ ] Related posts
- [ ] Comments section
- [ ] Like/reaction buttons
- [ ] Share buttons (Twitter, LinkedIn)
- [ ] Reading progress indicator
- [ ] Estimated reading time
- [ ] Table of contents (for long posts)
- [ ] Syntax highlighting (code blocks)

### Subscribe Modal
- [ ] Social authentication
- [ ] Multi-step wizard
- [ ] Welcome bonus incentive
- [ ] Referral tracking

### Analytics
- [ ] View tracking
- [ ] Scroll depth
- [ ] Time on page
- [ ] Click tracking
- [ ] Conversion tracking

### SEO
- [ ] Structured data (Article schema)
- [ ] Canonical URLs
- [ ] Sitemap generation
- [ ] RSS feed per publication
- [ ] AMP pages (optional)

## Testing Checklist

### Publication Page
- [ ] Loads with valid slug
- [ ] Shows 404 with invalid slug
- [ ] Displays publication info correctly
- [ ] Lists published posts only
- [ ] Shows empty state when no posts
- [ ] Subscribe button opens modal
- [ ] Post cards link to posts
- [ ] Responsive on mobile

### Post Page
- [ ] Loads with valid slugs
- [ ] Shows 404 with invalid slugs
- [ ] Displays post content correctly
- [ ] Renders Markdown properly
- [ ] Shows cover image
- [ ] Displays metadata
- [ ] Subscribe CTA works
- [ ] Back link works
- [ ] Meta tags correct
- [ ] Responsive on mobile

### Subscribe Modal
- [ ] Opens on button click
- [ ] Closes on X button
- [ ] Closes on outside click
- [ ] Closes on Escape key
- [ ] Validates email format
- [ ] Shows error messages
- [ ] Shows loading state
- [ ] Shows success state
- [ ] Traps focus (accessibility)

## SEO Optimization

### Title Tag Formula
```
Post: "Post Title - Publication Name - Beacon"
Publication: "Publication Name - Beacon"
```

### Meta Description
- Use post excerpt (first 160 chars)
- Fallback to subtitle
- Fallback to title

### URL Structure
- Clean, readable URLs
- No query parameters
- Permanent URLs (slugs immutable)

### Social Sharing
- Open Graph tags for Facebook
- Twitter Card tags
- Image: 1200x630px recommended
- Description: 160 characters

## Performance Metrics

### Target Goals
- First Contentful Paint: < 1.5s
- Largest Contentful Paint: < 2.5s
- Time to Interactive: < 3.5s
- Lighthouse Score: > 90

### Optimization Techniques
- Server-side rendering (SSR)
- Static site generation (SSG)
- Image optimization
- Code splitting
- Lazy loading
- Minimal JavaScript

---

Last Updated: February 10, 2026
