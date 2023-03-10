//
//  UserRecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/20/23.
//

import SwiftUI
import Combine

@MainActor
class UserRecipesViewModel: RecipesViewModel, UserListener, AnimatedError {
    private let recipeService: RecipeService

    @Published var title: String
    @Published var fetchResult = PaginatedResult<[Recipe]>(data: [], isLastPage: false)
    @Published var error: Error?

    var user: User? {
        didSet {
            Task {
                try await refresh()
            }
        }
    }

    var cancellable: AnyCancellable?

    required init(title: String, recipeService: RecipeService) {
        self.title = title
        self.recipeService = recipeService

        cancellable = listenToUserUpdates(updateStrategy: .userChanged) { [weak self] newValue in
            self?.user = newValue
        }
    }

    func refresh(searchText: String) async throws {
        try await loadItems(reload: true) { [weak self] reload in
            guard let self, let user = self.user else { return .init(data: [], isLastPage: true) }
            return try await self.recipeService.fetchRecipes(createdBy: user, searchText: searchText, loadMore: !reload)
        }
    }

    func loadMore(searchText: String) async throws {
        try await loadItems(reload: false) { [weak self] reload in
            guard let self, let user = self.user else { return .init(data: [], isLastPage: true) }
            return try await self.recipeService.fetchRecipes(createdBy: user, searchText: searchText, loadMore: !reload)
        }
    }
}
