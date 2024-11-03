//
//  NativeAdView.swift
//  Runner
//
//  Created by Adil Soomro on 11/03/2022.
//  Copyright © 2022 The Chromium Authors. All rights reserved.
//

import Foundation

import google_mobile_ads
import UIKit

// TODO: Implement ListTileNativeAdFactory
class HomeNativeAdViewFactory : FLTNativeAdFactory {

    func createNativeAd(_ nativeAd: GADNativeAd,
                        customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        var darkMode:Bool = false;
        if let options:[AnyHashable : Any] = customOptions {
            darkMode = options["isDarkMode"] as? Bool ?? false ;
        }
        let nibView = Bundle.main.loadNibNamed("HomeNativeAdView", owner: nil, options: nil)!.first
        let nativeAdView = nibView as! GADNativeAdView

        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline

        (nativeAdView.bodyView as! UILabel).text = nativeAd.body
        nativeAdView.bodyView!.isHidden = nativeAd.body == nil

        (nativeAdView.iconView as! UIImageView).image = nativeAd.icon?.image
        nativeAdView.iconView!.isHidden = nativeAd.icon == nil

        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        

        nativeAdView.nativeAd = nativeAd
        
        if (darkMode) {
            
            nativeAdView.backgroundColor = UIColor(red: 0.14, green: 0.15, blue: 0.15, alpha: 1.00)
            nativeAdView.iconView?.backgroundColor = UIColor(red: 0.14, green: 0.15, blue: 0.15, alpha: 1.00)
            (nativeAdView.bodyView as! UILabel).textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
            (nativeAdView.headlineView as! UILabel).textColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
            
            (nativeAdView.callToActionView as! UIButton).setTitleColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00), for: .normal)
        }

        return nativeAdView
    }
}
