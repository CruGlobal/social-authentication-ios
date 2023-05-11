//
//  GoogleAuthenticationResponse.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/8/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import GoogleSignIn

public struct GoogleAuthenticationResponse {
    
    public let idToken: String?
}

extension GoogleAuthenticationResponse {
    
    public static func fromGoogleSignInUser(user: GIDGoogleUser) -> GoogleAuthenticationResponse {
        
        return GoogleAuthenticationResponse(
            idToken: user.idToken?.tokenString
        )
    }
    
    public static func emptyResponse() -> GoogleAuthenticationResponse {
        
        return GoogleAuthenticationResponse(
            idToken: nil
        )
    }
}
