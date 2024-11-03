package com.houzi.app

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class ListTileNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {


    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {

        val isDarkMode = customOptions?.get("isDarkMode")
        var myLayout = R.layout.list_tile_native_ad
        if (isDarkMode as Boolean) {
            myLayout = R.layout.list_tile_native_ad_dark
        }

        val nativeAdView = LayoutInflater.from(context)
            .inflate(myLayout, null) as NativeAdView

        val adLoader: AdLoader? = null

        with(nativeAdView) {
            val attributionViewSmall = findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_small)
            val attributionViewLarge = findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_large)

            val iconView = findViewById<ImageView>(R.id.iv_list_tile_native_ad_icon)
            val icon = nativeAd.icon
            if (icon != null) {
                attributionViewSmall.visibility = View.VISIBLE
                attributionViewLarge.visibility = View.INVISIBLE
                iconView.setImageDrawable(icon.drawable)
            } else {
                attributionViewSmall.visibility = View.INVISIBLE
                attributionViewLarge.visibility = View.VISIBLE
            }
            this.iconView = iconView

            val headlineView = findViewById<TextView>(R.id.tv_list_tile_native_ad_headline)
            if (nativeAd.headline != null) {
                headlineView.text = nativeAd.headline
                this.headlineView = headlineView
            }

            val bodyView = findViewById<TextView>(R.id.tv_list_tile_native_ad_body)
            with(bodyView) {
                if (nativeAd.body != null) {
                    text = nativeAd.body
                    if (text != null) {
                        visibility =
                            if (nativeAd.body != null && nativeAd.body?.isNotEmpty() == true) View.VISIBLE else View.INVISIBLE
                    }
                }
            }
            this.bodyView = bodyView


            val callToActionView = findViewById<TextView>(R.id.tv_list_tile_native_ad_call_to_action)
            if (nativeAd.callToAction != null) {
                callToActionView.text = nativeAd.callToAction
                this.callToActionView = callToActionView
            }

            setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}