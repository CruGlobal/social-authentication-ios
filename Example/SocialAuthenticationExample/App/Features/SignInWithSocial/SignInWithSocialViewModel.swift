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
    private let facebookAuthentication: FacebookAuthentication
    private let appleAuthentication: AppleAuthentication
    private let googleAuthentication: GoogleAuthentication
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    @Published var facebookHasPersistedAccessToken: Bool = false
    @Published var appleIsAuthenticated: Bool = false
    @Published var googleIsAuthenticated: Bool = false
    
    init(socialAuthPresenter: UIViewController, facebookAuthentication: FacebookAuthentication, appleAuthentication: AppleAuthentication, googleAuthentication: GoogleAuthentication) {
        
        self.socialAuthPresenter = socialAuthPresenter
        self.facebookAuthentication = facebookAuthentication
        self.appleAuthentication = appleAuthentication
        self.googleAuthentication = googleAuthentication
        
        facebookAuthentication.accessTokenChangedPublisher
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
    
    func signInWithFacebookTapped() {
        
        facebookAuthentication.authenticate(from: socialAuthPresenter) { (result: Result<FacebookAuthenticationResponse, Error>) in
                        
            print("finished")
        }
    }
    
    func signInWithGoogleTapped() {
        
        googleAuthentication.authenticate(from: socialAuthPresenter) { (result: Result<GoogleAuthenticationResponse, Error>) in
            
            switch result {
                
            case .success(let response):
                break
                
            case .failure(let error):
                break
            }
        }
    }
    
    func signInWithAppleTapped() {
        
        appleAuthentication.authenticate { _ in
            
            print("finished")
        }
    }
}
