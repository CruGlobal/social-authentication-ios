//
//  FacebookAuthentication+Combine.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import Combine

public extension FacebookAuthentication {
    
    func authenticatePublisher(from viewController: UIViewController) -> AnyPublisher<FacebookAuthenticationResponse, Error> {
               
        return Future() { promise in
                        
            self.authenticate(from: viewController) { (result: Result<FacebookAuthenticationResponse, Error>) in
                
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
}
