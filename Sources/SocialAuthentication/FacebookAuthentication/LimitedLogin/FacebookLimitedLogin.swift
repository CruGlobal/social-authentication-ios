//
//  FacebookLimitedLogin.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 10/8/24.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit

public class FacebookLimitedLogin {
    
    private let loginManager: LoginManager = LoginManager()
    private let configuration: FacebookLimitedLoginConfiguration
        
    public init(configuration: FacebookLimitedLoginConfiguration) {
        
        self.configuration = configuration
    }
    
    public func authenticate(from viewController: UIViewController, completion: @escaping ((_ result: Result<FacebookLimitedLoginResponse, Error>) -> Void)) {
        
        let authenticateFromViewController: UIViewController = viewController.getTopMostPresentedViewController() ?? viewController
        
        let loginConfiguration = LoginConfiguration(permissions: configuration.permissions, tracking: .limited)
        
        loginManager.logIn(viewController: authenticateFromViewController, configuration: loginConfiguration) { (result: LoginResult)  in
            
            switch result {
            
            case .success( _, _, _):
                
                let oidcToken: String? = AuthenticationToken.current?.tokenString
                let nonce: String? = AuthenticationToken.current?.nonce

                completion(.success(FacebookLimitedLoginResponse(oidcToken: oidcToken, nonce: nonce, isCancelled: false)))
            
            case .cancelled:
                completion(.success(FacebookLimitedLoginResponse(oidcToken: nil, nonce: nil, isCancelled: true)))
            
            case .failed(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - OIDC Token

extension FacebookLimitedLogin {
    
    public func getAuthenticationToken() -> AuthenticationToken? {
        
        return AuthenticationToken.current
    }
     
    public func getAuthenticationTokenString() -> String? {
        
        return AuthenticationToken.current?.tokenString
    }
}

// MARK: - Sign Out

extension FacebookLimitedLogin {
    
    public func signOut() {
        
        loginManager.logOut()
    }
}
