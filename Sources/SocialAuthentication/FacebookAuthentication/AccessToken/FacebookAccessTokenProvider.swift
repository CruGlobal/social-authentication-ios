//
//  FacebookAccessTokenProvider.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 10/8/24.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Combine
import AppTrackingTransparency

public class FacebookAccessTokenProvider: NSObject {
    
    private let loginManager: LoginManager = LoginManager()
    private let configuration: FacebookAccessTokenProviderConfiguration
    private let accessTokenChanged: CurrentValueSubject<String?, Never>
        
    public init(configuration: FacebookAccessTokenProviderConfiguration) {
        
        self.configuration = configuration
        self.accessTokenChanged = CurrentValueSubject(AccessToken.current?.tokenString)
        
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessTokenDidChange(notification:)),
            name: .AccessTokenDidChange,
            object: nil
        )
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: .AccessTokenDidChange, object: nil)
    }
    
    public func getLoginManager() -> LoginManager {
        return loginManager
    }
    
    public var accessTokenChangedPublisher: AnyPublisher<String?, Never> {
        return accessTokenChanged
            .eraseToAnyPublisher()
    }
    
    @objc private func accessTokenDidChange(notification: Notification) {
                
        accessTokenChanged.send(AccessToken.current?.tokenString)
    }
}

// MARK: - Authentication

extension FacebookAccessTokenProvider {
    
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
    
    private func requestTrackingAuthorization(completion: @escaping ((_ status: ATTrackingManager.AuthorizationStatus) -> Void)) {
        
        // NOTE: Delay is required before authenticating with Facebook from ViewController.
        //       Otherwise cancelled is triggered by facebook LoginResult. ~Levi
        
        ATTrackingManager.requestTrackingAuthorization { (status: ATTrackingManager.AuthorizationStatus) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(status)
            }
        }
    }
    
    public func authenticate(from viewController: UIViewController, completion: @escaping ((_ result: Result<FacebookAccessTokenProviderResponse, Error>) -> Void)) {
        
        let authenticateFromViewController: UIViewController = viewController.getTopMostPresentedViewController() ?? viewController
        
        let loginConfiguration = LoginConfiguration(permissions: configuration.permissions, tracking: .enabled)
        
        requestTrackingAuthorization { [weak self] (status: ATTrackingManager.AuthorizationStatus) in
            
            guard let weakSelf = self else {
                return
            }
            
            guard status == .authorized else {
                
                let statusString: String = weakSelf.getStatusString(status: status)
                let errorMessage = "FacebookAccessTokenProvider requires that App Tracking Transparency be authorized by the user. Current status is: \(statusString)"
                let error: Error = NSError(domain: "FacebookAccessTokenProvider", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])

                completion(.failure(error))
                
                return
            }
            
            weakSelf.loginManager.logIn(viewController: authenticateFromViewController, configuration: loginConfiguration) { (result: LoginResult)  in
                
                switch result {
                
                case .success( _, _, let token):
                    
                    let accessToken: String? = token?.tokenString
                    let userId: String? = AccessToken.current?.userID

                    completion(.success(FacebookAccessTokenProviderResponse(accessToken: accessToken, isCancelled: false, userId: userId)))
                
                case .cancelled:
                    completion(.success(FacebookAccessTokenProviderResponse(accessToken: nil, isCancelled: true, userId: nil)))
                
                case .failed(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Access Token

extension FacebookAccessTokenProvider {
    
    public func getAccessToken() -> AccessToken? {
        
        return AccessToken.current
    }
    
    public func getUserId() -> String? {
        
        return AccessToken.current?.userID
    }
    
    public func getAccessTokenString() -> String? {
        
        return AccessToken.current?.tokenString
    }
    
    public func refreshCurrentAccessToken(completion: @escaping ((_ result: Result<Void, Error>) -> Void)) {
        
        AccessToken.refreshCurrentAccessToken(completion: { (connection: GraphRequestConnecting?, result: Any?, error: Error?) in
            
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(()))
            }
        })
    }
}

// MARK: - Sign Out

extension FacebookAccessTokenProvider {
    
    public func signOut() {
        
        loginManager.logOut()
    }
}

// MARK: - User

extension FacebookAccessTokenProvider {
    
    public func getCurrentUserProfile() -> Profile? {
        return Profile.current
    }
    
    public func loadUserProfile(completion: @escaping ((_ profile: Profile?, _ error: Error?) -> Void)) {
        
        Profile.loadCurrentProfile(completion: completion)
    }
}
