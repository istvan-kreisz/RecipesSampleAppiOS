//
//  RecipesSampleAppApp.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

@main
struct RecipesSampleAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var coordinator = HomeCoordinator(recipeService: AppEnvironment.shared.recipeService,
                                                   authService: AppEnvironment.shared.authService)

    var body: some Scene {
        WindowGroup {
            HomeCoordinatorView(coordinator: coordinator)
        }
    }
}
