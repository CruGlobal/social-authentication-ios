//
//  ASAuthorizationAppleIDCredential+Data.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import AuthenticationServices

extension ASAuthorizationAppleIDCredential {
    
    public func getAuthorizationCodeString() -> String? {
        
        guard let authorizationCode = authorizationCode else {
            return nil
        }
        
        return String(data: authorizationCode, encoding: .utf8)
    }
    
    public func getIdentityTokenString() -> String? {
        
        guard let identityToken = identityToken else {
            return nil
        }
        
        return String(data: identityToken, encoding: .utf8)
    }
}
