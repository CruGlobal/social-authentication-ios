//
//  FacebookAccessTokenProvider.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 10/8/24.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AppTrackingTransparency

public final class FacebookAccessTokenProvider: Sendable {
    
    private let facebookLogin: FacebookLogin = FacebookLogin()
    private let configuration: FacebookAccessTokenProviderConfiguration
        
    public init(configuration: FacebookAccessTokenProviderConfiguration) {
        
        self.configuration = configuration
    }

    private var trackingIsAuthorized: Bool {
        
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized:
            return true
        case .denied:
            return false
        case .notDetermined:
            return false
        case .restricted:
            return false
        default:
            return false
        }
    }
    
    private func getStatusString(status: ATTrackingManager.AuthorizationStatus) -> String {
        
        switch status {
        case .authorized:
            return "authorized"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        default:
            return "unknown status"
        }
    }
    
    public func getAccessToken() -> AccessToken? {
        
        return AccessToken.current
    }
    
    public func getUserId() -> String? {
        
        return AccessToken.current?.userID
    }
    
    public func getAccessTokenString() -> String? {
        
        return AccessToken.current?.tokenString
    }
    
    public func refreshCurrentAccessToken() async throws -> Void {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AccessToken.refreshCurrentAccessToken(completion: { (connection: GraphRequestConnecting?, result: Any?, error: Error?) in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                else {
                    continuation.resume(returning: Void())
                }
            })
        }
    }
    
    private func requestTrackingAuthorization() async -> ATTrackingManager.AuthorizationStatus {
        
        let status: ATTrackingManager.AuthorizationStatus = await ATTrackingManager.requestTrackingAuthorization()
        
        // NOTE: Delay is required before authenticating with Facebook from ViewController.
        //       Otherwise cancelled is triggered by facebook LoginResult. ~Levi
        
        do {
            
            try await Task.sleep(for: .seconds(1))
            
            return status
        }
        catch _ {
            
            return status
        }
    }
    
    @MainActor public func authenticate(
        from viewController: UIViewController
    ) async throws -> FacebookAccessTokenProviderResponse {
        
        let authenticateFromViewController: UIViewController = viewController.getTopMostPresentedViewController() ?? viewController
        
        let status: ATTrackingManager.AuthorizationStatus = await requestTrackingAuthorization()
        
        guard status == .authorized else {
            
            let statusString: String = getStatusString(status: status)
            let errorMessage = "FacebookAccessTokenProvider requires that App Tracking Transparency be authorized by the user. Current status is: \(statusString)"
            let error: Error = NSError(domain: "FacebookAccessTokenProvider", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            
            throw error
        }
        
        return try await facebookLogin.performAccessTokenLogin(
            viewController: authenticateFromViewController,
            permissions: configuration.permissions
        )
    }
    
    public func signOut() async {
        
        await facebookLogin.signOut()
    }
}
