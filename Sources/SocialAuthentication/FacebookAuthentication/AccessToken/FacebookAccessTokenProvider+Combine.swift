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

extension FacebookAccessTokenProvider {
    
    @MainActor public func authenticatePublisher(from viewController: UIViewController) -> AnyPublisher<FacebookAccessTokenProviderResponse, Error> {
               
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
    
    public func refreshCurrentAccessTokenPublisher() -> AnyPublisher<Void, Error> {
        
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
    
    public func signOutPublisher() -> AnyPublisher<Void, Never> {
        
        signOut()
        
        return Just(())
            .eraseToAnyPublisher()
    }
}
