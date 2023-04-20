//
//  AppDelegate.swift
//  SocialAuthenticationExample
//
//  Created by Levi Eggert on 04/18/23.
//  Copyright © 2023 Cru Global, Inc. All rights reserved.
//

import UIKit
import SwiftUI
import SocialAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let navigationController: UINavigationController = UINavigationController()
        
    private lazy var facebookConfiguration: FacebookConfiguration = {
        
        return FacebookConfiguration(
            appId: "2236701616451487",
            clientToken: "3b6bf5b7c128a970337c4fa1860ffa6e",
            displayName: "GodTools",
            isAutoLogAppEventsEnabled: false,
            isAdvertiserTrackingEnabled: false,
            isAdvertiserIDCollectionEnabled: false,
            isSKAdNetworkReportEnabled: false
        )
    }()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let viewModel = SignInWithSocialViewModel(
            socialAuthPresenter: navigationController,
            facebookAuthentication: FacebookAuthentication(
                configuration: FacebookAuthenticationConfiguration(
                    permissions: ["email"]
                )
            )
        )
        
        let view = SignInWithSocialView(viewModel: viewModel)
        
        let hostingView: UIHostingController<SignInWithSocialView> = UIHostingController(rootView: view)
        hostingView.view.backgroundColor = UIColor.white
        
        navigationController.setViewControllers([hostingView], animated: false)
        navigationController.modalPresentationStyle = .fullScreen
        
        // window
        let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        // Facebook
        ConfigureFacebookOnAppLaunch.configure(
            application: application,
            launchOptions: launchOptions,
            configuration: facebookConfiguration
        )
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
}

