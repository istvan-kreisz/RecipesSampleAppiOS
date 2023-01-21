//
//  UserRecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/20/23.
//

import SwiftUI

class UserRecipesViewModel: RecipesViewModel {
    // MARK: Stored Properties

    @Published var title: String
    @Published var recipes = [Recipe]()
    var user: User? {
        didSet {
            guard let user = user else { return }
            Task {
                let recipes = await recipeService.fetchRecipes(createdBy: user)
                self.recipes = recipes
            }
        }
    }

    private let recipeService: RecipeService
    private let openRecipe: (Recipe) -> Void

    // MARK: Initialization

    required init(title: String,
                  recipeService: RecipeService,
                  openRecipe: @escaping (Recipe) -> Void) {
        self.title = title
        self.openRecipe = openRecipe
        self.recipeService = recipeService
    }

    // MARK: Methods
    
    func open(recipe: Recipe) {
        self.openRecipe(recipe)
    }
}
