import type { Post } from '~/types/database'

export const usePosts = () => {
  const supabase = useSupabaseClient()
  const { user } = useAuth()

  // Get posts for a publication
  const getPublicationPosts = async (publicationId: string, status?: 'draft' | 'published' | 'scheduled') => {
    let query = supabase
      .from('posts')
      .select('*')
      .eq('publication_id', publicationId)
      .order('created_at', { ascending: false })

    if (status) {
      query = query.eq('status', status)
    }

    const { data, error } = await query
    return { data, error }
  }

  // Get single post by ID
  const getPost = async (id: string) => {
    const { data, error } = await supabase
      .from('posts')
      .select('*')
      .eq('id', id)
      .single()

    return { data, error }
  }

  // Get post by slug within publication
  const getPostBySlug = async (publicationId: string, slug: string) => {
    const { data, error } = await supabase
      .from('posts')
      .select('*')
      .eq('publication_id', publicationId)
      .eq('slug', slug)
      .single()

    return { data, error }
  }

  // Check if slug is available for this publication
  const checkSlugAvailability = async (publicationId: string, slug: string, excludeId?: string) => {
    let query = supabase
      .from('posts')
      .select('id')
      .eq('publication_id', publicationId)
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
      .replace(/[^\w\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-')
      .substring(0, 100)
  }

  // Generate excerpt from content
  const generateExcerpt = (content: string, maxLength: number = 200): string => {
    // Remove HTML tags
    const text = content.replace(/<[^>]*>/g, '')
    
    if (text.length <= maxLength) {
      return text
    }

    return text.substring(0, maxLength).trim() + '...'
  }

  // Create post
  const createPost = async (publicationId: string, post: {
    title: string
    slug: string
    subtitle?: string
    content: string
    excerpt?: string
    cover_image_url?: string
    status?: 'draft' | 'published' | 'scheduled'
    visibility?: 'free' | 'subscribers' | 'paid'
    published_at?: string
    scheduled_for?: string
    send_email?: boolean
    meta_title?: string
    meta_description?: string
  }) => {
    const { data, error } = await supabase
      .from('posts')
      .insert({
        publication_id: publicationId,
        title: post.title,
        slug: post.slug,
        subtitle: post.subtitle || null,
        content: post.content,
        excerpt: post.excerpt || generateExcerpt(post.content),
        cover_image_url: post.cover_image_url || null,
        status: post.status || 'draft',
        visibility: post.visibility || 'free',
        published_at: post.published_at || null,
        scheduled_for: post.scheduled_for || null,
        send_email: post.send_email !== undefined ? post.send_email : true,
        meta_title: post.meta_title || null,
        meta_description: post.meta_description || null,
      })
      .select()
      .single()

    return { data, error }
  }

  // Update post
  const updatePost = async (id: string, updates: Partial<Post>) => {
    const { data, error } = await supabase
      .from('posts')
      .update(updates)
      .eq('id', id)
      .select()
      .single()

    return { data, error }
  }

  // Publish post
  const publishPost = async (id: string, sendEmail: boolean = true) => {
    const { data, error } = await supabase
      .from('posts')
      .update({
        status: 'published',
        published_at: new Date().toISOString(),
        send_email: sendEmail,
      })
      .eq('id', id)
      .select()
      .single()

    return { data, error }
  }

  // Unpublish post (revert to draft)
  const unpublishPost = async (id: string) => {
    const { data, error } = await supabase
      .from('posts')
      .update({
        status: 'draft',
        published_at: null,
      })
      .eq('id', id)
      .select()
      .single()

    return { data, error }
  }

  // Delete post
  const deletePost = async (id: string) => {
    const { error } = await supabase
      .from('posts')
      .delete()
      .eq('id', id)

    return { error }
  }

  return {
    getPublicationPosts,
    getPost,
    getPostBySlug,
    checkSlugAvailability,
    generateSlug,
    generateExcerpt,
    createPost,
    updatePost,
    publishPost,
    unpublishPost,
    deletePost,
  }
}
