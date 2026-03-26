# Email Subscriptions System Documentation

## Overview

The email subscription system allows readers to subscribe to publications and receive new posts in their inbox. Writers can manage their subscriber list and track growth.

## Features Implemented

### Subscription Management ✅
- Free email subscriptions
- Subscribe from publication homepage
- Subscribe from post page
- Check existing subscriptions (prevent duplicates)
- Get subscriber count
- List all subscribers
- Export subscribers to CSV

### Subscriber Dashboard ✅
- View total subscribers
- See free vs paid breakdown
- Track 30-day growth
- Export subscriber list
- View subscription dates

### Data Model ✅
- Subscriptions table with RLS
- Email validation
- Status tracking (active/canceled)
- Tier support (free/paid)

## File Structure

```
app/
├── composables/
│   └── useSubscriptions.ts           # Subscription CRUD operations
└── pages/
    └── publications/
        └── [id]/
            └── subscribers.vue        # Subscriber management dashboard
```

## Database Schema

```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY,
  publication_id UUID NOT NULL REFERENCES publications(id),
  user_id UUID REFERENCES profiles(id),
  tier_id UUID REFERENCES tiers(id),
  email TEXT NOT NULL,
  status TEXT DEFAULT 'active', -- active, canceled
  stripe_subscription_id TEXT,
  stripe_customer_id TEXT,
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  canceled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(publication_id, email)
);

CREATE INDEX idx_subscriptions_publication ON subscriptions(publication_id);
CREATE INDEX idx_subscriptions_email ON subscriptions(email);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
```

## Usage

### useSubscriptions Composable

```typescript
const {
  createSubscription,           // Create free subscription
  checkSubscription,            // Check if email subscribed
  getPublicationSubscriptions,  // Get all subscribers (writers)
  getSubscriberCount,           // Get active subscriber count
  unsubscribe,                  // Cancel subscription
  getUserSubscriptions,         // Get user's subscriptions
} = useSubscriptions()
```

### Creating a Subscription

```typescript
const { createSubscription } = useSubscriptions()

const { data, error } = await createSubscription(
  publicationId,
  'user@example.com',
  userId // optional - null for non-authenticated
)
```

### Checking Subscription Status

```typescript
const { checkSubscription } = useSubscriptions()

const { isSubscribed } = await checkSubscription(
  publicationId,
  'user@example.com'
)

if (isSubscribed) {
  // Already subscribed
}
```

### Getting Subscriber Count

```typescript
const { getSubscriberCount } = useSubscriptions()

const { count } = await getSubscriberCount(publicationId)
// count = number of active subscribers
```

## Subscription Flow

### Reader Journey
1. Visits publication or post
2. Clicks "Subscribe" button
3. Modal opens with email form
4. Enters email address
5. Submits form
6. System checks for duplicates
7. Creates subscription record
8. Shows success message
9. TODO: Sends confirmation email

### Writer Journey
1. Publishes post
2. System queues email to all active subscribers
3. TODO: Email sent via Resend/Postmark
4. TODO: Tracks open rates
5. Writer views stats on subscribers page

## Subscribe Modal

Shared component used on:
- Publication homepage
- Post pages

### Features
- Email validation
- Duplicate checking
- Loading states
- Error messages
- Success feedback
- Accessible (ARIA, keyboard)

### Implementation
```typescript
const handleSubscribe = async () => {
  // Validate email
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return
  }

  // Check for duplicates
  const { isSubscribed } = await checkSubscription(pubId, email)
  if (isSubscribed) {
    showError('Already subscribed')
    return
  }

  // Create subscription
  const { data, error } = await createSubscription(pubId, email)
  
  // Show success
  // TODO: Send confirmation email
}
```

## Subscriber Dashboard

Available at: `/publications/:id/subscribers`

### Stats Cards
- **Total Subscribers** - All active subscribers
- **Free Subscribers** - Active without tier
- **Paid Subscribers** - Active with tier (future)
- **30-Day Growth** - New subscribers in last 30 days

