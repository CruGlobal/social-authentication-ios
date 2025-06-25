//
//  SignInWithSocialViewModel.swift
//  SocialAuthenticationExample
//
//  Created by Levi Eggert on 4/18/23.
//

import UIKit
import SocialAuthentication
import Combine

class SignInWithSocialViewModel: ObservableObject {
    
    private let socialAuthPresenter: UIViewController
    private let facebookAccessTokenProvider: FacebookAccessTokenProvider
    private let facebookLimitedLogin: FacebookLimitedLogin
    private let appleAuthentication: AppleAuthentication
    private let googleAuthentication: GoogleAuthentication
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    @Published var facebookHasPersistedAccessToken: Bool = false
    @Published var appleIsAuthenticated: Bool = false
    @Published var googleIsAuthenticated: Bool = false
    @Published var userName: String = ""
    
    init(socialAuthPresenter: UIViewController, facebookAccessTokenProvider: FacebookAccessTokenProvider, facebookLimitedLogin: FacebookLimitedLogin, appleAuthentication: AppleAuthentication, googleAuthentication: GoogleAuthentication) {
        
        self.socialAuthPresenter = socialAuthPresenter
        self.facebookAccessTokenProvider = facebookAccessTokenProvider
        self.facebookLimitedLogin = facebookLimitedLogin
        self.appleAuthentication = appleAuthentication
        self.googleAuthentication = googleAuthentication
        
        facebookAccessTokenProvider.accessTokenChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (accessToken: String?) in
                
                let accessTokenExists: Bool = !(accessToken ?? "").isEmpty
                self?.facebookHasPersistedAccessToken = accessTokenExists
            }
            .store(in: &cancellables)
        
        appleAuthentication.isAuthenticated { [weak self] isAuthenticated in
            
            self?.appleIsAuthenticated = isAuthenticated
        }
                
        googleAuthentication.restorePreviousSignIn { [weak self] (result: Result<GoogleAuthenticationResponse, Error>) in
            
            switch result {
                
            case .success(let response):
                self?.googleIsAuthenticated = response.idToken != nil
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Inputs

extension SignInWithSocialViewModel {
    
    func signInForFacebookAccessToken() {
        
        facebookAccessTokenProvider.authenticate(from: socialAuthPresenter) { [weak self] (result: Result<FacebookAccessTokenProviderResponse, Error>) in
            
            switch result {
            case .success(let response):
                print(response.accessToken ?? "x")
            case .failure(let error):
                print(error)
            }
            
            self?.userName = FacebookProfile.current?.name ?? ""
        }
    }
    
    func signInForFacebookLimitedLogin() {
        
        facebookLimitedLogin.authenticate(from: socialAuthPresenter) { [weak self] (result: Result<FacebookLimitedLoginResponse, Error>) in
            
            switch result {
            case .success(let response):
                print(response.oidcToken ?? "x")
            case .failure(let error):
                print(error)
            }
            
            self?.userName = FacebookProfile.current?.name ?? ""
        }
    }
    
    func signInWithGoogleTapped() {
        
        googleAuthentication.authenticate(from: socialAuthPresenter) { [weak self] (result: Result<GoogleAuthenticationResponse, Error>) in
            
            switch result {
                
            case .success(let response):
                self?.googleIsAuthenticated = response.idToken != nil
                
            case .failure(let error):
                print(error)
            }
            
            self?.userName = self?.googleAuthentication.getCurrentUserProfile()?.name ?? ""
        }
    }
    
    func signInWithAppleTapped() {
        
        appleAuthentication.authenticate { [weak self] (result: Result<AppleAuthenticationResponse, Error>) in
            
            switch result {
           
            case .success(let response):
                self?.userName = response.fullName?.familyName ?? ""
                
            case .failure( _):
                break
            }
        }
    }
}
