//
//  SocialSignInStatusView.swift
//  SocialAuthenticationExample
//
//  Created by Levi Eggert on 5/8/23.
//

import SwiftUI

struct SocialSignInStatusView: View {
    
    let title: String
    let isSuccessStatus: Bool
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 10) {
            
            Text(title)
                .font(Font.system(size: 17))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.leading)
            
            Rectangle()
                .fill(isSuccessStatus ? Color.green : Color.red)
                .frame(width: 15, height: 15)
        }
        .padding(EdgeInsets(top: 40, leading: 30, bottom: 0, trailing: 30))
    }
}
