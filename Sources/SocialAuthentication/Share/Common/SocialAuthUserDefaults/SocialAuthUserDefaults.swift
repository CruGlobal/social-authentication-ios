//
//  SocialAuthUserDefaults.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 7/31/26.
//

import Foundation

public actor SocialAuthUserDefaults: SocialAuthUserDefaultsInterface {
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = UserDefaults.standard) {
        
        self.userDefaults = userDefaults
    }
    
    private func getValue(key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
    
    private func cache(value: Any?, forKey: String) {
        userDefaults.set(value, forKey: forKey)
    }
    
    public func getString(key: String) -> String? {
        return getValue(key: key) as? String
    }
    
    public func storeString(value: String?, forKey: String) {
        cache(value: value, forKey: forKey)
    }
    
    public func deleteValue(key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    public func commitChanges() {
        userDefaults.synchronize()
    }
}
