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
class RatingViewModel: ObservableObject, Identifiable, UserListener {
    @Published var recipe: Recipe
    @Published var user: User?

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
            await fetchRatings()
        }
    }

    private func fetchRatings() async {
        do {
            let ratings = try await recipeService.fetchRatings(for: recipe)
            self.recipe.ratings = ratings
        } catch {
            // todo: show error
        }
    }

    private func addRating(rating: Recipe.Rating) async {
        do {
            try await recipeService.add(rating: rating, to: recipe)
            await fetchRatings()
        } catch {
            // todo: show error
        }
    }

    func addRating(comment: String) {
        guard let user = user else { return }
        let newRating = Recipe.Rating(author: user.name, authorId: user.id, comment: comment, dateAdded: Date())
        Task {
            await addRating(rating: newRating)
        }
    }

    func close() {
        closeRatings()
    }
}
