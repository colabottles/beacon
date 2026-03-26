-- Row Level Security Policies
-- Enable RLS on all tables

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.publications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_sends ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_views ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone"
  ON public.profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can insert their own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Publications policies
CREATE POLICY "Public publications are viewable by everyone"
  ON public.publications FOR SELECT
  USING (true);

CREATE POLICY "Users can create their own publications"
  ON public.publications FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own publications"
  ON public.publications FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own publications"
  ON public.publications FOR DELETE
  USING (auth.uid() = user_id);

-- Tiers policies
CREATE POLICY "Public tiers are viewable by everyone"
  ON public.tiers FOR SELECT
  USING (true);

CREATE POLICY "Publication owners can manage tiers"
  ON public.tiers FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.publications
      WHERE id = tiers.publication_id
      AND user_id = auth.uid()
    )
  );

-- Posts policies
CREATE POLICY "Published free posts are viewable by everyone"
  ON public.posts FOR SELECT
  USING (
    status = 'published' AND visibility = 'free'
  );

CREATE POLICY "Published subscriber posts viewable by subscribers"
  ON public.posts FOR SELECT
  USING (
    status = 'published' AND
    (
      visibility = 'free' OR
      EXISTS (
        SELECT 1 FROM public.subscriptions
        WHERE publication_id = posts.publication_id
        AND (user_id = auth.uid() OR email = auth.email())
        AND status = 'active'
      )
    )
  );

CREATE POLICY "Publication owners can view all their posts"
  ON public.posts FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.publications
      WHERE id = posts.publication_id
      AND user_id = auth.uid()
    )
  );

CREATE POLICY "Publication owners can manage posts"
  ON public.posts FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.publications
      WHERE id = posts.publication_id
      AND user_id = auth.uid()
    )
  );

-- Subscriptions policies
CREATE POLICY "Users can view their own subscriptions"
  ON public.subscriptions FOR SELECT
  USING (
    auth.uid() = user_id OR
    auth.email() = email
  );

CREATE POLICY "Publication owners can view their subscriptions"
  ON public.subscriptions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.publications
      WHERE id = subscriptions.publication_id
      AND user_id = auth.uid()
    )
  );

CREATE POLICY "Anyone can create a subscription"
  ON public.subscriptions FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can update their own subscriptions"
  ON public.subscriptions FOR UPDATE
  USING (
    auth.uid() = user_id OR
    auth.email() = email
  );

-- Email sends policies (publication owners only)
CREATE POLICY "Publication owners can view email sends"
  ON public.email_sends FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.publications
      WHERE id = email_sends.publication_id
      AND user_id = auth.uid()
    )
  );

CREATE POLICY "Publication owners can create email sends"
  ON public.email_sends FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.publications
      WHERE id = email_sends.publication_id
      AND user_id = auth.uid()
    )
  );

-- Comments policies
CREATE POLICY "Comments viewable for published posts"
  ON public.comments FOR SELECT
  USING (
    NOT is_deleted AND
    EXISTS (
      SELECT 1 FROM public.posts
      WHERE id = comments.post_id
      AND status = 'published'
    )
  );

CREATE POLICY "Authenticated users can create comments"
  ON public.comments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own comments"
  ON public.comments FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own comments"
  ON public.comments FOR DELETE
  USING (auth.uid() = user_id);

CREATE POLICY "Publication owners can moderate comments"
  ON public.comments FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.posts p
      JOIN public.publications pub ON pub.id = p.publication_id
      WHERE p.id = comments.post_id
      AND pub.user_id = auth.uid()
    )
  );

-- Likes policies
CREATE POLICY "Likes viewable for published posts"
  ON public.likes FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.posts
      WHERE id = likes.post_id
      AND status = 'published'
    )
  );

CREATE POLICY "Authenticated users can like posts"
  ON public.likes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike posts"
  ON public.likes FOR DELETE
  USING (auth.uid() = user_id);

-- Reports policies
CREATE POLICY "Users can create reports"
  ON public.reports FOR INSERT
  WITH CHECK (
    auth.uid() = reporter_id OR
    (auth.uid() IS NULL AND reporter_email IS NOT NULL)
  );

CREATE POLICY "Platform moderators can view all reports"
  ON public.reports FOR SELECT
  USING (
    -- This will be updated when we add moderator roles
    auth.uid() IS NOT NULL
  );

-- Post views policies (analytics)
CREATE POLICY "Anyone can create post views"
  ON public.post_views FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Publication owners can view analytics"
  ON public.post_views FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.posts p
      JOIN public.publications pub ON pub.id = p.publication_id
      WHERE p.id = post_views.post_id
      AND pub.user_id = auth.uid()
    )
  );

-- Function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, display_name, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', SPLIT_PART(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'display_name', SPLIT_PART(NEW.email, '@', 1)),
    NEW.email
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
