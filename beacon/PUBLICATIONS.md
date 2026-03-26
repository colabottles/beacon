# Publications System Documentation

## Overview

Publications are the core entity in Beacon. Each publication is a writer's newsletter/blog with its own URL, posts, and subscribers.

## Features Implemented

### Publication Management ✅
- Create publication with title, description, and custom slug
- Auto-generate slug from title
- Real-time slug availability checking
- Update publication settings
- Delete publication (with confirmation)
- List user's publications on dashboard

### URL Structure ✅
- Publications live at `beacon.pub/{slug}`
- Slugs are permanent after creation
- Lowercase, alphanumeric, and hyphens only
- Minimum 3 characters

### Settings ✅
- Title and description
- Allow/disable comments
- Enable/disable welcome emails
- View publication URL

## File Structure

```
app/
├── composables/
│   └── usePublications.ts          # Publication CRUD operations
└── pages/
    ├── dashboard.vue                # Shows user's publications
    └── publications/
        ├── new.vue                  # Create new publication
        └── [id]/
            └── settings.vue         # Publication settings
```

## Database Schema

```sql
CREATE TABLE publications (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES profiles(id),
  title TEXT NOT NULL,
  description TEXT,
  slug TEXT UNIQUE NOT NULL,
  custom_domain TEXT UNIQUE,
  logo_url TEXT,
  cover_url TEXT,
  stripe_account_id TEXT,
  stripe_onboarding_complete BOOLEAN DEFAULT FALSE,
  allow_comments BOOLEAN DEFAULT TRUE,
  welcome_email_enabled BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

## Usage

### usePublications Composable

```typescript
const {
  getUserPublications,      // Get all user's publications
  getPublication,           // Get single publication by ID
  getPublicationBySlug,     // Get publication by slug
  checkSlugAvailability,    // Check if slug is available
  generateSlug,             // Generate slug from title
  createPublication,        // Create new publication
  updatePublication,        // Update publication
  deletePublication,        // Delete publication
} = usePublications()
```

### Creating a Publication

```typescript
const { createPublication, generateSlug } = usePublications()

const title = "My Newsletter"
const slug = generateSlug(title) // "my-newsletter"

const { data, error } = await createPublication({
  title,
  slug,
  description: "A newsletter about writing"
})
```

### Updating a Publication

```typescript
const { updatePublication } = usePublications()

const { data, error } = await updatePublication(publicationId, {
  title: "Updated Title",
  description: "New description",
  allow_comments: false
})
```

## Slug Generation

### Rules
- Converts to lowercase
- Removes special characters
- Replaces spaces with hyphens
- Removes multiple consecutive hyphens
- Maximum 50 characters
- Cannot start or end with hyphen

### Examples
```javascript
"My Amazing Newsletter" → "my-amazing-newsletter"
"Tech & Startups!" → "tech-startups"
"Writing... Daily" → "writing-daily"
"2024 Updates" → "2024-updates"
```

## Validation

### Client-Side
- Title: 3-100 characters, required
- Slug: 3+ characters, lowercase alphanumeric + hyphens, required
- Description: 0-500 characters, optional
- Slug format validation
- Real-time availability checking

### Server-Side
- Unique slug constraint
- User can only create publications for themselves
- Row Level Security policies enforce ownership

## Row Level Security

```sql
-- Users can view all publications
CREATE POLICY "Public publications viewable"
  ON publications FOR SELECT
  USING (true);

-- Users can create their own publications
CREATE POLICY "Users create own publications"
  ON publications FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own publications
CREATE POLICY "Users update own publications"
  ON publications FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own publications
CREATE POLICY "Users delete own publications"
  ON publications FOR DELETE
  USING (auth.uid() = user_id);
