package com.houzi.app

import com.onesignal.notifications.IActionButton
import com.onesignal.notifications.IDisplayableMutableNotification
import com.onesignal.notifications.INotificationReceivedEvent
import com.onesignal.notifications.INotificationServiceExtension

import android.content.Context
import com.onesignal.OneSignal
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import android.content.Intent
import android.os.Bundle


 class NotificationServiceExtension : INotificationServiceExtension {

    override fun onNotificationReceived(event: INotificationReceivedEvent) {

        //If you need to perform an async action or stop the payload from being shown automatically,
        //use event.preventDefault(). Using event.notification.display() will show this message again.

        val notification: IDisplayableMutableNotification = event.notification

        event.preventDefault()

        // this is an example of how to modify the notification by changing the background color to blue
//        notification.setExtender { builder -> builder.setColor(0xFF0000FF.toInt()) }

        val jsonObject = notification.additionalData
        val jsonString = jsonObject.toString()
//        println("Push Notification Json Object: $jsonString")

        // Display the notification
        event.notification.display()
    }
}