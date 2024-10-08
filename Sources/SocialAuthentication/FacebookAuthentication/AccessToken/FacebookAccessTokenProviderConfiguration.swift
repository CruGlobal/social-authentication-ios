//
//  FacebookAccessTokenProviderConfiguration.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 10/8/24.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public class FacebookAccessTokenProviderConfiguration {
    
    public let permissions: [String]
    
    public init(permissions: [String]) {
        
        self.permissions = permissions
    }
}
