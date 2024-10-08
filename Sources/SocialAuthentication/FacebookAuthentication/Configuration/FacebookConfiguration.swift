//
//  FacebookConfiguration.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public class FacebookConfiguration {
    
    public let appId: String
    public let clientToken: String
    public let displayName: String
    public let isAutoLogAppEventsEnabled: Bool
    public let isAdvertiserIDCollectionEnabled: Bool
    public let isSKAdNetworkReportEnabled: Bool
    
    public init(appId: String, clientToken: String, displayName: String, isAutoLogAppEventsEnabled: Bool, isAdvertiserIDCollectionEnabled: Bool, isSKAdNetworkReportEnabled: Bool) {
        
        self.appId = appId
        self.clientToken = clientToken
        self.displayName = displayName
        self.isAutoLogAppEventsEnabled = isAutoLogAppEventsEnabled
        self.isAdvertiserIDCollectionEnabled = isAdvertiserIDCollectionEnabled
        self.isSKAdNetworkReportEnabled = isSKAdNetworkReportEnabled
    }
}
