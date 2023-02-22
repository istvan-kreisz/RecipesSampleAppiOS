//
//  RealRecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

class RealRecipeService: RecipeService {
    enum RecipeServiceError: Error {
        case noConnection
    }
    
    let recipeDBRepository: RecipeDBRepository
    let recipeWebRepository: RecipeWebRepository
    let networkMonitor: NetworkMonitor

    init(recipeDBRepository: RecipeDBRepository, recipeWebRepository: RecipeWebRepository, networkMonitor: NetworkMonitor) {
        self.recipeDBRepository = recipeDBRepository
        self.recipeWebRepository = recipeWebRepository
        self.networkMonitor = networkMonitor
        self.networkMonitor.startMonitoring()
    }
    
    deinit {
        self.networkMonitor.stopMonitoring()
    }

    func fetchRatings(for recipe: Recipe) async throws -> [Rating] {
        if networkMonitor.isReachable {
            let ratings = try await recipeWebRepository.fetchRatings(for: recipe)
            await saveUnsavedRatings(ratingsFromWeb: ratings, recipe: recipe)
            return ratings
        } else {
            return try await recipeDBRepository.fetchRatings(for: recipe)
        }
    }

    func fetchAllRecipes(searchText: String) async throws -> [Recipe] {
        if networkMonitor.isReachable {
            let recipes = try await recipeWebRepository.fetchAllRecipes(searchText: searchText)
            await saveUnsavedRecipes(recipes: recipes)
            return recipes
        } else {
            return try await recipeDBRepository.fetchAllRecipes(searchText: searchText)
        }
    }

    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe] {
        if networkMonitor.isReachable {
            let recipes = try await recipeWebRepository.fetchRecipes(createdBy: user, searchText: searchText)
            await saveUnsavedRecipes(recipes: recipes)
            return recipes
        } else {
            return try await recipeDBRepository.fetchRecipes(createdBy: user, searchText: searchText)
        }
    }

    func add(recipe: Recipe) async throws {
        if networkMonitor.isReachable {
            try await recipeWebRepository.add(recipe: recipe)
        } else {
            throw RecipeServiceError.noConnection
        }
    }

    func add(rating: Rating, to recipe: Recipe) async throws {
        if networkMonitor.isReachable {
            try await recipeWebRepository.add(rating: rating, to: recipe)
        } else {
            throw RecipeServiceError.noConnection
        }
    }

    private func saveUnsavedRatings(ratingsFromWeb: [Rating], recipe: Recipe) async {
        guard let storedRatingIds = try? await recipeDBRepository.fetchRatingIds(for: recipe) else { return }
        let ratingsNotStored = ratingsFromWeb.filter { !storedRatingIds.contains($0.id) }
        for ratingNotStored in ratingsNotStored {
            try? await recipeDBRepository.add(rating: ratingNotStored, to: recipe)
        }
    }

    private func saveUnsavedRecipes(recipes: [Recipe]) async {
        guard let storedRecipeIds = try? await recipeDBRepository.fetchAllRecipeIds() else { return }
        let recipesNotStored = recipes.filter { !storedRecipeIds.contains($0.id) }
        for recipeNotStored in recipesNotStored {
            try? await recipeDBRepository.add(recipe: recipeNotStored)
        }
    }
}
