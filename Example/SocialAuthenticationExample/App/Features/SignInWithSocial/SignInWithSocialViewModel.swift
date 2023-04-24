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
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    @Published var facebookHasPersistedAccessToken: Bool = false
    
    init(socialAuthPresenter: UIViewController, facebookAuthentication: FacebookAuthentication) {
        
        self.socialAuthPresenter = socialAuthPresenter
        self.facebookAuthentication = facebookAuthentication
        
        facebookAuthentication.accessTokenChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (accessToken: String?) in
                
                let accessTokenExists: Bool = !(accessToken ?? "").isEmpty
                self?.facebookHasPersistedAccessToken = accessTokenExists
            }
            .store(in: &cancellables)
    }
}

// MARK: - Inputs

extension SignInWithSocialViewModel {
    
    func signInWithFacebookTapped() {
        
        facebookAuthentication.authenticate(from: socialAuthPresenter) { [weak self] (result: Result<FacebookAuthenticationResponse, Error>) in
                        
            print("finished")
        }
    }
    
    func signInWithGoogleTapped() {
        print("sign in with google...")
    }
    
    func signInWithAppleTapped() {
        print("sign in with apple...")
    }
}
