//
//  AppleAuthentication+Combine.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/5/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import Combine

public extension AppleAuthentication {
    
    func authenticatePublisher() -> AnyPublisher<AppleAuthenticationResponse, Error> {
        
        return Future() { promise in
            
            self.authenticate { (result: Result<AppleAuthenticationResponse, Error>) in
                
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
    
    func isAuthenticatedPublisher() -> AnyPublisher<Bool, Never> {
        
        return Future() { promise in
            
            self.isAuthenticated { isAuthenticated in
                
                return promise(.success(isAuthenticated))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getAuthStatePublisher() -> AnyPublisher<AppleAuthenticationState, Never> {
        
        return Future() { promise in
            
            self.getAuthenticationState { authenticationState in
                
                return promise(.success(authenticationState))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getCurrentUserProfilePublisher() -> AnyPublisher<AppleUserProfile, Never> {
        
        let profile: AppleUserProfile = getCurrentUserProfile()
        
        return Just(profile)
            .eraseToAnyPublisher()
    }
    
    func signOutPublisher() -> AnyPublisher<Void, Never> {
        
        signOut()
        
        return Just(())
            .eraseToAnyPublisher()
    }
}
