//
//  RecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

protocol RecipeService {
    func fetchRatings(for recipe: Recipe, loadMore: Bool) async throws -> PaginatedResult<[Rating]>
    func fetchAllRecipes(searchText: String, loadMore: Bool) async throws -> PaginatedResult<[Recipe]>
    func fetchRecipes(createdBy user: User, searchText: String, loadMore: Bool) async throws -> PaginatedResult<[Recipe]>
    func add(recipe: Recipe) async throws
    func add(rating: Rating, to recipe: Recipe) async throws
}
