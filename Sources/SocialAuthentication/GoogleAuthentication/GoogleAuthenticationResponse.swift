//
//  GoogleAuthenticationResponse.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/8/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import GoogleSignIn

public struct GoogleAuthenticationResponse: Sendable {
    
    public let idToken: String?
    public let isCancelled: Bool
    
    public init(idToken: String?, isCancelled: Bool) {
     
        self.idToken = idToken
        self.isCancelled = isCancelled
    }
}

extension GoogleAuthenticationResponse {
    
    public static func fromGoogleSignInUser(user: GIDGoogleUser) -> GoogleAuthenticationResponse {
        
        return GoogleAuthenticationResponse(
            idToken: user.idToken?.tokenString,
            isCancelled: false
        )
    }
    
    public static func emptyResponse(isCancelled: Bool = false) -> GoogleAuthenticationResponse {
        
        return GoogleAuthenticationResponse(
            idToken: nil,
            isCancelled: isCancelled
        )
    }
}