### Subscribers Table
Columns:
- Email
- Status (active/canceled)
- Type (free/paid)
- Subscribed date

### Export CSV
Writers can export subscriber list as CSV:
```csv
Email,Status,Type,Subscribed
user@example.com,active,Free,Jan 15, 2026
```

## Row Level Security

```sql
-- Anyone can create subscriptions
CREATE POLICY "Anyone can subscribe"
  ON subscriptions FOR INSERT
  WITH CHECK (true);

-- Only publication owners can view subscribers
CREATE POLICY "Owners view subscribers"
  ON subscriptions FOR SELECT
  USING (
    publication_id IN (
      SELECT id FROM publications WHERE user_id = auth.uid()
    )
  );

-- Users can view their own subscriptions
CREATE POLICY "Users view own subscriptions"
  ON subscriptions FOR SELECT
  USING (user_id = auth.uid());
```

## Email Validation

### Client-Side
```typescript
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

if (!emailRegex.test(email)) {
  error = 'Please enter a valid email address'
}
```

### Server-Side
- Email format validation (Supabase)
- Lowercase normalization
- Trim whitespace
- Unique constraint per publication

## Duplicate Prevention

Before creating subscription:
```typescript
const { isSubscribed } = await checkSubscription(
  publicationId,
  email
)

if (isSubscribed) {
  return { error: 'Already subscribed' }
}
```

Database constraint:
```sql
UNIQUE(publication_id, email)
```

## Future: Email Delivery

### Architecture
```
1. Post published with send_email=true
2. Create email_sends record
3. Queue job for each active subscriber
4. Send via Resend/Postmark
5. Track delivery status
6. Track opens/clicks
```

### Email Service Options

**Resend** (Recommended)
- Modern API
- Great deliverability
- Beautiful templates
- Generous free tier (3,000/month)
- Easy integration

**Postmark** 
- Excellent deliverability
- Transaction + marketing emails
- Detailed analytics
- Free tier (100/month)

**AWS SES**
- Very cheap ($0.10/1,000)
- Requires warming up
- More complex setup
- Good for scale

### Email Template Structure
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>{{ post.title }}</title>
</head>
<body>
  <div style="max-width: 600px; margin: 0 auto;">
    <h1>{{ publication.title }}</h1>
    <h2>{{ post.title }}</h2>
    <p>{{ post.subtitle }}</p>
    <div>{{ post.content }}</div>
    <a href="{{ postUrl }}">Read online</a>
    <a href="{{ unsubscribeUrl }}">Unsubscribe</a>
  </div>
</body>
</html>
```

## Unsubscribe Flow

### One-Click Unsubscribe
```
GET /unsubscribe/:subscriptionId/:token
→ Verify token
→ Update status to 'canceled'
→ Show confirmation page
```

### Token Generation
```typescript
const token = crypto
  .createHash('sha256')
  .update(subscriptionId + secret)
  .digest('hex')
```

## Analytics (Future)

### Track Per Publication
- Total subscribers
- Free vs paid split
- Growth over time (daily/weekly/monthly)
- Churn rate
- Subscriber LTV

### Track Per Email
- Delivery status
- Open rate
- Click rate
- Device/client
- Timestamp

### Database Schema (Future)
```sql
CREATE TABLE email_sends (
  id UUID PRIMARY KEY,
  post_id UUID REFERENCES posts(id),
  subscription_id UUID REFERENCES subscriptions(id),
  status TEXT, -- queued, sent, delivered, opened, clicked, failed
  sent_at TIMESTAMPTZ,
  opened_at TIMESTAMPTZ,
  clicked_at TIMESTAMPTZ
);
```

## Integration with Resend

### Setup
```bash
pnpm add resend
```

### Configuration
```env
RESEND_API_KEY=re_xxxxx
RESEND_FROM_EMAIL=newsletter@beacon.pub
```

### Send Email
```typescript
import { Resend } from 'resend'

const resend = new Resend(process.env.RESEND_API_KEY)

