//
//  AppleUserPersistentStore.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/24/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.


import Foundation

public final class AppleUserPersistentStore {
    
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = UserDefaults.standard) {
        
        self.userDefaults = userDefaults
    }
    
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
    
    public func storeUserId(userId: String) -> OSStatus {
        
        return storeUserIdInKeychain(userId)
    }
    
    public func deletePersistedUser() -> OSStatus {
        
        deleteUserDefaults()
        
        return deleteKeychainItems()
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
        userDefaults.synchronize()
    }
    
    private func deleteUserDefaults() {
        
        for userDefaultkey in UserDefaultKey.allCases {
            userDefaults.removeObject(forKey: userDefaultkey.rawValue)
        }
        
        userDefaults.synchronize()
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
        
        if status == errSecSuccess, let resultData = getResult as? Data {
            
            return String(
                data: resultData,
                encoding: .utf8
            )
        }
        else {
            return nil
        }
    }
    
    private func storeUserIdInKeychain(_ userId: String) -> OSStatus {
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainKeys.service,
            kSecAttrAccount as String: KeychainKeys.userIdAccount,
            kSecValueData as String: Data(userId.utf8)
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        return status
    }
    
    private func deleteUserId() -> OSStatus {
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainKeys.service,
            kSecAttrAccount as String: KeychainKeys.userIdAccount
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        return status
    }
    
    private func deleteKeychainItems() -> OSStatus {
        return deleteUserId()
    }
}
