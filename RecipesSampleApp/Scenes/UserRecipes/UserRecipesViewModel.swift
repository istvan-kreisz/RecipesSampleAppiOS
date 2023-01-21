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
            refresh()
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
    
    func refresh(searchText: String) {
        guard let user = user else { return }
        Task {
            let recipes = await recipeService.fetchRecipes(createdBy: user, searchText: searchText)
            self.recipes = recipes
        }
    }
    
    func open(recipe: Recipe) {
        self.openRecipe(recipe)
    }
}
