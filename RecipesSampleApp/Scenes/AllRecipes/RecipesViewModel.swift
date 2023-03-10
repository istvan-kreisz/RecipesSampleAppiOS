//
//  RecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/20/23.
//

import Foundation

@MainActor
protocol RecipesViewModel: ObservableObject, PaginatedViewModel where T == Recipe {
    var title: String { get }
    
    init(title: String, recipeService: RecipeService)
    func refresh(searchText: String) async throws
    func loadMore(searchText: String) async throws
}

extension RecipesViewModel {
    var recipes: [Recipe] {
        items
    }
    
    func refresh() async throws {
        try await refresh(searchText: "")
    }
    
    func loadMore() async throws {
        try await loadMore(searchText: "")
    }
}
