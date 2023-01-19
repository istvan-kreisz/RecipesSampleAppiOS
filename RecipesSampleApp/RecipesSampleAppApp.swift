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
    @StateObject var coordinator = HomeCoordinator(recipeService: MockRecipeService())

    // MARK: Scenes
    var body: some Scene {
        WindowGroup {
            HomeCoordinatorView(coordinator: coordinator)
        }
    }
}
