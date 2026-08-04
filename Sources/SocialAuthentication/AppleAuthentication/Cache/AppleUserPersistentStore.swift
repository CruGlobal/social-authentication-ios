//
//  AppleUserPersistentStore.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/24/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.


import Foundation

public final class AppleUserPersistentStore: Sendable {
    
    private let socialAuthUserDefaults: SocialAuthUserDefaultsInterface

    public init(socialAuthUserDefaults: SocialAuthUserDefaultsInterface) {
        
        self.socialAuthUserDefaults = socialAuthUserDefaults
    }
    
    public func getCurrentUserProfile() async -> AppleUserProfile {
        
        let email: String? = await getUserEmail()
        let familyName: String? = await getUserFamilyName()
        let givenName: String? = await getUserGivenName()
        
        return AppleUserProfile(
            email: email,
            familyName: familyName,
            givenName: givenName
        )
    }
    
    public func getUserId() -> String? {
        return getUserIdFromKeychain()
    }
    
    public func storeUserInfo(email: String?, familyName: String?, givenName: String?) async {
        
        await storeUserDefaults(email: email, familyName: familyName, givenName: givenName)
    }
    
    public func storeUserId(userId: String) -> OSStatus {
        
        return storeUserIdInKeychain(userId)
    }
    
    public func deletePersistedUser() async -> OSStatus {
        
        await deleteUserDefaults()
        
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
    
    private func getUserEmail() async -> String? {
        return await socialAuthUserDefaults.getString(key: UserDefaultKey.appleUserEmail.rawValue)
    }
    
    private func getUserFamilyName() async -> String? {
        return await socialAuthUserDefaults.getString(key: UserDefaultKey.appleUserFamilyName.rawValue)
    }
    
    private func getUserGivenName() async -> String? {
        return await socialAuthUserDefaults.getString(key: UserDefaultKey.appleUserGivenName.rawValue)
    }
    
    private func storeUserDefaults(email: String?, familyName: String?, givenName: String?) async {
        
        await socialAuthUserDefaults.storeString(value: email, forKey: UserDefaultKey.appleUserEmail.rawValue)
        await socialAuthUserDefaults.storeString(value: familyName, forKey: UserDefaultKey.appleUserFamilyName.rawValue)
        await socialAuthUserDefaults.storeString(value: givenName, forKey: UserDefaultKey.appleUserGivenName.rawValue)
        await socialAuthUserDefaults.commitChanges()
    }
    
    private func deleteUserDefaults() async {
        
        for userDefaultkey in UserDefaultKey.allCases {
            await socialAuthUserDefaults.deleteValue(key: userDefaultkey.rawValue)
        }
                
        await socialAuthUserDefaults.commitChanges()
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
