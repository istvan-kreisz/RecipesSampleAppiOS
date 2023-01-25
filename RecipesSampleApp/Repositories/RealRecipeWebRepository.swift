//
//  RealRecipeWebRepository.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/25/23.
//

import Foundation

class RealRecipeWebRepository: RecipeWebRepository {
    
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchRatings(for recipe: Recipe) async throws -> [Recipe.Rating] {
        try await call(endpoint: API.fetchRatings(recipe: recipe))
    }
    
    func fetchAllRecipes(searchText: String) async throws -> [Recipe] {
        try await call(endpoint: API.fetchAllRecipes(searchText: searchText))
    }
    
    func fetchRecipes(createdBy user: User, searchText: String) async throws -> [Recipe] {
        try await call(endpoint: API.fetchRecipesByUser(user: user, searchText: searchText))
    }
    
    func add(recipe: Recipe) async throws {
        try await call(endpoint: API.addRecipe(recipe: recipe))
    }
    
    func add(rating: Recipe.Rating, to recipe: Recipe) async throws {
        try await call(endpoint: API.addRating(recipe: recipe, rating: rating))
    }
}

// MARK: - Endpoints

extension RealRecipeWebRepository {
    enum API {
        case addRating(recipe: Recipe, rating: Recipe.Rating)
        case addRecipe(recipe: Recipe)
        case fetchAllRecipes(searchText: String)
        case fetchRatings(recipe: Recipe)
        case fetchRecipesByUser(user: User, searchText: String)
    }
}

extension RealRecipeWebRepository.API: APICall {
    var path: String {
        switch self {
        case .addRating:
            return "addRating"
        case .addRecipe:
            return "addRecipe"
        case .fetchAllRecipes:
            return "fetchAllRecipes"
        case .fetchRatings:
            return "fetchRatings"
        case .fetchRecipesByUser:
            return "fetchRecipesByUser"
        }
    }
    
    var method: String {
        "POST"
    }
    
    var headers: [String: String]? {
        ["Accept": "application/json"]
    }
    
    func body() throws -> Data? {
        switch self {
        case let .addRating(recipe, rating):
            struct BodyType: Encodable {
                let recipe: Recipe
                let rating: Recipe.Rating
            }
            return try data(body: BodyType(recipe: recipe, rating: rating))
        case let .addRecipe(recipe):
            struct BodyType: Encodable {
                let recipe: Recipe
            }
            return try data(body: BodyType(recipe: recipe))
        case let .fetchAllRecipes(searchText):
            struct BodyType: Encodable {
                let searchText: String
            }
            return try data(body: BodyType(searchText: searchText))
        case let .fetchRatings(recipe):
            struct BodyType: Encodable {
                let recipe: Recipe
            }
            return try data(body: BodyType(recipe: recipe))
        case let .fetchRecipesByUser(user, searchText):
            struct BodyType: Encodable {
                let user: User
                let searchText: String
            }
            return try data(body: BodyType(user: user, searchText: searchText))
        }
    }
}

