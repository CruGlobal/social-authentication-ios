//
//  FacebookLimitedLogin.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 10/8/24.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@MainActor
public final class FacebookLimitedLogin {
    
    private let facebookLogin: FacebookLogin = FacebookLogin()
    private let configuration: FacebookLimitedLoginConfiguration
        
    public init(configuration: FacebookLimitedLoginConfiguration) {
        
        self.configuration = configuration
    }
    
    public func getAuthenticationToken() -> AuthenticationToken? {
        
        return AuthenticationToken.current
    }
     
    public func getAuthenticationTokenString() -> String? {
        
        return AuthenticationToken.current?.tokenString
    }
    
    public func authenticate(from viewController: UIViewController) async throws -> FacebookLimitedLoginResponse {
        
        let authenticateFromViewController: UIViewController = viewController.getTopMostPresentedViewController() ?? viewController
        
        return try await facebookLogin.performLimitedLogin(
            viewController: authenticateFromViewController,
            permissions: configuration.permissions
        )
    }
    
    public func signOut() async {
        
        await facebookLogin.signOut()
    }
}
