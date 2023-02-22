//
//  RecipeWebRepository.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/25/23.
//

import Foundation

protocol RecipeWebRepository: WebRepository {
    func fetchRatings(for recipe: Recipe) async throws -> [Rating]
    func fetchAllRecipes(searchText: String) async throws -> [Recipe]
    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe]
    func add(recipe: Recipe) async throws
    func add(rating: Rating, to recipe: Recipe) async throws
}
