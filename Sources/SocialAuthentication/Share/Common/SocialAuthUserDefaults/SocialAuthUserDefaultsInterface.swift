//
//  SocialAuthUserDefaultsInterface.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 7/31/26.
//

import Foundation

public protocol SocialAuthUserDefaultsInterface: Actor {
    
    func getString(key: String) -> String?
    func storeString(value: String?, forKey: String)
    func deleteValue(key: String)
    func commitChanges()
}
