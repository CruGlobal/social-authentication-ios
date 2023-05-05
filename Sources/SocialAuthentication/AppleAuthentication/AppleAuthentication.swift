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
    
    public func isAuthenticated(completion: @escaping ((_ isAuthenticated: Bool) -> Void)) {
        
        guard let userId = getUserId() else {
            completion(false)
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userId) { (credentialState, error) in
            
            switch credentialState {
            
            case .authorized:
                completion(true)
                
            case .revoked, .notFound, .transferred:
                completion(false)
            
            @unknown default:
                completion(false)
            }
        }
    }
}

// MARK: - UserId

extension AppleAuthentication {
    
    public func getUserId() -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "appleAuthentication",
            kSecAttrAccount as String: "userId",
            kSecReturnData as String: true
        ] as CFDictionary
        
        var getResult: AnyObject?
        let status = SecItemCopyMatching(query, &getResult)
        
        if status == errSecSuccess {
            
            guard let resultData = getResult as? Data else { return nil }
            return String(data: resultData, encoding: .utf8)
            
        } else {
            return nil
        }
    }
    
    private func storeUserId(_ userId: String?) {
        guard let userId = userId else { return }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "appleAuthentication",
            kSecAttrAccount as String: "userId",
            kSecValueData as String: Data(userId.utf8)
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecSuccess {
           print("success")
            
        } else if status == errSecDuplicateItem {
            print("duplicate exists")
            
        } else {
            
            let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status))
            
            assertionFailure("error storing userId in keychain: \(error.code)")
        }
    }
}

extension AppleAuthentication: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        guard let completion = completionBlock else { return }
        
        completion(.failure(error))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let completion = completionBlock else { return }
        
        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            
            completion(.failure(AppleAuthenticationError.noAuthCredential))
            return
        }
        
        let response = AppleAuthenticationResponse(
            authorizationCode: appleIdCredential.authorizationCode?.base64EncodedString(),
            email: appleIdCredential.email,
            identityToken: appleIdCredential.identityToken?.base64EncodedString(),
            userId: appleIdCredential.user
        )
        
        completion(.success(response))
        
        storeUserId(appleIdCredential.user)
    }
    
}