```

## User Experience

### Create Publication Flow
1. User clicks "Create Publication" from dashboard
2. Enters title (slug auto-generates)
3. Optionally edits slug
4. Slug availability checked in real-time
5. Enters description (optional)
6. Clicks "Create Publication"
7. Redirected to publication settings
8. Can start writing posts

### Dashboard Display
- Empty state if no publications
- List of publications with:
  - Title and description
  - URL (beacon.pub/{slug})
  - Creation date
  - Quick actions: New Post, Settings, View
- "New Publication" button

### Settings Page
- Basic information (title, description)
- Publication URL (read-only)
- Settings (comments, welcome email)
- Danger zone (delete publication)

## Accessibility

### Features
- Semantic HTML form elements
- Proper label associations
- ARIA attributes for validation
- Error announcements
- Loading states
- Focus management
- Keyboard navigation

### Form Validation
```html
<label for="slug" class="label-required">URL Slug</label>
<input
  id="slug"
  v-model="form.slug"
  type="text"
  class="input"
  aria-describedby="slug-hint slug-error"
  :aria-invalid="!!errors.slug"
  required
>
<span id="slug-hint" class="form-hint">...</span>
<span id="slug-error" class="form-error" role="alert">...</span>
```

## Security Considerations

### Slug Validation
- Prevents SQL injection
- Prevents XSS attacks
- Enforces consistent format
- Prevents collisions

### Ownership
- RLS ensures users only manage their own publications
- Server-side validation on all operations
- User ID from authenticated session

### Rate Limiting
- Should implement rate limiting on creation
- Prevent abuse/spam publications
- Supabase provides basic rate limiting

## Future Enhancements

### Branding
- [ ] Logo upload
- [ ] Cover image upload
- [ ] Custom colors/theme
- [ ] Font selection

### Custom Domains
- [ ] Connect custom domain
- [ ] SSL certificate setup
- [ ] Domain verification
- [ ] DNS configuration help

### SEO
- [ ] Meta tags configuration
- [ ] Social media preview
- [ ] Sitemap generation
- [ ] robots.txt

### Advanced Settings
- [ ] Language selection
- [ ] Timezone
- [ ] Date format
- [ ] Publication visibility (private/unlisted)

### Analytics
- [ ] Subscriber count
- [ ] Post count
- [ ] Total views
- [ ] Growth charts

### Collaboration
- [ ] Multiple authors
- [ ] Editor roles
- [ ] Contributor permissions

## Testing Checklist

### Creation
- [ ] Can create publication with valid data
- [ ] Slug auto-generates from title
- [ ] Slug availability checked
- [ ] Duplicate slug rejected
- [ ] Invalid slug format rejected
- [ ] Description is optional
- [ ] Redirects to settings after creation

### Update
- [ ] Can update title
- [ ] Can update description
- [ ] Can toggle settings
- [ ] Cannot update slug (immutable)
- [ ] Cannot update other user's publications
- [ ] Changes saved to database

### Delete
- [ ] Shows confirmation modal
- [ ] Can cancel deletion
- [ ] Successfully deletes publication
- [ ] Cascades to related data
- [ ] Redirects to dashboard
- [ ] Cannot delete other user's publications

### Display
- [ ] Dashboard shows empty state
- [ ] Dashboard lists publications
- [ ] Publication cards show correct info
- [ ] Links work correctly
- [ ] Publication count accurate

## Error Handling

### Common Errors

**"Slug already taken"**
- Another publication uses this slug
- Suggest alternative slugs

**"Invalid slug format"**
- Contains invalid characters
- Show format requirements

**"Publication not found"**
- ID doesn't exist
- User doesn't own publication
- Redirect to dashboard

**"Failed to create publication"**
- Database error
- Network error
- Show generic error message

## Performance

### Optimizations
- Debounce slug availability check (300ms)
- Client-side slug validation before API call
- Index on slug column for fast lookups
- Limit publications per user (future)

### Caching
- Cache publication list on dashboard
- Invalidate on creation/update/delete
- Use optimistic updates for better UX

---

Last Updated: February 10, 2026
