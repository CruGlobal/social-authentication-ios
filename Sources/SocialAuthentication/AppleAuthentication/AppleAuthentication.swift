//
//  AppleAuthentication.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/1/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

public class AppleAuthentication: NSObject {
    
    public typealias AppleAuthenticationCompletion = ((_ result: Result<AppleAuthenticationResponse, Error>) -> Void)
    
    private var completionBlock: AppleAuthenticationCompletion?
    
    private let appleUserPersistentStore: AppleUserPersistentStore
    
    public init(appleUserPersistentStore: AppleUserPersistentStore) {
        
        self.appleUserPersistentStore = appleUserPersistentStore
    }
}

// MARK: - Authentication

extension AppleAuthentication {
    
    public func authenticate(completion: @escaping AppleAuthenticationCompletion) {
        self.completionBlock = completion
        
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
        
    }
    
    public func getAuthenticationState(completion: @escaping ((_ authenticationState: AppleAuthenticationState) -> Void)) {
        
        guard let userId = appleUserPersistentStore.getUserId() else {
            completion(.notFound)
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userId) { (credentialState, error) in
            
            let authState = AppleAuthenticationState(credentialState: credentialState)
            completion(authState)
        }
    }
    
    public func isAuthenticated(completion: @escaping ((_ isAuthenticated: Bool) -> Void)) {
        
        getAuthenticationState { authenticationState in
            
            switch authenticationState {
                
            case .authorized:
                completion(true)
                
            case .revoked, .notFound, .transferred, .unknown:
                completion(false)
            }
        }
    }
}

// MARK: - Sign Out

extension AppleAuthentication {
    
    public func signOut() {
        
        appleUserPersistentStore.deletePersistedUser()
    }
}

// MARK: - User

extension AppleAuthentication {
    
    public func getCurrentUserProfile() -> AppleUserProfile {
        
        appleUserPersistentStore.getCurrentUserProfile()
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthentication: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        guard let completion = completionBlock else { return }
        
        completion(.failure(error))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let completion = completionBlock else { return }
        
        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            
            completion(.failure(AppleAuthenticationError.noAuthCredential))
            return
        }
        
        let email = appleIdCredential.email
        let fullName = appleIdCredential.fullName
        let userId = appleIdCredential.user
        
        let response = AppleAuthenticationResponse(
            authorizationCode: appleIdCredential.authorizationCode?.base64EncodedString(),
            email: email,
            fullName: fullName,
            identityToken: appleIdCredential.identityToken?.base64EncodedString(),
            userId: userId
        )
        
        completion(.success(response))
        
        appleUserPersistentStore.storeUserInfo(email: email, familyName: fullName?.familyName, givenName: fullName?.givenName)
        appleUserPersistentStore.storeUserId(userId)
    }
}
