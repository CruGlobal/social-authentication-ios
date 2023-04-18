//
//  SignInWithSocialViewModel.swift
//  SocialAuthenticationExample
//
//  Created by Levi Eggert on 4/18/23.
//

import Foundation

class SignInWithSocialViewModel: ObservableObject {
    
    init() {
        
    }
}

// MARK: - Inputs

extension SignInWithSocialViewModel {
    
    func signInWithFacebookTapped() {
        print("sign in with facebook...")
    }
    
    func signInWithGoogleTapped() {
        print("sign in with google...")
    }
    
    func signInWithAppleTapped() {
        print("sign in with apple...")
    }
}
