//
//  AllRecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

class AllRecipesViewModel: RecipesViewModel {
    // MARK: Stored Properties

    @Published var title: String
    @Published var recipes = [Recipe]()
    var user: User?

    private let recipeService: RecipeService
    private let openRecipe: (Recipe) -> Void

    // MARK: Initialization

    required init(title: String, recipeService: RecipeService, openRecipe: @escaping (Recipe) -> Void) {
        self.title = title
        self.openRecipe = openRecipe
        self.recipeService = recipeService
        refresh()
    }

    // MARK: Methods
    
    func refresh() {
        Task { [weak self] in
            guard self != nil else { return }
            recipes = await recipeService.fetchAllRecipes()
        }
    }

    func open(recipe: Recipe) {
        self.openRecipe(recipe)
    }
}
