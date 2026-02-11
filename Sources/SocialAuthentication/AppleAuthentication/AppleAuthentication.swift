//
//  AppleAuthentication.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/1/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import AuthenticationServices

public final class AppleAuthentication {
    
    private let appleAuthorization: AppleAuthorization = AppleAuthorization()
    private let appleUserPersistentStore: AppleUserPersistentStore
    
    public init(appleUserPersistentStore: AppleUserPersistentStore) {
        
        self.appleUserPersistentStore = appleUserPersistentStore
    }
    
    public func getCurrentUserProfile() -> AppleUserProfile {
        
        appleUserPersistentStore.getCurrentUserProfile()
    }
    
    public func getIsAuthenticated() async throws -> Bool {
        
        let authState: AppleAuthenticationState = try await getAuthenticationState()
        
        return authState.isAuthenticated
    }
    
    public func getAuthenticationState() async throws -> AppleAuthenticationState {
        
        guard let userId = appleUserPersistentStore.getUserId() else {
            return .notFound
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let credentialState = try await appleIDProvider.credentialState(forUserID: userId)
        
        let authState = AppleAuthenticationState(credentialState: credentialState)
        
        return authState
    }

    @MainActor public func authenticate(requestScopes: [ASAuthorization.Scope] = [.email, .fullName]) async throws -> AppleAuthenticationResponse {
        
        let persistentStore: AppleUserPersistentStore = self.appleUserPersistentStore
        
        return try await withCheckedThrowingContinuation { continuation in
            
            appleAuthorization.authenticate(requestScopes: requestScopes) { (result: Result<AppleAuthenticationResponse, Error>) in
                
                switch result {
                case .success(let response):
                    
                    if let userId = response.userId {
                        
                        persistentStore.storeUserInfo(
                            email: response.email,
                            familyName: response.fullName?.familyName,
                            givenName: response.fullName?.givenName
                        )
                        
                        let status: OSStatus = persistentStore.storeUserId(
                            userId: userId
                        )
                        
                        let responseWithStatus = response.copy(persistUserIdStatus: status)
                        
                        continuation.resume(returning: responseWithStatus)
                    }
                    else {
                        
                        continuation.resume(returning: response)
                    }

                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func signOut() -> OSStatus {
        
        return appleUserPersistentStore.deletePersistedUser()
    }
}
