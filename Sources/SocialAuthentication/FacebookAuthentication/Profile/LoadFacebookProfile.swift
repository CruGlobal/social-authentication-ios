//
//  LoadFacebookProfile.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import FBSDKLoginKit

public final class LoadFacebookProfile: Sendable {
    
    public init() {
        
    }
    
    public static var current: FacebookProfile? {
        return Profile.current?.toFacebookProfile()
    }
    
    @MainActor public func loadProfile() async throws -> FacebookProfile? {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            Profile.loadCurrentProfile { (profile: Profile?, error: Error?) in
                
                if let error = error {
                    
                    continuation.resume(throwing: error)
                }
                else {
                    
                    continuation.resume(returning: profile?.toFacebookProfile())
                }
            }
        }
    }
}
