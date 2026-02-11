//
//  GoogleAuthentication.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/8/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import GoogleSignIn

public final class GoogleAuthentication {
    
    private let sharedGoogleSignIn: GIDSignIn = GIDSignIn.sharedInstance
    
    public init(configuration: GoogleAuthenticationConfiguration) {
        
        sharedGoogleSignIn.configuration = GIDConfiguration.init(
            clientID: configuration.clientId,
            serverClientID: configuration.serverClientId,
            hostedDomain: configuration.hostedDomain,
            openIDRealm: configuration.openIDRealm
        )
    }
    
    public func getGoogleSignIn() -> GIDSignIn {
        return sharedGoogleSignIn
    }
    
    public func getPersistedIdTokenString() -> String? {
        return getCurrentUser()?.idToken?.tokenString
    }
    
    public func getCurrentUser() -> GIDGoogleUser? {
        return sharedGoogleSignIn.currentUser
    }
    
    public func getCurrentUserProfile() -> GIDProfileData? {
        return getCurrentUser()?.profile
    }
    
    @MainActor public func authenticate(from viewController: UIViewController) async throws -> GoogleAuthenticationResponse {
        
        let result: GIDSignInResult = try await sharedGoogleSignIn.signIn(withPresenting: viewController, hint: nil, additionalScopes: nil)
        
        let user: GIDGoogleUser = result.user
        
        try await user.refreshTokensIfNeeded()
        
        let response = GoogleAuthenticationResponse.fromGoogleSignInUser(user: user)
        
        return response
    }
    
    public func restorePreviousSignIn() async throws -> GoogleAuthenticationResponse {
        
        let user: GIDGoogleUser = try await sharedGoogleSignIn.restorePreviousSignIn()
        
        let response = GoogleAuthenticationResponse.fromGoogleSignInUser(user: user)
        
        return response
    }
    
    public func refreshCurrentUserTokens() async throws -> GoogleAuthenticationResponse {
        
        guard let currentUser = getCurrentUser() else {
            return GoogleAuthenticationResponse.emptyResponse()
        }
        
        try await currentUser.refreshTokensIfNeeded()
        
        let response = GoogleAuthenticationResponse.fromGoogleSignInUser(user: currentUser)
        
        return response
    }
    
    public func signOut() {
        sharedGoogleSignIn.signOut()
    }
}
