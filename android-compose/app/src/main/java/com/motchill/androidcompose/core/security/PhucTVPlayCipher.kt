package com.motchill.androidcompose.core.security

import com.motchill.androidcompose.data.remote.toPlaySource
import com.motchill.androidcompose.domain.model.PlaySource

object PhucTVPlayCipher {
    fun decodeSources(encryptedPayload: String): List<PlaySource> {
        return PhucTVPayloadCipher.decodeList(encryptedPayload) { it.toPlaySource() }
    }
}

