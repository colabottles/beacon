// Database types generated from Supabase schema

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          username: string
          display_name: string
          bio: string | null
          avatar_url: string | null
          website_url: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          username: string
          display_name: string
          bio?: string | null
          avatar_url?: string | null
          website_url?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          username?: string
          display_name?: string
          bio?: string | null
          avatar_url?: string | null
          website_url?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      publications: {
        Row: {
          id: string
          user_id: string
          title: string
          description: string | null
          slug: string
          custom_domain: string | null
          logo_url: string | null
          cover_url: string | null
          stripe_account_id: string | null
          stripe_onboarding_complete: boolean
          allow_comments: boolean
          welcome_email_enabled: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          title: string
          description?: string | null
          slug: string
          custom_domain?: string | null
          logo_url?: string | null
          cover_url?: string | null
          stripe_account_id?: string | null
          stripe_onboarding_complete?: boolean
          allow_comments?: boolean
          welcome_email_enabled?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string
          description?: string | null
          slug?: string
          custom_domain?: string | null
          logo_url?: string | null
          cover_url?: string | null
          stripe_account_id?: string | null
          stripe_onboarding_complete?: boolean
          allow_comments?: boolean
          welcome_email_enabled?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      tiers: {
        Row: {
          id: string
          publication_id: string
          name: string
          description: string | null
          price_cents: number
          interval: 'month' | 'year'
          stripe_price_id: string | null
          is_free: boolean
          benefits: string[]
          display_order: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          publication_id: string
          name: string
          description?: string | null
          price_cents?: number
          interval?: 'month' | 'year'
          stripe_price_id?: string | null
          is_free?: boolean
          benefits?: string[]
          display_order?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          publication_id?: string
          name?: string
          description?: string | null
          price_cents?: number
          interval?: 'month' | 'year'
          stripe_price_id?: string | null
          is_free?: boolean
          benefits?: string[]
          display_order?: number
          created_at?: string
          updated_at?: string
        }
      }
      posts: {
        Row: {
          id: string
          publication_id: string
          title: string
          slug: string
          subtitle: string | null
          content: string
          excerpt: string | null
          cover_image_url: string | null
          status: 'draft' | 'scheduled' | 'published'
          visibility: 'free' | 'subscribers' | 'paid'
          published_at: string | null
          scheduled_for: string | null
          send_email: boolean
          email_sent_at: string | null
          meta_title: string | null
          meta_description: string | null
          view_count: number
          like_count: number
          comment_count: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          publication_id: string
          title: string
          slug: string
          subtitle?: string | null
          content: string
          excerpt?: string | null
          cover_image_url?: string | null
          status?: 'draft' | 'scheduled' | 'published'
          visibility?: 'free' | 'subscribers' | 'paid'
          published_at?: string | null
          scheduled_for?: string | null
          send_email?: boolean
          email_sent_at?: string | null
          meta_title?: string | null
          meta_description?: string | null
          view_count?: number
          like_count?: number
          comment_count?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          publication_id?: string
          title?: string
          slug?: string
          subtitle?: string | null
          content?: string
          excerpt?: string | null
          cover_image_url?: string | null
          status?: 'draft' | 'scheduled' | 'published'
          visibility?: 'free' | 'subscribers' | 'paid'
          published_at?: string | null
          scheduled_for?: string | null
          send_email?: boolean
          email_sent_at?: string | null
          meta_title?: string | null
          meta_description?: string | null
          view_count?: number
          like_count?: number
          comment_count?: number
          created_at?: string
          updated_at?: string
        }
      }
      subscriptions: {
        Row: {
          id: string
          publication_id: string
          user_id: string | null
          email: string
          tier_id: string | null
          status: 'active' | 'canceled' | 'expired' | 'past_due'
          stripe_subscription_id: string | null
          stripe_customer_id: string | null
          started_at: string
          ends_at: string | null
          canceled_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          publication_id: string
          user_id?: string | null
          email: string
          tier_id?: string | null
          status?: 'active' | 'canceled' | 'expired' | 'past_due'
          stripe_subscription_id?: string | null
          stripe_customer_id?: string | null
          started_at?: string
          ends_at?: string | null
          canceled_at?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          publication_id?: string
          user_id?: string | null
          email?: string
          tier_id?: string | null
          status?: 'active' | 'canceled' | 'expired' | 'past_due'
          stripe_subscription_id?: string | null
          stripe_customer_id?: string | null
          started_at?: string
          ends_at?: string | null
          canceled_at?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      comments: {
        Row: {
          id: string
          post_id: string
          user_id: string | null
          content: string
          parent_id: string | null
          is_deleted: boolean
          deleted_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          post_id: string
          user_id?: string | null
          content: string
          parent_id?: string | null
          is_deleted?: boolean
          deleted_at?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          post_id?: string
          user_id?: string | null
          content?: string
          parent_id?: string | null
          is_deleted?: boolean
          deleted_at?: string | null
          created_at?: string
          updated_at?: string
        }
      }
    }
  }
}

export type Profile = Database['public']['Tables']['profiles']['Row']
export type Publication = Database['public']['Tables']['publications']['Row']
export type Tier = Database['public']['Tables']['tiers']['Row']
export type Post = Database['public']['Tables']['posts']['Row']
export type Subscription = Database['public']['Tables']['subscriptions']['Row']
export type Comment = Database['public']['Tables']['comments']['Row']
