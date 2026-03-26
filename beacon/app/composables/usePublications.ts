import type { Publication } from '~/types/database'

export const usePublications = () => {
  const supabase = useSupabaseClient()
  const { user } = useAuth()

  // Get user's publications
  const getUserPublications = async () => {
    if (!user.value) return { data: null, error: new Error('Not authenticated') }

    const { data, error } = await supabase
      .from('publications')
      .select('*')
      .eq('user_id', user.value.id)
      .order('created_at', { ascending: false })

    return { data, error }
  }

  // Get single publication by ID
  const getPublication = async (id: string) => {
    const { data, error } = await supabase
      .from('publications')
      .select('*')
      .eq('id', id)
      .single()

    return { data, error }
  }

  // Get publication by slug
  const getPublicationBySlug = async (slug: string) => {
    const { data, error } = await supabase
      .from('publications')
      .select('*')
      .eq('slug', slug)
      .single()

    return { data, error }
  }

  // Check if slug is available
  const checkSlugAvailability = async (slug: string, excludeId?: string) => {
    let query = supabase
      .from('publications')
      .select('id')
      .eq('slug', slug)

    if (excludeId) {
      query = query.neq('id', excludeId)
    }

    const { data, error } = await query

    if (error) return { available: false, error }
    return { available: data.length === 0, error: null }
  }

  // Generate slug from title
  const generateSlug = (title: string): string => {
    return title
      .toLowerCase()
      .trim()
      .replace(/[^\w\s-]/g, '') // Remove special characters
      .replace(/\s+/g, '-')      // Replace spaces with hyphens
      .replace(/-+/g, '-')       // Replace multiple hyphens with single
      .substring(0, 50)          // Limit length
  }

  // Create publication
  const createPublication = async (publication: {
    title: string
    description?: string
    slug: string
  }) => {
    if (!user.value) return { data: null, error: new Error('Not authenticated') }

    const { data, error } = await supabase
      .from('publications')
      .insert({
        user_id: user.value.id,
        title: publication.title,
        description: publication.description || null,
        slug: publication.slug,
      })
      .select()
      .single()

    return { data, error }
  }

  // Update publication
  const updatePublication = async (
    id: string,
    updates: Partial<Publication>
  ) => {
    if (!user.value) return { data: null, error: new Error('Not authenticated') }

    const { data, error } = await supabase
      .from('publications')
      .update(updates)
      .eq('id', id)
      .eq('user_id', user.value.id) // Security: only update own publications
      .select()
      .single()

    return { data, error }
  }

  // Delete publication
  const deletePublication = async (id: string) => {
    if (!user.value) return { error: new Error('Not authenticated') }

    const { error } = await supabase
      .from('publications')
      .delete()
      .eq('id', id)
      .eq('user_id', user.value.id) // Security: only delete own publications

    return { error }
  }

  return {
    getUserPublications,
    getPublication,
    getPublicationBySlug,
    checkSlugAvailability,
    generateSlug,
    createPublication,
    updatePublication,
    deletePublication,
  }
}
