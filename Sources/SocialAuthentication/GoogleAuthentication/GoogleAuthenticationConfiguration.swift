//
//  GoogleAuthenticationConfiguration.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/8/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public class GoogleAuthenticationConfiguration {
    
    public let clientId: String
    
    public init(clientId: String) {
        
        self.clientId = clientId
    }
}
