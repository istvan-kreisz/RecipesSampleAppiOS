//
//  RecipeViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

class RecipeViewModel: ObservableObject, Identifiable {

    // MARK: Stored Properties

    @Published var recipe: Recipe

    private unowned let coordinator: RecipeListCoordinator

    // MARK: Initialization

    init(recipe: Recipe, coordinator: RecipeListCoordinator) {
        self.coordinator = coordinator
        self.recipe = recipe
    }

    // MARK: Methods

    func openRatings() {
        self.coordinator.openRatings(for: recipe)
    }

    func open(_ url: URL) {
        self.coordinator.open(url)
    }

}
