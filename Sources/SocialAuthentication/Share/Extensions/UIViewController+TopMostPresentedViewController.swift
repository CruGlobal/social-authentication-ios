//
//  UIViewController+TopMostPresentedViewController.swift
//  SocialAuthentication
//
//  Created by Levi Eggert on 5/17/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func getTopMostPresentedViewController() -> UIViewController? {
        
        var nextTopMostPresentedViewController: UIViewController? = self
        var topMostPresentedViewController: UIViewController?
        
        while nextTopMostPresentedViewController != nil {
            
            nextTopMostPresentedViewController = nextTopMostPresentedViewController?.presentedViewController
            
            if nextTopMostPresentedViewController != nil {
                topMostPresentedViewController = nextTopMostPresentedViewController
            }
        }
        
        return topMostPresentedViewController
    }
}
