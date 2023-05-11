//
//  GoogleAuthenticationHandleApplicationOpenUrl.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/8/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import Foundation
import GoogleSignIn

public class GoogleAuthenticationHandleApplicationOpenUrl {
    
    public static func handleUrl(url: URL) -> Bool {
        
        return GIDSignIn.sharedInstance.handle(url)
    }
}
