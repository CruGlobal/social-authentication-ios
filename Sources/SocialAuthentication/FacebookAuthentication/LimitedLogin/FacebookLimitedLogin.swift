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
    
    private let loginManager: LoginManager = LoginManager()
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
        
        let loginConfiguration = LoginConfiguration(
            permissions: configuration.permissions,
            tracking: .limited
        )
        
        // TODO: Remove withCheckedThrowingContinuation once FacebookSDK provides a login with async await. ~Levi
        
        return try await withCheckedThrowingContinuation { continuation in
            
            loginManager.logIn(viewController: authenticateFromViewController, configuration: loginConfiguration) { (result: LoginResult)  in
                
                switch result {
                
                case .success( _, _, _):
                    
                    let oidcToken: String? = AuthenticationToken.current?.tokenString
                    let nonce: String? = AuthenticationToken.current?.nonce

                    let response = FacebookLimitedLoginResponse(oidcToken: oidcToken, nonce: nonce, isCancelled: false)
                    continuation.resume(returning: response)
                
                case .cancelled:
                    
                    let response = FacebookLimitedLoginResponse(oidcToken: nil, nonce: nil, isCancelled: true)
                    continuation.resume(returning: response)
                
                case .failed(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func signOut() {
        
        loginManager.logOut()
    }
}
