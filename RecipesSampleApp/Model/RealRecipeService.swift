//
//  RealRecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

protocol RecipeDBRepository {
    func fetchRatings(for recipe: Recipe) async -> [Recipe.Rating]
    func fetchAllRecipes(searchText: String) async -> [Recipe]
    func fetchRecipes(createdBy user: User, searchText: String) async -> [Recipe]
    func add(recipe: Recipe) async throws
    func add(rating: Recipe.Rating, to recipe: Recipe) async
}

class RealRecipeDBRepository: RecipeDBRepository {
    let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
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

    func add(rating: Recipe.Rating, to recipe: Recipe) async {
        
    }
}

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
