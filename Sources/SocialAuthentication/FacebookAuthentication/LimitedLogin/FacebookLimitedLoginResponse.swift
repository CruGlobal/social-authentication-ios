//
//  FacebookLimitedLoginResponse.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 10/8/24.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

// OIDC Token: (https://developers.facebook.com/docs/facebook-login/limited-login/token)

import Foundation

public struct FacebookLimitedLoginResponse {
    
    public let oidcToken: String?
    public let nonce: String?
    public let isCancelled: Bool
    
    public init(oidcToken: String?, nonce: String?, isCancelled: Bool) {
        
        self.oidcToken = oidcToken
        self.nonce = nonce
        self.isCancelled = isCancelled
    }
}
