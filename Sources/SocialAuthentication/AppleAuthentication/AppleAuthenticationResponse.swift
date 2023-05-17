//
//  AppleAuthenticationResponse.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/2/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public struct AppleAuthenticationResponse {
    
    public let authorizationCode: String?
    public let email: String?
    public let fullName: PersonNameComponents?
    public let identityToken: String?
    public let userId: String?
    
    public init(authorizationCode: String?, email: String?, fullName: PersonNameComponents?, identityToken: String?, userId: String?) {
        
        self.authorizationCode = authorizationCode
        self.email = email
        self.fullName = fullName
        self.identityToken = identityToken
        self.userId = userId
    }
}
