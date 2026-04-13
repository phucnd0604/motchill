package com.motchill.androidcompose.app

import android.app.Application
import com.motchill.androidcompose.app.di.PhucTVAppContainer

class PhucTVApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        PhucTVAppContainer.initialize(this)
    }
}
