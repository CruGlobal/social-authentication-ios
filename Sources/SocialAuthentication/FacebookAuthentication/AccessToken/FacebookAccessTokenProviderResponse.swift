//
//  FacebookAccessTokenProviderResponse.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 10/8/24.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation

public struct FacebookAccessTokenProviderResponse {
    
    public let accessToken: String?
    public let isCancelled: Bool
    public let userId: String?
    
    public init(accessToken: String?, isCancelled: Bool, userId: String?) {
        
        self.accessToken = accessToken
        self.isCancelled = isCancelled
        self.userId = userId
    }
}
