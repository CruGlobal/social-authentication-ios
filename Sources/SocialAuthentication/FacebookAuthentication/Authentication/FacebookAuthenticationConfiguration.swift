//
//  FacebookAuthenticationConfiguration.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public class FacebookAuthenticationConfiguration {
    
    public let permissions: [String]
    
    public init(permissions: [String]) {
        
        self.permissions = permissions
    }
}
