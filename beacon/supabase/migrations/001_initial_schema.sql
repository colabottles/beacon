-- Beacon Platform Database Schema
-- Initial migration

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  bio TEXT,
  avatar_url TEXT,
  website_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  CONSTRAINT username_length CHECK (char_length(username) >= 3 AND char_length(username) <= 30),
  CONSTRAINT username_format CHECK (username ~* '^[a-z0-9_-]+$')
);

-- Publications table
CREATE TABLE public.publications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  slug TEXT UNIQUE NOT NULL,
  custom_domain TEXT UNIQUE,
  logo_url TEXT,
  cover_url TEXT,
  
  -- Stripe integration
  stripe_account_id TEXT UNIQUE,
  stripe_onboarding_complete BOOLEAN DEFAULT FALSE,
  
  -- Settings
  allow_comments BOOLEAN DEFAULT TRUE,
  welcome_email_enabled BOOLEAN DEFAULT TRUE,
  
  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  CONSTRAINT slug_format CHECK (slug ~* '^[a-z0-9_-]+$')
);

-- Create index on user_id for faster lookups
CREATE INDEX idx_publications_user_id ON public.publications(user_id);

-- Subscription tiers table
CREATE TABLE public.tiers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  publication_id UUID NOT NULL REFERENCES public.publications(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price_cents INTEGER NOT NULL DEFAULT 0,
  interval TEXT NOT NULL DEFAULT 'month', -- month, year
  stripe_price_id TEXT UNIQUE,
  
  -- Features
  is_free BOOLEAN DEFAULT FALSE,
  benefits JSONB DEFAULT '[]'::jsonb,
  
  -- Ordering
  display_order INTEGER DEFAULT 0,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  CONSTRAINT price_positive CHECK (price_cents >= 0),
  CONSTRAINT interval_valid CHECK (interval IN ('month', 'year'))
);

CREATE INDEX idx_tiers_publication_id ON public.tiers(publication_id);

-- Posts table
CREATE TABLE public.posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  publication_id UUID NOT NULL REFERENCES public.publications(id) ON DELETE CASCADE,
  
  -- Content
  title TEXT NOT NULL,
  slug TEXT NOT NULL,
  subtitle TEXT,
  content TEXT NOT NULL,
  excerpt TEXT,
  cover_image_url TEXT,
  
  -- Publishing
  status TEXT NOT NULL DEFAULT 'draft', -- draft, scheduled, published
  visibility TEXT NOT NULL DEFAULT 'free', -- free, subscribers, paid
  published_at TIMESTAMPTZ,
  scheduled_for TIMESTAMPTZ,
  
  -- Email
  send_email BOOLEAN DEFAULT TRUE,
  email_sent_at TIMESTAMPTZ,
  
  -- SEO
  meta_title TEXT,
  meta_description TEXT,
  
  -- Stats
  view_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  
  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  CONSTRAINT status_valid CHECK (status IN ('draft', 'scheduled', 'published')),
  CONSTRAINT visibility_valid CHECK (visibility IN ('free', 'subscribers', 'paid')),
  UNIQUE(publication_id, slug)
);

CREATE INDEX idx_posts_publication_id ON public.posts(publication_id);
CREATE INDEX idx_posts_published_at ON public.posts(published_at DESC) WHERE status = 'published';
CREATE INDEX idx_posts_status ON public.posts(status);

-- Subscriptions table
CREATE TABLE public.subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  publication_id UUID NOT NULL REFERENCES public.publications(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  
  -- Subscriber info (for non-registered users)
  email TEXT NOT NULL,
  
  -- Subscription details
  tier_id UUID REFERENCES public.tiers(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'active', -- active, canceled, expired, past_due
  
  -- Stripe integration
  stripe_subscription_id TEXT UNIQUE,
  stripe_customer_id TEXT,
  
  -- Dates
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ends_at TIMESTAMPTZ,
  canceled_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  CONSTRAINT status_valid CHECK (status IN ('active', 'canceled', 'expired', 'past_due')),
  CONSTRAINT email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE INDEX idx_subscriptions_publication_id ON public.subscriptions(publication_id);
CREATE INDEX idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX idx_subscriptions_email ON public.subscriptions(email);
CREATE UNIQUE INDEX idx_subscriptions_unique ON public.subscriptions(publication_id, email) WHERE status = 'active';

-- Email sends tracking
CREATE TABLE public.email_sends (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
  publication_id UUID NOT NULL REFERENCES public.publications(id) ON DELETE CASCADE,
  
  -- Stats
  recipient_count INTEGER NOT NULL DEFAULT 0,
  delivered_count INTEGER DEFAULT 0,
  opened_count INTEGER DEFAULT 0,
  clicked_count INTEGER DEFAULT 0,
  bounced_count INTEGER DEFAULT 0,
  complained_count INTEGER DEFAULT 0,
  
  sent_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_email_sends_post_id ON public.email_sends(post_id);
CREATE INDEX idx_email_sends_publication_id ON public.email_sends(publication_id);

-- Comments table
CREATE TABLE public.comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  
  -- Comment details
  content TEXT NOT NULL,
  parent_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
  
  -- Moderation
  is_deleted BOOLEAN DEFAULT FALSE,
  deleted_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_comments_post_id ON public.comments(post_id);
CREATE INDEX idx_comments_user_id ON public.comments(user_id);
CREATE INDEX idx_comments_parent_id ON public.comments(parent_id);

-- Likes table
CREATE TABLE public.likes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(post_id, user_id)
);

CREATE INDEX idx_likes_post_id ON public.likes(post_id);
CREATE INDEX idx_likes_user_id ON public.likes(user_id);

-- Content reports/moderation
CREATE TABLE public.reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  
  -- What's being reported
  content_type TEXT NOT NULL, -- post, comment, publication, profile
  content_id UUID NOT NULL,
  
  -- Reporter
  reporter_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  reporter_email TEXT,
  
  -- Report details
  reason TEXT NOT NULL, -- hate_speech, harassment, spam, misinformation, other
  description TEXT,
  
  -- Moderation
  status TEXT NOT NULL DEFAULT 'pending', -- pending, reviewing, resolved, dismissed
  reviewed_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  moderator_notes TEXT,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  CONSTRAINT content_type_valid CHECK (content_type IN ('post', 'comment', 'publication', 'profile')),
  CONSTRAINT reason_valid CHECK (reason IN ('hate_speech', 'harassment', 'spam', 'misinformation', 'other')),
  CONSTRAINT status_valid CHECK (status IN ('pending', 'reviewing', 'resolved', 'dismissed'))
);

CREATE INDEX idx_reports_content ON public.reports(content_type, content_id);
CREATE INDEX idx_reports_status ON public.reports(status);

-- Platform analytics
CREATE TABLE public.post_views (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  
  -- Analytics
  referrer TEXT,
  user_agent TEXT,
  ip_address INET,
  
  viewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_post_views_post_id ON public.post_views(post_id);
CREATE INDEX idx_post_views_viewed_at ON public.post_views(viewed_at DESC);

-- Functions for updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_publications_updated_at BEFORE UPDATE ON public.publications
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tiers_updated_at BEFORE UPDATE ON public.tiers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON public.posts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON public.comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) policies will be added in next migration
