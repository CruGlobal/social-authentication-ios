//
//  GoogleAuthentication.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/8/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import GoogleSignIn

public class GoogleAuthentication {
    
    private let sharedGoogleSignIn: GIDSignIn = GIDSignIn.sharedInstance
    
    public init(configuration: GoogleAuthenticationConfiguration) {
        
        sharedGoogleSignIn.configuration = GIDConfiguration.init(
            clientID: configuration.clientId
        )
    }
}

// MARK: - Authenticate

extension GoogleAuthentication {
    
    public func authenticate(from viewController: UIViewController, completion: @escaping ((_ result: Result<GoogleAuthenticationResponse, Error>) -> Void)) {
        
        sharedGoogleSignIn.signIn(withPresenting: viewController, hint: nil, additionalScopes: nil, completion: { [weak self] (result: GIDSignInResult?, signInError: Error?) in
            
            if let signInError = signInError {
                
                completion(.failure(signInError))
            }
            else if let authenticatedUser = result?.user {
                
                self?.refreshUserTokens(user: authenticatedUser, completion: { (refreshTokenResult: Result<GoogleAuthenticationResponse, Error>) in
                    
                    switch refreshTokenResult {
                        
                    case .success(let response):
                        completion(.success(response))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            }
            else {
                
                let response = GoogleAuthenticationResponse.emptyResponse()
                completion(.success(response))
            }
        })
    }
    
    public func restorePreviousSignIn(completion: @escaping ((_ result: Result<GoogleAuthenticationResponse, Error>) -> Void)) {
        
        sharedGoogleSignIn.restorePreviousSignIn(completion: { (user: GIDGoogleUser?, error: Error?) in
            
            if let error = error {
                
                completion(.failure(error))
            }
            else if let user = user {
                
                let response = GoogleAuthenticationResponse.fromGoogleSignInUser(user: user)
                completion(.success(response))
            }
            else {
                
                let response = GoogleAuthenticationResponse.emptyResponse()
                completion(.success(response))
            }
        })
    }
}

// MARK: - Tokens

extension GoogleAuthentication {
    
    public func getCurrentUser() -> GIDGoogleUser? {
        return sharedGoogleSignIn.currentUser
    }
    
    public func getPersistedIdTokenString() -> String? {
        return getCurrentUser()?.idToken?.tokenString
    }
    
    public func refreshCurrentUserTokens(completion: @escaping ((_ result: Result<GoogleAuthenticationResponse, Error>) -> Void)) {
        
        guard let currentUser = getCurrentUser() else {
            let response = GoogleAuthenticationResponse.emptyResponse()
            completion(.success(response))
            return
        }
        
        refreshUserTokens(user: currentUser, completion: completion)
    }
    
    public func refreshUserTokens(user: GIDGoogleUser, completion: @escaping ((_ result: Result<GoogleAuthenticationResponse, Error>) -> Void)) {
        
        user.refreshTokensIfNeeded(completion: { (user: GIDGoogleUser?, error: Error?) in
            
            if let error = error {
                
                completion(.failure(error))
            }
            else if let user = user {
                
                let response = GoogleAuthenticationResponse.fromGoogleSignInUser(user: user)
                completion(.success(response))
            }
            else {
                
                let response = GoogleAuthenticationResponse.emptyResponse()
                completion(.success(response))
            }
        })
    }
}

// MARK: - Sign Out

extension GoogleAuthentication {
    
    public func signOut() {
        
        sharedGoogleSignIn.signOut()
    }
}
