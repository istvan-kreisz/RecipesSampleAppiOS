//
//  RecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

protocol RecipeService {
    func fetchRatings(for recipe: Recipe) async throws -> [Recipe.Rating]
    func fetchAllRecipes(searchText: String) async throws -> [Recipe]
    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe]
    func add(recipe: Recipe) async throws
    func add(rating: Recipe.Rating, to recipe: Recipe) async throws
}
