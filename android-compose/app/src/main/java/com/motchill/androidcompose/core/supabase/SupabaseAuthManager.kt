package com.motchill.androidcompose.core.supabase
import io.github.jan.supabase.auth.auth
import io.github.jan.supabase.auth.status.SessionStatus
import io.github.jan.supabase.auth.user.UserSession
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.datetime.Instant
import kotlin.time.Duration.Companion.seconds
import kotlin.time.ExperimentalTime

class SupabaseAuthManager(
    private val sessionStore: SupabaseSessionRepository,
    private val client: SupabaseNetworkClient,
) : AuthSessionProvider {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    private val _state = MutableStateFlow<AuthState>(AuthState.Loading)
    private var syncCoordinator: SyncCoordinator? = null

    val state: StateFlow<AuthState> = _state.asStateFlow()

    init {
        scope.launch {
            // Restore session from store
            val savedSession = withContext(Dispatchers.IO) { sessionStore.load() }
            if (savedSession != null) {
                try {
                    @OptIn(ExperimentalTime::class)
                    val userSession = UserSession(
                        accessToken = savedSession.accessToken,
                        refreshToken = savedSession.refreshToken,
                        expiresIn = 3600.seconds.inWholeSeconds,
                        tokenType = savedSession.tokenType,
                        user = null, // Will be fetched by SDK
                        expiresAt = Instant.fromEpochSeconds(savedSession.expiresAtEpochSeconds),
                    )
                    client.supabaseClient.auth.importSession(userSession)
                    _state.value = AuthState.SignedIn(savedSession.user)
                } catch (e: Exception) {
                    _state.value = AuthState.SignedOut
                }
            } else {
                _state.value = AuthState.SignedOut
            }

            observeSessionStatus()
        }
    }

    @OptIn(ExperimentalTime::class)
    private suspend fun observeSessionStatus() {
        client.supabaseClient.auth.sessionStatus.collectLatest { status ->
            when (status) {
                is SessionStatus.Authenticated -> {
                    val session = status.session
                    val user = session.user
                    if (user != null) {
                        val userSummary = UserSummary(user.id, user.email)
                        
                        // Persist session
                        withContext(Dispatchers.IO) {
                            sessionStore.save(
                                SupabaseSession(
                                    accessToken = session.accessToken,
                                    refreshToken = session.refreshToken ?: "",
                                    tokenType = session.tokenType,
                                    expiresAtEpochSeconds = session.expiresAt.epochSeconds,
                                    user = userSummary,
                                )
                            )
                        }

                        emitSignedIn(userSummary)
                        syncCoordinator?.runMigrationIfNeeded()
                    }
                }
                is SessionStatus.NotAuthenticated -> {
                    withContext(Dispatchers.IO) { sessionStore.clear() }
                    emitSignedOut()
                }
                else -> {
                    // Other states
                }
            }
        }
    }

    fun attachSyncCoordinator(syncCoordinator: SyncCoordinator) {
        this.syncCoordinator = syncCoordinator
    }

    suspend fun sendOTP(email: String) {
        withContext(Dispatchers.IO) {
            client.sendOtp(email.trim())
        }
    }

    suspend fun verifyOTP(email: String, token: String) {
        withContext(Dispatchers.IO) {
            client.verifyOtp(email.trim(), token.trim())
        }
        // No need to manually persist or emit, observeSessionStatus will handle it
    }

    suspend fun signOut() {
        withContext(Dispatchers.IO) {
            client.supabaseClient.auth.signOut()
        }
    }

    suspend fun refreshSession() {
        withContext(Dispatchers.IO) {
            try {
                if (client.supabaseClient.auth.currentSessionOrNull() != null) {
                    client.supabaseClient.auth.refreshCurrentSession()
                }
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    override val isAuthenticated: Boolean
        get() = currentUser != null

    override val userId: String?
        get() = currentUser?.id

    override val accessToken: String?
        get() = client.supabaseClient.auth.currentSessionOrNull()?.accessToken

    override val currentUser: UserSummary?
        get() = when (val s = _state.value) {
            is AuthState.SignedIn -> s.user
            else -> {
                client.supabaseClient.auth.currentUserOrNull()?.let {
                    UserSummary(it.id, it.email)
                }
            }
        }

    private fun emitSignedIn(user: UserSummary) {
        _state.value = AuthState.SignedIn(user)
    }

    private fun emitSignedOut() {
        _state.value = AuthState.SignedOut
    }
}
