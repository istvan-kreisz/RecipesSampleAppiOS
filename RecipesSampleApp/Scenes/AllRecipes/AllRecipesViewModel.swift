//
//  AllRecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

@MainActor
class AllRecipesViewModel: RecipesViewModel {
    @Published var title: String
    @Published var recipes = [Recipe]()

    private let recipeService: RecipeService
    private let openRecipe: (Recipe) -> Void

    required init(title: String, recipeService: RecipeService, openRecipe: @escaping (Recipe) -> Void) {
        self.title = title
        self.openRecipe = openRecipe
        self.recipeService = recipeService
        refresh(searchText: "")
    }
    
    func refresh(searchText: String) {
        Task { [weak self] in
            guard self != nil else { return }
            do {
                recipes = try await recipeService.fetchAllRecipes(searchText: searchText)
            } catch {
                // todo: show error
            }
        }
    }

    func open(recipe: Recipe) {
        self.openRecipe(recipe)
    }
}
