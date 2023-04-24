//
//  FacebookAuthenticationResponse.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public struct FacebookAuthenticationResponse {
    
    public let accessToken: String?
    public let isCancelled: Bool
    public let userId: String?
    
    public init(accessToken: String?, isCancelled: Bool, userId: String?) {
        
        self.accessToken = accessToken
        self.isCancelled = isCancelled
        self.userId = userId
    }
}
