//
//  RatingViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RatingViewModel: ObservableObject, Identifiable, UserListener, PaginatedViewModel {
    @Published var fetchResult = PaginatedResult<[Rating]>(data: [], isLastPage: false)

    @Published var recipe: Recipe
    @Published var user: User?
    @Published var error: Error?

    var ratings: [Rating] {
        items
    }

    private let recipeService: RecipeService
    private let closeRatings: () -> Void
    var cancellable: AnyCancellable?

    var canAddRating: Bool {
        !recipe.ratings.contains { rating in
            rating.authorId == user?.id
        }
    }

    init(recipe: Recipe, recipeService: RecipeService, closeRatings: @escaping () -> Void) {
        self.closeRatings = closeRatings
        self.recipe = recipe
        self.recipeService = recipeService

        cancellable = listenToUserUpdates(updateStrategy: .userUpdatedOrChanged) { [weak self] newValue in
            self?.user = newValue
        }

        Task {
            try? await refresh()
        }
    }

    func refresh() async throws {
        try await loadItems(reload: true) { [weak self] reload in
            guard let self else { return .init(data: [], isLastPage: true) }
            return try await self.recipeService.fetchRatings(for: self.recipe, loadMore: !reload)
        }
    }

    func loadMore() async throws {
        try await loadItems(reload: false) { [weak self] reload in
            guard let self else { return .init(data: [], isLastPage: true) }
            return try await self.recipeService.fetchRatings(for: self.recipe, loadMore: !reload)
        }
    }

    private func addRating(rating: Rating) async {
        do {
            try await recipeService.add(rating: rating, to: recipe)
            try await refresh()
        } catch {
            self.error = error
        }
    }

    func addRating(comment: String) {
        guard let user = user else { return }
        let newRating = Rating(author: user.name, authorId: user.id, comment: comment, dateAdded: Date())
        Task {
            await addRating(rating: newRating)
        }
    }

    func close() {
        closeRatings()
    }
}
