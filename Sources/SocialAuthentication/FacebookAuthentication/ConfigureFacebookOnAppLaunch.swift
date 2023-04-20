//
//  ConfigureFacebookOnAppLaunch.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import FacebookCore

public class ConfigureFacebookOnAppLaunch {
    
    public static func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?, configuration: FacebookConfiguration) {
        
        Settings.shared.clientToken = configuration.clientToken
        Settings.shared.appID = configuration.appId
        Settings.shared.displayName = configuration.displayName
        Settings.shared.isAutoLogAppEventsEnabled = configuration.isAutoLogAppEventsEnabled
        Settings.shared.isAdvertiserTrackingEnabled = configuration.isAdvertiserTrackingEnabled
        Settings.shared.isAdvertiserIDCollectionEnabled = configuration.isAdvertiserIDCollectionEnabled
        Settings.shared.isSKAdNetworkReportEnabled = configuration.isSKAdNetworkReportEnabled
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}
