//
//  RecipesSampleAppApp.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

@main
struct RecipesSampleAppApp: App {
    // MARK: Stored Properties

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #warning("refactor")
    @StateObject var coordinator = HomeCoordinator(recipeService: AppEnvironment.shared.recipeService)

    // MARK: Scenes

    var body: some Scene {
        WindowGroup {
            HomeCoordinatorView(coordinator: coordinator)
        }
    }
}
