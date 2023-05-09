//
//  GoogleAuthentication+Combine.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/8/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import Combine
import GoogleSignIn

public extension GoogleAuthentication {
    
    func authenticatePublisher(from viewController: UIViewController) -> AnyPublisher<GoogleAuthenticationResponse, Error> {
               
        return Future() { promise in
                        
            self.authenticate(from: viewController) { (result: Result<GoogleAuthenticationResponse, Error>) in
                
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
    
    func restorePreviousSignIn() -> AnyPublisher<GoogleAuthenticationResponse, Error> {
        
        return Future() { promise in
                  
            self.restorePreviousSignIn { (result: Result<GoogleAuthenticationResponse, Error>) in
                
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
    
    func refreshCurrentUserTokensPublisher() -> AnyPublisher<GoogleAuthenticationResponse, Error> {
        
        return Future() { promise in
                        
            self.refreshCurrentUserTokens() { (result: Result<GoogleAuthenticationResponse, Error>) in
                
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
}
