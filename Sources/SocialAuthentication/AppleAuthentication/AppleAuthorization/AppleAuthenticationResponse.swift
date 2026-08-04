//
//  AppleAuthenticationResponse.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/2/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import AuthenticationServices

public struct AppleAuthenticationResponse: Sendable {
    
    public let authorizationCode: String?
    public let email: String?
    public let fullName: PersonNameComponents?
    public let identityToken: String?
    public let isCancelled: Bool
    public let userId: String?
    public let persistUserIdStatus: OSStatus?
    
    public init(authorizationCode: String?, email: String?, fullName: PersonNameComponents?, identityToken: String?, isCancelled: Bool, userId: String?, persistUserIdStatus: OSStatus?) {
        
        self.authorizationCode = authorizationCode
        self.email = email
        self.fullName = fullName
        self.identityToken = identityToken
        self.isCancelled = isCancelled
        self.userId = userId
        self.persistUserIdStatus = persistUserIdStatus
    }
    
    func copy(persistUserIdStatus: OSStatus?) -> AppleAuthenticationResponse {
        
        return AppleAuthenticationResponse(
            authorizationCode: self.authorizationCode,
            email: self.email,
            fullName: self.fullName,
            identityToken: self.identityToken,
            isCancelled: self.isCancelled,
            userId: self.userId,
            persistUserIdStatus: persistUserIdStatus ?? self.persistUserIdStatus
        )
        
    }
    
    static func userCancelledResponse() -> AppleAuthenticationResponse {
        return AppleAuthenticationResponse(
            authorizationCode: nil,
            email: nil,
            fullName: nil,
            identityToken: nil,
            isCancelled: true,
            userId: nil,
            persistUserIdStatus: nil
        )
    }
}
