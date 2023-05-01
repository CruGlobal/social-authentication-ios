//
//  SignInView.swift
//  SocialAuthenticationExample
//
//  Created by Levi Eggert on 4/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import SwiftUI

struct SignInWithSocialView: View {
    
    private let buttonFont: Font = Font.system(size: 16, weight: .semibold)
    private let buttonHeight: CGFloat = 50
    private let buttonInsets: EdgeInsets = EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
    private let buttonCornerRadius: CGFloat = 8
    
    @ObservedObject private var viewModel: SignInWithSocialViewModel
    
    init(viewModel: SignInWithSocialViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let buttonWidth: CGFloat = geometry.size.width - buttonInsets.leading - buttonInsets.trailing
            
            VStack(alignment: .center, spacing: 0) {
                
                Text("Sign-in With Social")
                    .font(Font.system(size: 19))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 50, leading: 30, bottom: 0, trailing: 30))
                
                HStack(alignment: .center, spacing: 10) {
                    
                    Text("Facebook has persisted access token: ")
                        .font(Font.system(size: 17))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                    
                    Rectangle()
                        .fill(viewModel.facebookHasPersistedAccessToken ? Color.green : Color.red)
                        .frame(width: 15, height: 15)
                }
                .padding(EdgeInsets(top: 40, leading: 30, bottom: 0, trailing: 30))
                
                
                
                Spacer()
                
                Button(action: {
                    
                    viewModel.signInWithFacebookTapped()
                    
                }) {
                    
                    ZStack(alignment: .center) {
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .cornerRadius(buttonCornerRadius)
                        
                        Text("Login with Facebook")
                            .font(buttonFont)
                            .foregroundColor(Color.white)
                            .padding()
                    }
                }
                .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
                .background(Color.gray)
                .cornerRadius(buttonCornerRadius)
                .padding(buttonInsets)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 1, height: 15)
                
                Button(action: {
                    
                    viewModel.signInWithGoogleTapped()
                    
                }) {
                    
                    ZStack(alignment: .center) {
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .cornerRadius(buttonCornerRadius)
                        
                        Text("Sign in with Google")
                            .font(buttonFont)
                            .foregroundColor(Color.white)
                            .padding()
                    }
                }
                .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
                .background(Color.gray)
                .cornerRadius(buttonCornerRadius)
                .padding(buttonInsets)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 1, height: 15)
                
                Button(action: {
                    
                    viewModel.signInWithAppleTapped()
                    
                }) {
                    
                    ZStack(alignment: .center) {
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .cornerRadius(buttonCornerRadius)
                        
                        Text("Continue with Apple")
                            .font(buttonFont)
                            .foregroundColor(Color.white)
                            .padding()
                    }
                }
                .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
                .background(Color.gray)
                .cornerRadius(buttonCornerRadius)
                .padding(buttonInsets)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 1, height: 40)
            }
        }
    }
}
