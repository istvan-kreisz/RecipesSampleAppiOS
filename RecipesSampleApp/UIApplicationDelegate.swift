//
//  UIApplicationDelegate.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/25/23.
//

import UIKit
import FirebaseCore
import Nuke

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        setupNuke()

        if DebugSettings.shared.clearUserDefaults {
            UserDefaults.standard.reset()
        }
        return true
    }
    
    private func setupNuke() {
        ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
    }
}
