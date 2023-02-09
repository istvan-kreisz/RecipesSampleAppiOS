//
//  UserRecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/20/23.
//

import SwiftUI

class UserRecipesViewModel: RecipesViewModel {
    @Published var title: String
    @Published var recipes = [Recipe]()
    var user: User? {
        didSet {
            refresh()
        }
    }

    private let recipeService: RecipeService
    private let openRecipe: (Recipe) -> Void

    required init(title: String,
                  recipeService: RecipeService,
                  openRecipe: @escaping (Recipe) -> Void) {
        self.title = title
        self.openRecipe = openRecipe
        self.recipeService = recipeService
    }
    
    func refresh(searchText: String) {
        guard let user = user else { return }
        Task {
            do {
                let recipes = try await recipeService.fetchRecipes(createdBy: user, searchText: searchText)
                self.recipes = recipes
            } catch {
                // todo: show error
            }
        }
    }
    
    func open(recipe: Recipe) {
        self.openRecipe(recipe)
    }
}
