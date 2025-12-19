//
//  FacebookLimitedLogin+Combine.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 6/25/25.
//  Copyright © 2025 Cru Global, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Combine

extension FacebookLimitedLogin {
    
    @MainActor public func authenticatePublisher(from viewController: UIViewController) -> AnyPublisher<FacebookLimitedLoginResponse, Error> {
               
        return Future() { promise in
                        
            self.authenticate(from: viewController) { (result: Result<FacebookLimitedLoginResponse, Error>) in
                
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
