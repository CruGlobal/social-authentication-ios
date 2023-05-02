//
//  AppleAuthentication.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/1/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

public class AppleAuthentication: NSObject {
    
    public typealias AppleAuthenticationCompletion = ((_ result: Result<AppleAuthenticationResponse, Error>) -> Void)
    
    private var completionBlock: AppleAuthenticationCompletion?
    
}

// MARK: - Authentication

extension AppleAuthentication {
    
    public func authenticate(completion: @escaping AppleAuthenticationCompletion) {
        self.completionBlock = completion
        
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
        
    }
}

extension AppleAuthentication: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        guard let completion = completionBlock else { return }
        
        completion(.failure(error))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let token = appleIdCredential.identityToken?.base64EncodedString() else { return }
        guard let userId = appleIdCredential.email else { return }
        
        guard let completion = completionBlock else { return }
        
        let response = AppleAuthenticationResponse(accessToken: token, userId: userId)
        
        completion(.success(response))
    }
    
}
