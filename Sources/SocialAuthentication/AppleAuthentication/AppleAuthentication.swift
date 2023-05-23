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
    private let userDefaults: UserDefaults = UserDefaults.standard
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
        
        guard let userId = getUserId() else {
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
        
        deletePersistedUser()
    }
}

// MARK: - User

extension AppleAuthentication {
    
    public func getCurrentUserProfile() -> AppleUserProfile? {
        
        guard
            let email = getUserEmail(),
            let familyName = getUserFamilyName(),
            let givenName = getUserGivenName()
        else {
            return nil
        }
        
        return AppleUserProfile(
            email: email,
            familyName: familyName,
            givenName: givenName
        )
    }
    
    private func deletePersistedUser() {
        
        deleteUserDefaults()
        deleteKeychainItems()
    }
}

// MARK: - UserDefaults Storage

extension AppleAuthentication {
    
    private enum UserDefaultKey: String, CaseIterable {
        case appleUserEmail
        case appleUserFamilyName
        case appleUserGivenName
    }
    
    private func getUserEmail() -> String? {
        return userDefaults.string(forKey: UserDefaultKey.appleUserEmail.rawValue)
    }
    
    private func getUserFamilyName() -> String? {
        return userDefaults.string(forKey: UserDefaultKey.appleUserFamilyName.rawValue)
    }
    
    private func getUserGivenName() -> String? {
        return userDefaults.string(forKey: UserDefaultKey.appleUserGivenName.rawValue)
    }
    
    private func storeUserInfo(email: String?, familyName: String?, givenName: String?) {
        userDefaults.set(email, forKey: UserDefaultKey.appleUserEmail.rawValue)
        userDefaults.set(familyName, forKey: UserDefaultKey.appleUserFamilyName.rawValue)
        userDefaults.set(givenName, forKey: UserDefaultKey.appleUserGivenName.rawValue)
    }
    
    private func deleteUserDefaults() {
        
        for userDefaultkey in UserDefaultKey.allCases {
            userDefaults.removeObject(forKey: userDefaultkey.rawValue)
        }
    }
}

// MARK: - Keychain Storage

extension AppleAuthentication {
    
    private enum KeychainKeys: String {
        case service = "appleAuthentication"
        case userIdAccount = "userId"
    }
    
    public func getUserId() -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainKeys.service,
            kSecAttrAccount as String: KeychainKeys.userIdAccount,
            kSecReturnData as String: true
        ] as CFDictionary
        
        var getResult: AnyObject?
        let status = SecItemCopyMatching(query, &getResult)
        
        if status == errSecSuccess {
            
            guard let resultData = getResult as? Data else { return nil }
            return String(data: resultData, encoding: .utf8)
            
        } else {
            return nil
        }
    }
    
    private func storeUserId(_ userId: String?) {
        guard let userId = userId else { return }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainKeys.service,
            kSecAttrAccount as String: KeychainKeys.userIdAccount,
            kSecValueData as String: Data(userId.utf8)
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecSuccess {
           print("Apple Auth UserId store success")
            
        } else if status == errSecDuplicateItem {
            print("Apple Auth UserId duplicate exists")
            
        } else {
            
            let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status))
            
            assertionFailure("error storing userId in keychain: \(error.code)")
        }
    }
    
    private func deleteUserId() {
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainKeys.service,
            kSecAttrAccount as String: KeychainKeys.userIdAccount
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        if status != errSecSuccess || status != errSecItemNotFound {
            
            let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status))
            
            assertionFailure("error removing userId from keychain: \(error.code)")
        }
    }
    
    private func deleteKeychainItems() {
        deleteUserId()
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
        
        storeUserInfo(email: email, familyName: fullName?.familyName, givenName: fullName?.givenName)
        storeUserId(userId)
    }
}
