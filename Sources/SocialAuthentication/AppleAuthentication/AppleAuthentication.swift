//
//  AppleAuthentication.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/1/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import AuthenticationServices

@MainActor
public final class AppleAuthentication {
    
    private let appleAuthorization: AppleAuthorization = AppleAuthorization()
    private let appleUserPersistentStore: AppleUserPersistentStore
    
    public init(
        socialAuthUserDefaults: SocialAuthUserDefaultsInterface = SocialAuthUserDefaults(
            userDefaults: UserDefaults.standard
        )
    ) {
        
        self.appleUserPersistentStore = AppleUserPersistentStore(socialAuthUserDefaults: socialAuthUserDefaults)
    }
    
    public func getCurrentUserProfile() async -> AppleUserProfile {
        
        return await appleUserPersistentStore.getCurrentUserProfile()
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

    public func authenticate(requestScopes: [ASAuthorization.Scope] = [.email, .fullName]) async throws -> AppleAuthenticationResponse {
                
        let response = try await appleAuthorization.authenticate(requestScopes: requestScopes)
        
        guard let userId = response.userId else {
            return response
        }
        
        await appleUserPersistentStore.storeUserInfo(
            email: response.email,
            familyName: response.fullName?.familyName,
            givenName: response.fullName?.givenName
        )
        
        let status: OSStatus = appleUserPersistentStore.storeUserId(
            userId: userId
        )
        
        let responseWithStatus = response.copy(persistUserIdStatus: status)
        
        return responseWithStatus
    }
    
    public func signOut() async -> OSStatus {
        
        return await appleUserPersistentStore.deletePersistedUser()
    }
}
