# Posts System Documentation

## Overview

The posts system is where writers create, edit, and publish content. Posts belong to publications and can be free or paid.

## Features Implemented

### Post Creation ✅
- Distraction-free editor (no header/footer)
- Auto-save every 30 seconds
- Auto-generate slug from title
- Real-time slug availability checking
- Markdown support (future: rich text)
- Draft/publish workflow

### Post Management ✅
- List all posts (with tabs: all/published/drafts)
- View post stats (views, status)
- Edit posts
- Delete posts (future)
- Filter by status

### Post Settings ✅
- Title and subtitle
- Content editor (textarea, upgradeable to TipTap)
- URL slug
- Excerpt (auto-generated if empty)
- Visibility (free/subscribers/paid)
- Email notification on publish

## File Structure

```
app/
├── composables/
│   └── usePosts.ts                    # Post CRUD operations
└── pages/
    └── publications/
        └── [id]/
            └── posts/
                ├── index.vue          # Posts list
                ├── new.vue            # Create new post
                └── [postId]/
                    └── edit.vue       # Edit post (future)
```

## Database Schema

```sql
CREATE TABLE posts (
  id UUID PRIMARY KEY,
  publication_id UUID NOT NULL REFERENCES publications(id),
  title TEXT NOT NULL,
  slug TEXT NOT NULL,
  subtitle TEXT,
  content TEXT NOT NULL,
  excerpt TEXT,
  cover_image_url TEXT,
  status TEXT DEFAULT 'draft', -- draft, published, scheduled
  visibility TEXT DEFAULT 'free', -- free, subscribers, paid
  published_at TIMESTAMPTZ,
  scheduled_for TIMESTAMPTZ,
  send_email BOOLEAN DEFAULT TRUE,
  email_sent_at TIMESTAMPTZ,
  meta_title TEXT,
  meta_description TEXT,
  view_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(publication_id, slug)
);
```

## Usage

### usePosts Composable

```typescript
const {
  getPublicationPosts,      // Get all posts for publication
  getPost,                  // Get single post by ID
  getPostBySlug,            // Get post by slug
  checkSlugAvailability,    // Check if slug available
  generateSlug,             // Generate slug from title
  generateExcerpt,          // Generate excerpt from content
  createPost,               // Create new post
  updatePost,               // Update post
  publishPost,              // Publish a draft
  unpublishPost,            // Revert to draft
  deletePost,               // Delete post
} = usePosts()
```

### Creating a Post

```typescript
const { createPost, generateSlug } = usePosts()

const { data, error } = await createPost(publicationId, {
  title: "My First Post",
  slug: generateSlug("My First Post"), // "my-first-post"
  content: "This is my content...",
  status: 'draft',
  visibility: 'free',
  send_email: true
})
```

### Publishing a Post

```typescript
const { publishPost } = usePosts()

// Publish and send email to subscribers
const { data, error } = await publishPost(postId, true)
```

## Post States

### Status
- **draft** - Not published, only visible to author
- **published** - Live and visible based on visibility setting
- **scheduled** - Will be published at scheduled_for time (future)

### Visibility
- **free** - Anyone can read
- **subscribers** - Free & paid subscribers only
- **paid** - Paid subscribers only

## Editor Features

### Current Implementation
- Clean, distraction-free interface
- Large title input
- Optional subtitle
- Textarea for content (Markdown)
- Collapsible settings panel
- Auto-save every 30 seconds
- Manual save to draft
- Publish modal with preview

### Future Enhancements
- Rich text editor (TipTap)
- Image uploads
- Embed videos/tweets
- Code syntax highlighting
- Table support
- Collaboration (real-time editing)

## Auto-Save

Posts auto-save to drafts every 30 seconds:

```typescript
onMounted(() => {
  const autoSaveInterval = setInterval(() => {
    if (form.title || form.content) {
      saveDraft(true) // Silent save
    }
  }, 30000)
  
  onBeforeUnmount(() => {
    clearInterval(autoSaveInterval)
  })
})
```

## Slug Generation

### Rules
- Lowercase only
- Remove special characters
- Replace spaces with hyphens
- Remove multiple consecutive hyphens
- Max 100 characters
- Must be unique per publication

### Examples
```javascript
"My Amazing Post!" → "my-amazing-post"
"10 Tips for Writers" → "10-tips-for-writers"
"Tech & Startups" → "tech-startups"
```

## Excerpt Generation

If no manual excerpt provided:
1. Strip HTML tags from content
2. Take first 200 characters
3. Add ellipsis if truncated

```typescript
const generateExcerpt = (content: string, maxLength = 200) => {
  const text = content.replace(/<[^>]*>/g, '')
  return text.length <= maxLength 
    ? text 
    : text.substring(0, maxLength).trim() + '...'
}
```

## Validation

### Client-Side
- Title required (min 1 char)
- Content required (min 1 char)
- Slug required (min 3 chars, lowercase alphanumeric + hyphens)
- Slug format validation
- Real-time availability checking

