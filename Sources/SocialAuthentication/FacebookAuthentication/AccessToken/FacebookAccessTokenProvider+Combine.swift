//
//  FacebookAccessTokenProvider+Combine.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 10/8/24.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Combine

public extension FacebookAccessTokenProvider {
    
    func authenticatePublisher(from viewController: UIViewController) -> AnyPublisher<FacebookAccessTokenProviderResponse, Error> {
               
        return Future() { promise in
                        
            self.authenticate(from: viewController) { (result: Result<FacebookAccessTokenProviderResponse, Error>) in
                
                switch result {
                    
                case .success(let response):
                    promise(.success(response))
                    
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func refreshCurrentAccessTokenPublisher() -> AnyPublisher<Void, Error> {
        
        return Future() { promise in
                        
            self.refreshCurrentAccessToken() { (result: Result<Void, Error>) in
                
                switch result {
                    
                case .success(let response):
                    promise(.success(response))
                    
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signOutPublisher() -> AnyPublisher<Void, Never> {
        
        signOut()
        
        return Just(())
            .eraseToAnyPublisher()
    }
    
    func getCurrentUserProfilePublisher() -> AnyPublisher<Profile?, Never> {
        
        let profile: Profile? = FacebookProfile.current
        
        return Just(profile)
            .eraseToAnyPublisher()
    }
    
    func loadUserProfilePublisher() -> AnyPublisher<Profile?, Error> {
        
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
