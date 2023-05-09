//
//  SignInView.swift
//  SocialAuthenticationExample
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import SwiftUI

struct SignInWithSocialView: View {
    
    @ObservedObject private var viewModel: SignInWithSocialViewModel
    
    init(viewModel: SignInWithSocialViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
                
            VStack(alignment: .center, spacing: 0) {
                
                Text("Sign-in With Social")
                    .font(Font.system(size: 19))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 50, leading: 30, bottom: 0, trailing: 30))
                
                SocialSignInStatusView(
                    title: "Facebook has persisted access token: ",
                    isSuccessStatus: viewModel.facebookHasPersistedAccessToken
                )
                
                SocialSignInStatusView(
                    title: "Apple is authenticated: ",
                    isSuccessStatus: viewModel.appleIsAuthenticated
                )
                
                SocialSignInStatusView(
                    title: "Google is authenticated: ",
                    isSuccessStatus: viewModel.googleIsAuthenticated
                )
                
                Spacer()
                
                SocialSignInButtonsView(viewModel: viewModel, geometry: geometry)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
            }
        }
    }
}
