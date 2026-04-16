package com.motchill.androidcompose.core.supabase

data class SupabaseConfig(
    val url: String,
    val publishableKey: String
) {
    val isConfigured: Boolean
        get() = url.isNotBlank() && publishableKey.isNotBlank()
    
    val baseUrl: String get() = url
    val anonKey: String get() = publishableKey
}
