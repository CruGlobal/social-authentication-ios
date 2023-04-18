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
        
        VStack(alignment: .center, spacing: 0) {
            
            Text("Sign-in With Social")
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 50, leading: 30, bottom: 0, trailing: 30))
            
            Spacer()
        }
    }
}
