//
//  AppleAuthenticationResponse.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/2/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public struct AppleAuthenticationResponse {
    
    public let accessToken: String?
    public let userId: String?
    
    public init(accessToken: String?, userId: String?) {
        
        self.accessToken = accessToken
        self.userId = userId
    }
}
