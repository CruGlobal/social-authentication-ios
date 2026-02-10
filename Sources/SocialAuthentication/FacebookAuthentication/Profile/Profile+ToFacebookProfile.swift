//
//  Profile+ToFacebookProfile.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 2/10/26.
//

import Foundation
import FBSDKLoginKit

extension Profile {
    
    func toFacebookProfile() -> FacebookProfile {
        
        return FacebookProfile(
            email: email,
            firstName: firstName,
            imageURL: imageURL,
            lastName: lastName,
            linkURL: linkURL,
            middleName: middleName,
            name: name,
            userId: userID
        )
    }
}
