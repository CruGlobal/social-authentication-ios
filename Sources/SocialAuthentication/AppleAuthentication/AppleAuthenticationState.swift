//
//  AppleAuthenticationState.swift
//  SocialAuthentication
//
//  Created by Rachael Skeath on 5/5/23.
//

import Foundation
import AuthenticationServices

public enum AppleAuthenticationState {
    
    case authorized
    case revoked
    case notFound
    case transferred
    case unknown
    
    public init(credentialState: ASAuthorizationAppleIDProvider.CredentialState) {
        
        switch credentialState {
        case .authorized:   self = .authorized
        case .revoked:      self = .revoked
        case .notFound:     self = .notFound
        case .transferred:  self = .transferred
        @unknown default:   self = .unknown
        }
    }
}
