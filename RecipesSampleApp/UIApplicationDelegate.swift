//
//  UIApplicationDelegate.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/25/23.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        if DebugSettings.shared.clearUserDefaults {
            UserDefaults.standard.reset()
        }
        return true
    }
}
