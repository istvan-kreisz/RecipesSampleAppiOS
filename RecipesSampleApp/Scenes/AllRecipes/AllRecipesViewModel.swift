//
//  AllRecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

@MainActor
class AllRecipesViewModel: RecipesViewModel, PaginatedViewModel {
    private let recipeService: RecipeService

    @Published var title: String
    @Published var fetchResult = PaginatedResult<[Recipe]>(data: [], isLastPage: false)
    @Published var error: Error?

    required init(title: String, recipeService: RecipeService) {
        self.title = title
        self.recipeService = recipeService
    }

    func refresh(searchText: String) async throws {
        try await loadItems(reload: true) { [weak self] reload in
            try await self?.recipeService.fetchAllRecipes(searchText: searchText, loadMore: !reload) ?? .init(data: [], isLastPage: true)
        }
    }

    func loadMore(searchText: String) async throws {
        try await loadItems(reload: false) { [weak self] reload in
            try await self?.recipeService.fetchAllRecipes(searchText: searchText, loadMore: !reload) ?? .init(data: [], isLastPage: true)
        }
    }
}
