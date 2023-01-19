//
//  RecipeListViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

extension Identifiable where ID: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class RecipeListViewModel: ObservableObject {

    // MARK: Stored Properties

    @Published var title: String
    @Published var recipes = [Recipe]()

    private let recipeService: RecipeService
    private unowned let coordinator: RecipeListCoordinator

    // MARK: Initialization

    init(title: String,
         recipeService: RecipeService,
         coordinator: RecipeListCoordinator,
         filter: @escaping (Recipe) -> Bool) {
        self.title = title
        self.coordinator = coordinator
        self.recipeService = recipeService

        recipeService.fetchRecipes {
            self.recipes = $0.filter(filter)
        }
    }

    // MARK: Methods

    func open(_ recipe: Recipe) {
        self.coordinator.open(recipe)
    }

}