### Server-Side
- Unique slug per publication
- User can only create posts for their publications
- RLS policies enforce ownership

## Row Level Security

```sql
-- Anyone can view published free posts
CREATE POLICY "View published free posts"
  ON posts FOR SELECT
  USING (status = 'published' AND visibility = 'free');

-- Subscribers can view subscriber posts
CREATE POLICY "View subscriber posts"
  ON posts FOR SELECT
  USING (
    status = 'published' AND
    (visibility = 'free' OR user_has_subscription())
  );

-- Authors can view all their posts
CREATE POLICY "Authors view own posts"
  ON posts FOR SELECT
  USING (
    publication_id IN (
      SELECT id FROM publications WHERE user_id = auth.uid()
    )
  );

-- Authors can manage their posts
CREATE POLICY "Authors manage posts"
  ON posts FOR ALL
  USING (
    publication_id IN (
      SELECT id FROM publications WHERE user_id = auth.uid()
    )
  );
```

## User Experience

### Writing Flow
1. Click "New Post" from dashboard or posts list
2. Start writing (title auto-generates slug)
3. Write content in distraction-free editor
4. Auto-saves every 30 seconds
5. Optionally customize settings
6. Click "Publish" when ready
7. Review in publish modal
8. Confirm publication
9. Redirected to published post

### Posts List
- Tabs: All / Published / Drafts
- Shows post title, excerpt, status
- Badges for status and visibility
- View count
- Published/created date
- Quick actions: Edit, View

## Accessibility

### Editor
- No layout distractions (fullscreen focus)
- Clear visual hierarchy
- Keyboard shortcuts (future)
- Screen reader support
- Proper focus management

### Forms
- Semantic HTML
- Label associations
- ARIA attributes
- Error announcements
- Loading states

## Performance

### Optimizations
- Debounced auto-save (avoid excessive DB writes)
- Client-side validation before API calls
- Optimistic UI updates
- Indexed slug column for fast lookups

### Caching
- Cache posts list
- Invalidate on create/update/delete
- Use optimistic updates

## Markdown Support

Current editor supports Markdown syntax:

```markdown
# Heading 1
## Heading 2
**bold text**
*italic text*
[link](https://example.com)
![image](url)
- bullet list
1. numbered list
> blockquote
`code`
```

Future: Upgrade to rich text editor with WYSIWYG interface.

## Publishing

### Publish Modal
Shows preview:
- Title
- Subtitle
- Visibility badge
- Email notification status

Confirms before publishing.

### Email Notification
If `send_email` is true:
- Queues email to all subscribers
- Respects subscriber preferences
- Tracks open rates (future)

## Analytics (Future)

Track per post:
- Views
- Unique visitors
- Time on page
- Scroll depth
- Email opens
- Email clicks
- Conversion to paid

## SEO

### Auto-Generated
- `<title>` from post title
- `<meta description>` from excerpt
- Open Graph tags
- Twitter cards
- Canonical URLs

### Customizable
- Custom meta title
- Custom meta description
- Featured image

## Testing Checklist

### Creation
- [ ] Can create post with valid data
- [ ] Slug auto-generates from title
- [ ] Slug availability checked
- [ ] Duplicate slug rejected
- [ ] Auto-save works
- [ ] Manual save works
- [ ] Publish modal shows preview
- [ ] Publishing works
- [ ] Redirects after publish

### List
- [ ] Shows empty state
- [ ] Lists all posts
- [ ] Tabs filter correctly
- [ ] Badges show correct status
- [ ] Stats displayed
- [ ] Links work

### Update
- [ ] Can edit title
- [ ] Can edit content
- [ ] Can change settings
- [ ] Cannot change slug (immutable)
- [ ] Auto-save persists changes
- [ ] Manual save works

### Delete
- [ ] Can delete post (future)
- [ ] Cascades to comments/likes
- [ ] Removes from list

## Error Handling

### Common Errors

**"Slug already taken"**
- Another post in this publication uses slug
- Suggest alternative

**"Post not found"**
- Post deleted
- User doesn't have access
- Redirect to posts list

**"Failed to publish"**
- Network error
- Database error
- Show error, keep draft

**"Auto-save failed"**
- Silent failure
- Show warning indicator
- Retry on next interval

## Future Enhancements

### Rich Text Editor
- [ ] Integrate TipTap
- [ ] WYSIWYG interface
- [ ] Markdown shortcuts
- [ ] Image uploads
- [ ] Embeds (YouTube, Twitter, etc)

### Media
- [ ] Cover image upload
- [ ] Image gallery
- [ ] Video embeds
- [ ] Audio embeds

### Collaboration
- [ ] Multiple authors
- [ ] Comments on drafts
- [ ] Track changes
- [ ] Version history

### Scheduling
- [ ] Schedule publish time
- [ ] Recurring posts
- [ ] Auto-publish

### Advanced
- [ ] A/B test titles
- [ ] Custom CSS per post
- [ ] Custom templates
- [ ] Series/collections

---

Last Updated: February 10, 2026
