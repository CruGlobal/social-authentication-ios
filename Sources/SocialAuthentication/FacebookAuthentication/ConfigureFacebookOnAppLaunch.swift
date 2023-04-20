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
        
        Settings.shared.clientToken = "3b6bf5b7c128a970337c4fa1860ffa6e"
        Settings.shared.appID = "2236701616451487"
        Settings.shared.displayName = "GodTools"
        Settings.shared.isAutoLogAppEventsEnabled = false
        Settings.shared.isAdvertiserTrackingEnabled = false
        Settings.shared.isAdvertiserIDCollectionEnabled = false
        Settings.shared.isSKAdNetworkReportEnabled = false
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}
