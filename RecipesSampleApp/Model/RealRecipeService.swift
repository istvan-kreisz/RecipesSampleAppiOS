//
//  RealRecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

@MainActor
class RealRecipeService: RecipeService {
    
    // MARK: Methods

    func fetchRatings(for recipe: Recipe) async -> [Recipe.Rating] {
        []
    }

    func fetchAllRecipes(searchText: String) async -> [Recipe] {
        []
    }

    func fetchRecipes(createdBy user: User, searchText: String) async -> [Recipe] {
        []
    }

    func add(recipe: Recipe) async {}

    func add(rating: Recipe.Rating, to recipe: Recipe) async {}
}
