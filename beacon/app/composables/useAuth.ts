import { createClient } from '@supabase/supabase-js'
import type { Database } from '~/types/database'

export const useSupabaseClient = () => {
  const config = useRuntimeConfig()
  
  const supabase = createClient<Database>(
    config.public.supabaseUrl,
    config.public.supabaseAnonKey,
    {
      auth: {
        persistSession: true,
        autoRefreshToken: true,
        detectSessionInUrl: true,
      },
    }
  )

  return supabase
}

// Auth-specific composable
export const useAuth = () => {
  const supabase = useSupabaseClient()
  const user = useState('user', () => null)
  const loading = useState('auth-loading', () => true)

  // Initialize auth state
  const initAuth = async () => {
    const { data: { session } } = await supabase.auth.getSession()
    user.value = session?.user ?? null
    loading.value = false

    // Listen for auth changes
    supabase.auth.onAuthStateChange((_event, session) => {
      user.value = session?.user ?? null
    })
  }

  // Sign up with email and password
  const signUp = async (email: string, password: string, metadata?: {
    username?: string
    display_name?: string
  }) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: metadata,
        emailRedirectTo: `${window.location.origin}/auth/callback`,
      },
    })
    return { data, error }
  }

  // Sign in with email and password
  const signIn = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })
    return { data, error }
  }

  // Sign in with magic link
  const signInWithMagicLink = async (email: string) => {
    const { data, error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback`,
      },
    })
    return { data, error }
  }

  // Sign out
  const signOut = async () => {
    const { error } = await supabase.auth.signOut()
    if (!error) {
      user.value = null
      navigateTo('/')
    }
    return { error }
  }

  // Reset password
  const resetPassword = async (email: string) => {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/auth/reset-password`,
    })
    return { data, error }
  }

  // Update password
  const updatePassword = async (newPassword: string) => {
    const { data, error } = await supabase.auth.updateUser({
      password: newPassword,
    })
    return { data, error }
  }

  return {
    user,
    loading,
    initAuth,
    signUp,
    signIn,
    signInWithMagicLink,
    signOut,
    resetPassword,
    updatePassword,
  }
}
