//
//  GoogleAuthenticationConfiguration.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/8/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public class GoogleAuthenticationConfiguration {
    
    public let clientId: String
    public let serverClientId: String?
    public let hostedDomain: String?
    public let openIDRealm: String?
    
    public init(clientId: String, serverClientId: String?, hostedDomain: String?, openIDRealm: String?) {
        
        self.clientId = clientId
        self.serverClientId = serverClientId
        self.hostedDomain = hostedDomain
        self.openIDRealm = openIDRealm
    }
}
