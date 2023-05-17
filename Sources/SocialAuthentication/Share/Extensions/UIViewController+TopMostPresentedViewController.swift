//
//  UIViewController+TopMostPresentedViewController.swift
//  
//
//  Created by Levi Eggert on 5/17/23.
//

import UIKit

extension UIViewController {
    
    func getTopMostPresentedViewController() -> UIViewController? {
        
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
