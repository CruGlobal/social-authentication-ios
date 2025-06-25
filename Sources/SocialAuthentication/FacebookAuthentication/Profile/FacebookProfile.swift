//
//  FacebookProfile.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import FBSDKLoginKit

public class FacebookProfile {
    
    public init() {
        
    }
    
    public static var current: Profile? {
        return Profile.current
    }
    
    public func loadUserProfile(completion: @escaping ((_ profile: Profile?, _ error: Error?) -> Void)) {
        
        Profile.loadCurrentProfile(completion: completion)
    }
}
