//
//  SocialSignInButtonsView.swift
//  SocialAuthenticationExample
//
//  Created by Levi Eggert on 5/8/23.
//

import SwiftUI

struct SocialSignInButtonsView: View {
    
    private let buttonFont: Font = Font.system(size: 16, weight: .semibold)
    private let buttonWidth: CGFloat
    private let buttonHeight: CGFloat = 50
    private let buttonInsets: EdgeInsets = EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
    private let buttonCornerRadius: CGFloat = 8
    
    @ObservedObject private var viewModel: SignInWithSocialViewModel
    
    init(viewModel: SignInWithSocialViewModel, geometry: GeometryProxy) {
        
        self.viewModel = viewModel
        self.buttonWidth = geometry.size.width - buttonInsets.leading - buttonInsets.trailing
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Button(action: {
                
                viewModel.signInForFacebookAccessToken()
                
            }) {
                
                ZStack(alignment: .center) {
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .cornerRadius(buttonCornerRadius)
                    
                    Text("Facebook Access Token Login")
                        .font(buttonFont)
                        .foregroundColor(Color.white)
                        .padding()
                }
            }
            .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
            .background(Color.gray)
            .cornerRadius(buttonCornerRadius)
            .padding(buttonInsets)
            
            Button(action: {
                
                viewModel.signInForFacebookLimitedLogin()
                
            }) {
                
                ZStack(alignment: .center) {
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .cornerRadius(buttonCornerRadius)
                    
                    Text("Facebook Limited Login")
                        .font(buttonFont)
                        .foregroundColor(Color.white)
                        .padding()
                }
            }
            .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
            .background(Color.gray)
            .cornerRadius(buttonCornerRadius)
            .padding(buttonInsets)
            
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
        }
    }
}
