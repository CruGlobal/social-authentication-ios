//
//  FacebookProfile+Combine.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 6/25/25.
//

import Foundation
import FBSDKLoginKit
import Combine

extension FacebookProfile {
    
    public func getCurrentUserProfilePublisher() -> AnyPublisher<Profile?, Error> {
        
        if let profile = FacebookProfile.current {
            return Just(profile)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
            
        return loadUserProfilePublisher()
    }
    
    private func loadUserProfilePublisher() -> AnyPublisher<Profile?, Error> {
        
        return Future() { promise in
                    
            Profile.loadCurrentProfile { (profile: Profile?, error: Error?) in
                
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    promise(.success(profile))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
