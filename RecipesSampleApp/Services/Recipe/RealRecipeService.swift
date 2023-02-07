//
//  RealRecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

class RealRecipeService: RecipeService {
    // MARK: Methods

    let recipeDBRepository: RecipeDBRepository
    let recipeWebRepository: RecipeWebRepository

    init(recipeDBRepository: RecipeDBRepository, recipeWebRepository: RecipeWebRepository) {
        self.recipeDBRepository = recipeDBRepository
        self.recipeWebRepository = recipeWebRepository
    }

    func fetchRatings(for recipe: Recipe) async throws -> [Recipe.Rating] {
        try await recipeWebRepository.fetchRatings(for: recipe)
//        try await recipeDBRepository.fetchRatings(for: recipe)
    }

    func fetchAllRecipes(searchText: String) async throws -> [Recipe] {
        try await recipeWebRepository.fetchAllRecipes(searchText: searchText)
//        try await recipeDBRepository.fetchAllRecipes(searchText: searchText)
    }

    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe] {
        try await recipeWebRepository.fetchRecipes(createdBy: user, searchText: searchText)
//        try await recipeDBRepository.fetchRecipes(createdBy: user, searchText: searchText)
    }

    func add(recipe: Recipe) async throws {
        try await recipeWebRepository.add(recipe: recipe)
//        try await recipeDBRepository.add(recipe: recipe)
    }

    func add(rating: Recipe.Rating, to recipe: Recipe) async throws {
        try await recipeWebRepository.add(rating: rating, to: recipe)
//        try await recipeDBRepository.add(rating: rating, to: recipe)
    }
}
