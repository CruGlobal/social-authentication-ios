//
//  FacebookProfile.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 2/10/26.
//

import Foundation

public struct FacebookProfile: Sendable {
    
    public let email: String?
    public let firstName: String?
    public let imageURL: URL?
    public let lastName: String?
    public let linkURL: URL?
    public let middleName: String?
    public let name: String?
    public let userId: String
    
    public init(email: String?, firstName: String?, imageURL: URL?, lastName: String?, linkURL: URL?, middleName: String?, name: String?, userId: String) {
        
        self.email = email
        self.firstName = firstName
        self.imageURL = imageURL
        self.lastName = lastName
        self.linkURL = linkURL
        self.middleName = middleName
        self.name = name
        self.userId = userId
    }
}
