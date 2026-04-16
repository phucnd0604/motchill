package com.motchill.androidcompose.core.supabase

import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.auth.Auth
import io.github.jan.supabase.createSupabaseClient
import io.github.jan.supabase.postgrest.Postgrest

fun createSupabaseClient(config: SupabaseConfig): SupabaseClient =
    createSupabaseClient(config.url, config.publishableKey) {
        install(Auth)
        install(Postgrest)
    }
