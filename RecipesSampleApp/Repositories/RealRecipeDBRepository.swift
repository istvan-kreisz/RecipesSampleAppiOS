//
//  RealRecipeDBRepository.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/24/23.
//

import Foundation
import CoreData

class RealRecipeDBRepository: RecipeDBRepository {
    let persistentStore: PersistentStore

    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }

    func fetchRatings(for recipe: Recipe) async throws -> [Recipe.Rating] {
        let fetchRequest = RatingObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RatingObject.dateAdded, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "recipe.id == %@", recipe.id as CVarArg)
        let result = try await persistentStore.fetch(fetchRequest) { Recipe.Rating(from: $0) }
        return result
    }
    
    func fetchRatingIds(for recipe: Recipe) async throws -> [String] {
        let fetchRequest = RatingObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RatingObject.dateAdded, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "recipe.id == %@", recipe.id as CVarArg)
        fetchRequest.propertiesToFetch = ["id"]
        let result = try await persistentStore.fetch(fetchRequest) { $0.id }
        return result
    }
    
    func fetchAllRecipes(searchText: String) async throws -> [Recipe] {
        let fetchRequest = RecipeObject.fetchRequest()
        fetchRequest.includesSubentities = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RecipeObject.dateAdded, ascending: false)]
        fetchRequest.predicate = searchTextPredicate(searchText: searchText)
        let result = try await persistentStore.fetch(fetchRequest) { Recipe(from: $0) }
        return result
    }
    
    func fetchAllRecipeIds() async throws -> [String] {
        let fetchRequest = RecipeObject.fetchRequest()
        fetchRequest.includesSubentities = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RecipeObject.dateAdded, ascending: false)]
        fetchRequest.propertiesToFetch = ["id"]
        let result = try await persistentStore.fetch(fetchRequest) { $0.id }
        return result
    }

    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe] {
        let fetchRequest = RecipeObject.fetchRequest()
        fetchRequest.includesSubentities = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RecipeObject.dateAdded, ascending: false)]
        let authorIdMatchPredicate = NSPredicate(format: "authorId == %@", user.id as CVarArg)
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

    func add(rating: Recipe.Rating, to recipe: Recipe) async throws {
        let recipeObject = try await fetch(recipe: recipe, context: persistentStore.backgroundContext)
        try await persistentStore.update { context in
            let ratingObject = RatingObject.initFrom(rating: rating, context: context)
            recipeObject.addToRatings(ratingObject)
            ratingObject.recipe = recipeObject
        }
    }

    private func fetch(recipe: Recipe, context: NSManagedObjectContext?) async throws -> RecipeObject {
        let fetchRequest = RecipeObject.fetchRequest()
        fetchRequest.includesSubentities = false
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id as CVarArg)
        let resultArray: [RecipeObject]
        if let context = context {
            resultArray = try await persistentStore.fetch(fetchRequest, context: context) { $0 }
        } else {
            resultArray = try await persistentStore.fetch(fetchRequest) { $0 }
        }
        if let result = resultArray.first {
            return result
        } else {
            throw CoreDataError.notFound
        }
    }

    private func searchTextPredicate(searchText: String) -> NSPredicate? {
        guard !searchText.isEmpty else { return nil }
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText.lowercased())
        return predicate
    }
}
