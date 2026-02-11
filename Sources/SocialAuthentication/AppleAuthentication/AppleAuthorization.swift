//
//  AppleAuthorization.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/1/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import AuthenticationServices

public final class AppleAuthorization: NSObject {
    
    public typealias AppleAuthenticationCompletion = ((_ result: Result<AppleAuthenticationResponse, Error>) -> Void)
    
    private var completionBlock: AppleAuthenticationCompletion?
    
    public func authenticate(requestScopes: [ASAuthorization.Scope], completion: @escaping AppleAuthenticationCompletion) {
        
        self.completionBlock = completion
        
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = requestScopes
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthorization: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        guard let completion = completionBlock else {
            return
        }
        
        let errorCode: Int = (error as NSError).code
        
        if errorCode == ASAuthorizationError.canceled.rawValue || errorCode == ASAuthorizationError.unknown.rawValue {
            
            completion(.success(AppleAuthenticationResponse.userCancelledResponse()))
        }
        else {
            
            completion(.failure(error))
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let completion = completionBlock else {
            return
        }
        
        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            
            completion(.failure(AppleAuthenticationError.noAuthCredential))
            return
        }
        
        let email = appleIdCredential.email
        let fullName = appleIdCredential.fullName
        let userId = appleIdCredential.user
        
        let response = AppleAuthenticationResponse(
            authorizationCode: appleIdCredential.getAuthorizationCodeString(),
            email: email,
            fullName: fullName,
            identityToken: appleIdCredential.getIdentityTokenString(),
            isCancelled: false,
            userId: userId,
            persistUserIdStatus: nil
        )
        
        completion(.success(response))
    }
}
