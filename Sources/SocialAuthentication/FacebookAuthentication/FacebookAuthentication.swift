//
//  FacebookAuthentication.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Combine

public class FacebookAuthentication: NSObject {
    
    private let facebookLoginManager: LoginManager = LoginManager()
    private let configuration: FacebookAuthenticationConfiguration
    private let accessTokenChanged: CurrentValueSubject<String?, Never>
        
    public init(configuration: FacebookAuthenticationConfiguration) {
        
        self.configuration = configuration
        self.accessTokenChanged = CurrentValueSubject(AccessToken.current?.tokenString)
        
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessTokenDidChange(notification:)),
            name: .AccessTokenDidChange,
            object: nil
        )
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: .AccessTokenDidChange, object: nil)
    }
    
    public var accessTokenChangedPublisher: AnyPublisher<String?, Never> {
        return accessTokenChanged
            .eraseToAnyPublisher()
    }
    
    @objc private func accessTokenDidChange(notification: Notification) {
                
        accessTokenChanged.send(AccessToken.current?.tokenString)
    }
}

// MARK: - Authentication

extension FacebookAuthentication {
    
    public func authenticate(from viewController: UIViewController, completion: @escaping ((_ result: Result<FacebookAuthenticationResponse, Error>) -> Void)) {
               
        let authenticateFromViewController: UIViewController = viewController.getTopMostPresentedViewController() ?? viewController
        
        facebookLoginManager.logIn(permissions: configuration.permissions, from: authenticateFromViewController, handler: { (loginResult: LoginManagerLoginResult?, loginError: Error?) in
            
            if let loginResult = loginResult {
                
                let response = FacebookAuthenticationResponse(
                    accessToken: loginResult.token?.tokenString,
                    isCancelled: loginResult.isCancelled,
                    userId: loginResult.token?.userID
                )
                
                completion(.success(response))
            }
            else if let loginError = loginError {
                
                completion(.failure(loginError))
            }
            else {
                
                let errorMessage: String = "Failed to authenticate with facebook.  Neither an error occurred or token string could be obtained."
                let error: Error = NSError(domain: "FacebookAuthentication", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                
                completion(.failure(error))
            }
        })
    }
}

// MARK: - Access Token

extension FacebookAuthentication {
    
    public func getAccessToken() -> AccessToken? {
        
        return AccessToken.current
    }
    
    public func getUserId() -> String? {
        
        return AccessToken.current?.userID
    }
    
    public func getAccessTokenString() -> String? {
        
        return AccessToken.current?.tokenString
    }
    
    public func refreshCurrentAccessToken(completion: @escaping ((_ result: Result<Void, Error>) -> Void)) {
        
        AccessToken.refreshCurrentAccessToken(completion: { (connection: GraphRequestConnecting?, result: Any?, error: Error?) in
            
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(()))
            }
        })
    }
}

// MARK: - Sign Out

extension FacebookAuthentication {
    
    public func signOut() {
        
        facebookLoginManager.logOut()
    }
}
