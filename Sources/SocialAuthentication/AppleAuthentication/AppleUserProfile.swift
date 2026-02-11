//
//  AppleUserProfile.swift
//  
//  Created by Rachael Skeath on 5/23/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.

import Foundation

public struct AppleUserProfile: Sendable {
    
    public let email: String?
    public let familyName: String?
    public let givenName: String?
    
    public init(email: String?, familyName: String?, givenName: String?) {
     
        self.email = email
        self.familyName = familyName
        self.givenName = givenName
    }
}
