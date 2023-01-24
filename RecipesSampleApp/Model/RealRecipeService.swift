//
//  RealRecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

protocol RecipeDBRepository {
    func fetchRatings(for recipe: Recipe) async throws -> [Recipe.Rating]
    func fetchAllRecipes(searchText: String) async throws -> [Recipe]
    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe]
    func add(recipe: Recipe) async throws
    func add(rating: Recipe.Rating, to recipe: Recipe) async throws
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

    private func searchTextPredicate(searchText: String) -> NSPredicate? {
        guard !searchText.isEmpty else { return nil }
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText.lowercased())
        return predicate
    }

    func fetchAllRecipes(searchText: String) async throws -> [Recipe] {
        let fetchRequest = RecipeObject.fetchRequest()
        fetchRequest.includesSubentities = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RecipeObject.dateAdded, ascending: false)]
        fetchRequest.predicate = searchTextPredicate(searchText: searchText)
        let result = try await persistentStore.fetch(fetchRequest) { Recipe(from: $0) }
        return result
    }

    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe] {
        let fetchRequest = RecipeObject.fetchRequest()
        fetchRequest.includesSubentities = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RecipeObject.dateAdded, ascending: false)]
        let authorIdMatchPredicate = NSPredicate(format: "authorId == %@", user.id)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [authorIdMatchPredicate, searchTextPredicate(searchText: searchText)]
            .compactMap { $0 })
        fetchRequest.predicate = compoundPredicate
        let result = try await persistentStore.fetch(fetchRequest) { Recipe(from: $0) }
        return result
    }

    func add(recipe: Recipe) async throws {
        try await persistentStore.update { context in
            RecipeObject.initFrom(recipe: recipe, context: context)
        }
    }

    func add(rating: Recipe.Rating, to recipe: Recipe) async throws {}
}

@MainActor
class RealRecipeService: RecipeService {
    // MARK: Methods

    let recipeDBRepository: RecipeDBRepository

    init(recipeDBRepository: RecipeDBRepository) {
        self.recipeDBRepository = recipeDBRepository
    }

    func fetchRatings(for recipe: Recipe) async throws -> [Recipe.Rating] {
        try await recipeDBRepository.fetchRatings(for: recipe)
    }

    func fetchAllRecipes(searchText: String) async throws -> [Recipe] {
        try await recipeDBRepository.fetchAllRecipes(searchText: searchText)
    }

    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe] {
        try await recipeDBRepository.fetchRecipes(createdBy: user, searchText: searchText)
    }

    func add(recipe: Recipe) async throws {
        try await recipeDBRepository.add(recipe: recipe)
    }

    func add(rating: Recipe.Rating, to recipe: Recipe) async throws {
        try await recipeDBRepository.add(rating: rating, to: recipe)
    }
}