await resend.emails.send({
  from: 'newsletter@beacon.pub',
  to: subscriber.email,
  subject: post.title,
  html: emailTemplate,
  headers: {
    'List-Unsubscribe': unsubscribeUrl
  }
})
```

### Webhook Handler
```typescript
// pages/api/webhooks/resend.ts
export default defineEventHandler(async (event) => {
  const payload = await readBody(event)
  
  switch (payload.type) {
    case 'email.delivered':
      // Update email_sends status
      break
    case 'email.opened':
      // Track open
      break
    case 'email.clicked':
      // Track click
      break
  }
})
```

## Testing Checklist

### Subscription Creation
- [ ] Can subscribe with valid email
- [ ] Validates email format
- [ ] Prevents duplicate subscriptions
- [ ] Handles database errors
- [ ] Shows success message
- [ ] Updates subscriber count
- [ ] Modal closes after success

### Subscriber Dashboard
- [ ] Shows correct total count
- [ ] Shows free/paid breakdown
- [ ] Calculates growth correctly
- [ ] Lists all subscribers
- [ ] Shows correct dates
- [ ] Export CSV works
- [ ] Only accessible to publication owner

### Unsubscribe (Future)
- [ ] One-click unsubscribe works
- [ ] Updates status to canceled
- [ ] Shows confirmation page
- [ ] Removes from email list

### Email Delivery (Future)
- [ ] Emails sent on publish
- [ ] Respects send_email flag
- [ ] Uses correct template
- [ ] Tracks delivery status
- [ ] Tracks opens/clicks
- [ ] Unsubscribe link works

## Performance Considerations

### Database Indexes
```sql
CREATE INDEX idx_subscriptions_publication ON subscriptions(publication_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_created ON subscriptions(created_at);
```

### Query Optimization
```typescript
// Get active subscribers efficiently
const { data } = await supabase
  .from('subscriptions')
  .select('email')
  .eq('publication_id', pubId)
  .eq('status', 'active')
```

### Email Sending
- Queue emails for batch processing
- Rate limit to avoid spam filters
- Use background jobs (not inline)
- Monitor bounce rates

## Security

### Email Privacy
- Never expose subscriber emails publicly
- Only publication owner can see list
- RLS enforces access control

### Spam Prevention
- Rate limit subscription endpoint
- Require email confirmation (future)
- Block disposable email domains (future)
- Implement CAPTCHA for suspicious activity (future)

### Unsubscribe Security
- Generate secure tokens
- Expire tokens after use
- Verify token before unsubscribe

## Compliance

### CAN-SPAM Act
- [ ] Include physical address in emails
- [ ] Provide one-click unsubscribe
- [ ] Honor unsubscribe within 10 days
- [ ] Don't use deceptive subject lines

### GDPR
- [ ] Get consent before sending
- [ ] Allow data export
- [ ] Allow data deletion
- [ ] Maintain unsubscribe list

### Double Opt-In (Recommended)
1. User enters email
2. Send confirmation email
3. User clicks confirmation link
4. Subscription activated
5. Send welcome email

## Metrics to Track

### Growth Metrics
- New subscribers per day/week/month
- Unsubscribe rate
- Net subscriber growth
- Growth rate percentage

### Engagement Metrics
- Open rate (industry avg: 20-25%)
- Click rate (industry avg: 2-5%)
- Read time
- Device breakdown

### Revenue Metrics (Future)
- Free to paid conversion
- Subscriber LTV
- Churn rate
- MRR growth

## Future Enhancements

### Email Features
- [ ] Confirmation emails
- [ ] Welcome emails
- [ ] Drip campaigns
- [ ] Automated sequences
- [ ] A/B testing subject lines
- [ ] Personalization tokens

### Subscriber Management
- [ ] Segmentation (tags, groups)
- [ ] Bulk operations
- [ ] Import subscribers
- [ ] Subscriber notes
- [ ] Custom fields

### Analytics
- [ ] Email heatmaps
- [ ] Link tracking
- [ ] Subscriber journey
- [ ] Cohort analysis
- [ ] Predictive churn

---

Last Updated: February 10, 2026
