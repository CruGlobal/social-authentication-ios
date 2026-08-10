//
//  SignInWithSocialViewModel.swift
//  SocialAuthenticationExample
//
//  Created by Levi Eggert on 4/18/23.
//

import UIKit
import SocialAuthentication

@MainActor
final class SignInWithSocialViewModel: ObservableObject {
    
    private let socialAuthPresenter: UIViewController
    private let facebookAccessTokenProvider: FacebookAccessTokenProvider
    private let facebookLimitedLogin: FacebookLimitedLogin
    private let appleAuthentication: AppleAuthentication
    private let googleAuthentication: GoogleAuthentication
        
    @Published private(set) var facebookHasPersistedAccessToken: Bool = false
    @Published private(set) var appleIsAuthenticated: Bool = false
    @Published private(set) var googleIsAuthenticated: Bool = false
    @Published private(set) var userName: String = ""
    
    init(
        socialAuthPresenter: UIViewController,
        facebookAccessTokenProvider: FacebookAccessTokenProvider,
        facebookLimitedLogin: FacebookLimitedLogin,
        appleAuthentication: AppleAuthentication,
        googleAuthentication: GoogleAuthentication
    ) {
        
        self.socialAuthPresenter = socialAuthPresenter
        self.facebookAccessTokenProvider = facebookAccessTokenProvider
        self.facebookLimitedLogin = facebookLimitedLogin
        self.appleAuthentication = appleAuthentication
        self.googleAuthentication = googleAuthentication
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessTokenDidChange(notification:)),
            name: .AccessTokenDidChange,
            object: nil
        )
        
        Task {
            appleIsAuthenticated = try await appleAuthentication.getIsAuthenticated()
        }
        
        Task {
            let response = try await googleAuthentication.restorePreviousSignIn()
            googleIsAuthenticated = response.idToken != nil
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: .AccessTokenDidChange, object: nil)
    }
    
    @objc private func accessTokenDidChange(notification: Notification) {
        
        if notification.name == .AccessTokenDidChange {
            
            let accessToken: String? = facebookAccessTokenProvider.getAccessTokenString()
            let accessTokenExists: Bool = !(accessToken ?? "").isEmpty
            facebookHasPersistedAccessToken = accessTokenExists
        }
    }
}

// MARK: - Inputs

extension SignInWithSocialViewModel {
    
    func signInForFacebookAccessToken() {
        
        Task {
            do {
                let response = try await facebookAccessTokenProvider.authenticate(from: socialAuthPresenter)
                print(response.accessToken ?? "x")
                userName = LoadFacebookProfile.current?.name ?? ""
            }
            catch let error {
                print("\n Facebook Access Token login error: \(error)")
            }
        }
    }
    
    func signInForFacebookLimitedLogin() {
        
        Task {
            do {
                let response = try await facebookLimitedLogin.authenticate(from: socialAuthPresenter)
                print(response.oidcToken ?? "x")
                userName = LoadFacebookProfile.current?.name ?? ""
            }
            catch let error {
                print("\n Facebook Limited login error: \(error)")
            }
        }
    }
    
    func signInWithGoogleTapped() {
        
        Task {
            do {
                let response = try await googleAuthentication.authenticate(from: socialAuthPresenter)
                googleIsAuthenticated = response.idToken != nil
                userName = googleAuthentication.getCurrentUserProfile()?.name ?? ""
            }
            catch let error {
                print("\n Google sign-in error: \(error)")
            }
        }
    }
    
    func signInWithAppleTapped() {
        
        Task {
            do {
                let response = try await appleAuthentication.authenticate()
                userName = response.fullName?.familyName ?? ""
                appleIsAuthenticated = true
            }
            catch let error {
                print("\n Apple sign-in error: \(error)")
            }
        }
    }
}
