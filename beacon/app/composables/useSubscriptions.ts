import type { Subscription } from '~/types/database'

export const useSubscriptions = () => {
  const supabase = useSupabaseClient()
  const { user } = useAuth()

  // Create a free subscription (email signup)
  const createSubscription = async (
    publicationId: string,
    email: string,
    userId?: string
  ) => {
    const { data, error } = await supabase
      .from('subscriptions')
      .insert({
        publication_id: publicationId,
        user_id: userId || null,
        email: email.toLowerCase().trim(),
        status: 'active',
        tier_id: null, // null = free subscription
      })
      .select()
      .single()

    return { data, error }
  }

  // Check if email is subscribed to publication
  const checkSubscription = async (publicationId: string, email: string) => {
    const { data, error } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('publication_id', publicationId)
      .eq('email', email.toLowerCase().trim())
      .eq('status', 'active')
      .single()

    return { data, error, isSubscribed: !!data }
  }

  // Get all subscriptions for a publication (for writers)
  const getPublicationSubscriptions = async (publicationId: string) => {
    const { data, error } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('publication_id', publicationId)
      .order('created_at', { ascending: false })

    return { data, error }
  }

  // Get subscriber count for a publication
  const getSubscriberCount = async (publicationId: string) => {
    const { count, error } = await supabase
      .from('subscriptions')
      .select('*', { count: 'exact', head: true })
      .eq('publication_id', publicationId)
      .eq('status', 'active')

    return { count: count || 0, error }
  }

  // Unsubscribe
  const unsubscribe = async (subscriptionId: string) => {
    const { data, error } = await supabase
      .from('subscriptions')
      .update({
        status: 'canceled',
        canceled_at: new Date().toISOString(),
      })
      .eq('id', subscriptionId)
      .select()
      .single()

    return { data, error }
  }

  // Get user's subscriptions
  const getUserSubscriptions = async () => {
    if (!user.value) return { data: null, error: new Error('Not authenticated') }

    const { data, error } = await supabase
      .from('subscriptions')
      .select(`
        *,
        publications:publication_id (
          id,
          title,
          slug,
          description
        )
      `)
      .eq('user_id', user.value.id)
      .eq('status', 'active')
      .order('created_at', { ascending: false })

    return { data, error }
  }

  return {
    createSubscription,
    checkSubscription,
    getPublicationSubscriptions,
    getSubscriberCount,
    unsubscribe,
    getUserSubscriptions,
  }
}
