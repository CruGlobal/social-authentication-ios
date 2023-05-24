//
//  AppleUserPersistentStore.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/24/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.


import Foundation

public class AppleUserPersistentStore {
    
    private let userDefaults: UserDefaults = UserDefaults.standard

    public init() {
        
    }
}

// MARK: - Public

extension AppleUserPersistentStore {
    
    public func getCurrentUserProfile() -> AppleUserProfile {
        
        return AppleUserProfile(
            email: getUserEmail(),
            familyName: getUserFamilyName(),
            givenName: getUserGivenName()
        )
    }
    
    public func getUserId() -> String? {
        return getUserIdFromKeychain()
    }
    
    public func storeUserInfo(email: String?, familyName: String?, givenName: String?) {
        
        storeUserDefaults(email: email, familyName: familyName, givenName: givenName)
    }
    
    public func storeUserId(_ userId: String?) {
        guard let userId = userId else { return }
        
        storeUserIdInKeychain(userId)
    }
    
    public func deletePersistedUser() {
        
        deleteUserDefaults()
        deleteKeychainItems()
    }
}

// MARK: - UserDefaults Storage

extension AppleUserPersistentStore {
    
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
    
    private func storeUserDefaults(email: String?, familyName: String?, givenName: String?) {
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

extension AppleUserPersistentStore {
    
    private enum KeychainKeys: String {
        case service = "appleAuthentication"
        case userIdAccount = "userId"
    }
    
    private func getUserIdFromKeychain() -> String? {
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
    
    private func storeUserIdInKeychain(_ userId: String) {
        
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
