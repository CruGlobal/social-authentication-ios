//
//  AppleAuthentication.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/1/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import AuthenticationServices

public class AppleAuthentication: NSObject {
    
    private var viewController: UIViewController?
    
}

// MARK: - Authentication

extension AppleAuthentication {
    
    public func authenticate(from viewController: UIViewController) {
        
        self.viewController = viewController
        
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
    }
}

extension AppleAuthentication: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print("failure")
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        // TODO: - something with authorization object
        print("success")
    }
    
}

extension AppleAuthentication: ASAuthorizationControllerPresentationContextProviding {
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return viewController!.view.window!
    }
}
