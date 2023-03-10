//
//  RealRecipeWebRepository.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/25/23.
//

import Foundation

class RealRecipeWebRepository: RecipeWebRepository {
    private var allRecipesPagination = PaginationState<Recipe>(lastLoaded: nil, isLastPage: false)
    private var userRecipesPagination = PaginationState<Recipe>(lastLoaded: nil, isLastPage: false)
    private var ratingsPagination = PaginationState<Rating>(lastLoaded: nil, isLastPage: false)

    let session: URLSession
    let baseURL: String
    let authService: AuthService?

    init(session: URLSession, baseURL: String, authService: AuthService) {
        self.session = session
        self.baseURL = baseURL
        self.authService = authService
    }

    func fetchRatings(for recipe: Recipe, loadMore: Bool) async throws -> PaginatedResult<[Rating]> {
        try await paginatedFetch(paginationState: &ratingsPagination,
                                 loadMore: loadMore,
                                 getLastLoadedPath: { lastLoadedRating in
                                     lastLoadedRating.dbPath(recipe: recipe)
                                 }, getEndPoint: { lastLoadedPath in
                                     API.fetchRatings(recipe: recipe, lastLoadedPath: lastLoadedPath)
                                 })
    }

    func fetchAllRecipes(searchText: String, loadMore: Bool) async throws -> PaginatedResult<[Recipe]> {
        try await paginatedFetch(paginationState: &allRecipesPagination,
                                 loadMore: loadMore,
                                 getLastLoadedPath: { lastLoadedRecipe in
                                     lastLoadedRecipe.dbPath
                                 }, getEndPoint: { lastLoadedPath in
                                     API.fetchAllRecipes(searchText: searchText, lastLoadedPath: lastLoadedPath)
                                 })
    }

    func fetchRecipes(createdBy user: User, searchText: String, loadMore: Bool) async throws -> PaginatedResult<[Recipe]> {
        try await paginatedFetch(paginationState: &userRecipesPagination,
                                 loadMore: loadMore,
                                 getLastLoadedPath: { lastLoadedRecipe in
                                     lastLoadedRecipe.dbPath
                                 },
                                 getEndPoint: { lastLoadedPath in
                                     API.fetchRecipesByUser(user: user, searchText: searchText, lastLoadedPath: lastLoadedPath)
                                 })
    }

    func add(recipe: Recipe) async throws {
        try await call(endpoint: API.addRecipe(recipe: recipe))
    }

    func add(rating: Rating, to recipe: Recipe) async throws {
        try await call(endpoint: API.addRating(recipe: recipe, rating: rating))
    }
}

extension RealRecipeWebRepository {
    enum API {
        case addRating(recipe: Recipe, rating: Rating)
        case addRecipe(recipe: Recipe)
        case fetchAllRecipes(searchText: String, lastLoadedPath: [String]?)
        case fetchRatings(recipe: Recipe, lastLoadedPath: [String]?)
        case fetchRecipesByUser(user: User, searchText: String, lastLoadedPath: [String]?)
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
        ["Accept": "application/json",
         "Content-Type": "application/json",
         "Authorization": "Bearer \(RealAuthService.idTokenSubject.value ?? "")"]
    }

    func body() throws -> Data? {
        switch self {
        case let .addRating(recipe, rating):
            struct Payload: Encodable {
                let recipe: Recipe
                let rating: Rating
            }
            return try data(body: Payload(recipe: recipe, rating: rating))
        case let .addRecipe(recipe):
            struct Payload: Encodable {
                let recipe: Recipe
            }
            return try data(body: Payload(recipe: recipe))
        case let .fetchAllRecipes(searchText, lastLoadedPath):
            struct Payload: Encodable {
                let searchText: String
                let startAfter: [String]?
            }
            return try data(body: Payload(searchText: searchText, startAfter: lastLoadedPath))
        case let .fetchRatings(recipe, lastLoadedPath):
            struct Payload: Encodable {
                let recipe: Recipe
                let startAfter: [String]?
            }
            return try data(body: Payload(recipe: recipe, startAfter: lastLoadedPath))
        case let .fetchRecipesByUser(user, searchText, lastLoadedPath):
            struct Payload: Encodable {
                let user: User
                let searchText: String
                let startAfter: [String]?
            }
            return try data(body: Payload(user: user, searchText: searchText, startAfter: lastLoadedPath))
        }
    }
}
