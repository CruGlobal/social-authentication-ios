//
//  FacebookLogin.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 8/5/26.
//

import Foundation
import UIKit
import FBSDKLoginKit

actor FacebookLogin {
    
    let loginManager: LoginManager = LoginManager()
        
    init() {
        
    }
    
    func performAccessTokenLogin(
        viewController: UIViewController,
        permissions: [String]
    ) async throws -> FacebookAccessTokenProviderResponse {
        
        let loginConfiguration = LoginConfiguration(
            permissions: permissions,
            tracking: .enabled
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            
            loginManager.logIn(viewController: viewController, configuration: loginConfiguration) { (result: LoginResult)  in
                
                switch result {
                
                case .success( _, _, let token):
                    
                    let accessToken: String? = token?.tokenString
                    let userId: String? = AccessToken.current?.userID

                    let response = FacebookAccessTokenProviderResponse(accessToken: accessToken, isCancelled: false, userId: userId)
                    
                    continuation.resume(returning: response)
                
                case .cancelled:
                    
                    let response = FacebookAccessTokenProviderResponse(accessToken: nil, isCancelled: true, userId: nil)
                    
                    continuation.resume(returning: response)
                
                case .failed(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func performLimitedLogin(viewController: UIViewController, permissions: [String]) async throws -> FacebookLimitedLoginResponse {
        
        let loginConfiguration = LoginConfiguration(
            permissions: permissions,
            tracking: .limited
        )
                
        return try await withCheckedThrowingContinuation { continuation in
            
            loginManager.logIn(viewController: viewController, configuration: loginConfiguration) { (result: LoginResult)  in
                
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
    
    func signOut() {
        
        loginManager.logOut()
    }
}
