package com.houzi.app

import io.flutter.app.FlutterApplication
import android.app.Application
import android.util.Log

import com.onesignal.OneSignal
import com.onesignal.debug.LogLevel
import com.onesignal.Continue
import com.onesignal.notifications.INotificationClickEvent
import com.onesignal.notifications.INotificationClickListener

import org.json.JSONObject
import androidx.annotation.NonNull

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import com.onesignal.notifications.INotification



class ApplicationClass : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
//        instance = this
        val ONESIGNAL_APP_ID = getString(R.string.onesignal_app_id)
        if (!ONESIGNAL_APP_ID.isNullOrBlank()) {
            // Verbose Logging set to help debug issues, remove before releasing your app.
            // OneSignal.Debug.logLevel = LogLevel.VERBOSE

            // OneSignal Initialization
            OneSignal.initWithContext(this, ONESIGNAL_APP_ID)

            // requestPermission will show the native Android notification permission prompt.
            // NOTE: It's recommended to use a OneSignal In-App Message to prompt instead.
            CoroutineScope(Dispatchers.IO).launch {
                OneSignal.Notifications.requestPermission(false)
            }

            val clickListener = object : INotificationClickListener {
                override fun onClick(event: INotificationClickEvent) {
                    val notification: INotification = event.notification
                    val jsonObject = notification.additionalData
                    val jsonString = jsonObject.toString()
                    pushAdditionalData = jsonString
                }
            }

            OneSignal.Notifications.addClickListener(clickListener)
        }
    }

    companion object {
        var pushAdditionalData : String? = null
//        lateinit var instance: ApplicationClass
    }
}