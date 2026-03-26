# Authentication System Documentation

## Overview

Beacon uses **Supabase Auth** for authentication, providing secure email/password authentication and magic link sign-in.

## Features Implemented

### Core Authentication ✅
- Email/password sign up
- Email/password sign in  
- Magic link authentication
- Email verification
- Password reset flow
- Session management
- Auth state persistence

### Security ✅
- Secure password hashing (handled by Supabase)
- Email verification required
- Session tokens auto-refresh
- HTTPS only (in production)
- Row Level Security (RLS) policies

### User Experience ✅
- Accessible forms (WCAG 2.2 AA)
- Clear error messages
- Loading states
- Success confirmations
- Redirect to intended page after login

## File Structure

```
app/
├── composables/
│   └── useAuth.ts              # Auth composable with all auth methods
├── middleware/
│   └── auth.ts                 # Route protection middleware
├── plugins/
│   └── auth.ts                 # Initialize auth state on app load
└── pages/
    ├── signup.vue              # Sign up page
    ├── login.vue               # Sign in page
    ├── dashboard.vue           # Protected dashboard (requires auth)
    ├── forgot-password.vue     # Password reset request
    └── auth/
        ├── callback.vue        # Email confirmation handler
        └── check-email.vue     # Email sent confirmation
```

## Usage

### useAuth Composable

The `useAuth()` composable provides all authentication functionality:

```typescript
const {
  user,               // Current user object (reactive)
  loading,            // Auth initialization loading state
  signUp,             // Create new account
  signIn,             // Sign in with email/password
  signInWithMagicLink, // Sign in with magic link
  signOut,            // Sign out
  resetPassword,      // Send password reset email
  updatePassword,     // Update user password
} = useAuth()
```

### Protecting Routes

Use the `auth` middleware to protect routes:

```vue
<script setup>
definePageMeta({
  middleware: 'auth'
})
</script>
```

Users not signed in will be redirected to `/login`.

### Checking Auth State

```vue
<script setup>
const { user, loading } = useAuth()
</script>

<template>
  <div v-if="loading">Loading...</div>
  <div v-else-if="user">
    Welcome, {{ user.email }}!
  </div>
  <div v-else>
    Please sign in
  </div>
</template>
```

## Sign Up Flow

1. User fills out sign up form (`/signup`)
2. Form validation (client-side)
3. Call `signUp(email, password, metadata)`
4. Supabase creates user account
5. Verification email sent
6. User redirected to `/auth/check-email`
7. User clicks email link
8. Redirected to `/auth/callback`
9. Auth state updated
10. Redirected to `/dashboard`

### Automatic Profile Creation

When a user signs up, a database trigger automatically creates their profile:

```sql
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

This creates a row in the `profiles` table with:
- ID (matches auth.users.id)
- Username (from metadata or generated from email)
- Display name (from metadata)
- Email

## Sign In Flow

### Email/Password

1. User enters credentials (`/login`)
2. Form validation
3. Call `signIn(email, password)`
4. Supabase validates credentials
5. Session created
6. Redirected to dashboard or intended page

### Magic Link

1. User enters email
2. Call `signInWithMagicLink(email)`
3. Supabase sends magic link email
4. User clicks link
5. Redirected to `/auth/callback`
6. Session created
7. Redirected to dashboard

## Password Reset Flow

1. User requests reset (`/forgot-password`)
2. Call `resetPassword(email)`
3. Supabase sends reset email
4. User clicks link (goes to `/auth/reset-password`)
5. User enters new password
6. Call `updatePassword(newPassword)`
7. Password updated
8. Redirected to dashboard

## Environment Variables Required

```env
NUXT_PUBLIC_SUPABASE_URL=your_supabase_url
NUXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Security Considerations

### Password Requirements
- Minimum 8 characters
- Validated client-side and server-side
- Hashed with bcrypt (by Supabase)

### Email Verification
- Required before full access
- Prevents spam accounts
- Validates email ownership

### Session Management
- Sessions stored in localStorage
- Auto-refresh before expiration
- Cleared on sign out

### Row Level Security
All database tables have RLS policies:

```sql
-- Users can only read their own profile
CREATE POLICY "Users can read own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

-- Users can only update their own profile
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);
```

## Form Validation

### Client-Side Validation
- Required fields
- Email format
- Password length
- Username format (lowercase, alphanumeric, hyphens, underscores)
- Real-time error messages

### Server-Side Validation
- Duplicate email check
- Duplicate username check
- Rate limiting (by Supabase)

## Error Handling

### Common Errors

**"User already registered"**
- Email already exists
- Redirect to login

**"Invalid login credentials"**
- Wrong email/password
- Clear, non-specific error (security)

**"Email not confirmed"**
- User hasn't clicked verification link
- Show link to resend email

**"Username already taken"**
- Choose different username
- Suggest alternatives

## Accessibility Features

### Semantic HTML
```html
<form novalidate>
  <label for="email" class="label-required">Email</label>
  <input
    id="email"
    type="email"
    aria-describedby="email-hint email-error"
    aria-invalid="true"
    required
  >
  <span id="email-hint" class="form-hint">...</span>
  <span id="email-error" class="form-error" role="alert">...</span>
</form>
```

### Features
- Proper label associations
- ARIA attributes
- Error announcements
- Loading state indicators
- Focus management
- Keyboard navigation

## Testing Checklist

### Sign Up
- [ ] Valid email/password creates account
- [ ] Duplicate email shows error
- [ ] Duplicate username shows error
- [ ] Email verification sent
- [ ] Profile created in database
- [ ] Invalid email format rejected
- [ ] Short password rejected
- [ ] Invalid username format rejected

### Sign In
- [ ] Valid credentials work
- [ ] Invalid credentials show error
- [ ] Unverified email blocked
- [ ] Redirect to intended page works
- [ ] Session persists on refresh

### Magic Link
- [ ] Email sent successfully
- [ ] Link works
- [ ] Session created
- [ ] Redirect works

### Password Reset
- [ ] Reset email sent
- [ ] Reset link works
- [ ] New password updates
- [ ] Can sign in with new password

### Security
- [ ] Protected routes require auth
- [ ] Can't access other users' data
- [ ] Sessions expire appropriately
- [ ] Sign out clears session

## Next Steps

### Planned Enhancements
- [ ] Social authentication (Google, Twitter)
- [ ] Two-factor authentication (2FA)
- [ ] Remember me checkbox
- [ ] Account deletion
- [ ] Email change with verification
- [ ] Session management (view all devices)
- [ ] Login history/audit log

### Future Improvements
- [ ] OAuth providers (GitHub, Google)
- [ ] Passwordless WebAuthn
- [ ] Biometric authentication
- [ ] IP-based rate limiting
- [ ] CAPTCHA for suspicious activity

## Troubleshooting

### "Session not found"
- Clear localStorage
- Sign in again
- Check environment variables

### "Invalid JWT"
- Session expired
- Sign in again
- Check server time sync

### Emails not sending
- Check Supabase email settings
- Verify email templates
- Check spam folder
- Verify domain configuration

### Profile not created
- Check database trigger
- Verify RLS policies
- Check Supabase logs

## Resources

- [Supabase Auth Docs](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Email Templates](https://supabase.com/docs/guides/auth/auth-email-templates)

---

Last Updated: February 10, 2026
