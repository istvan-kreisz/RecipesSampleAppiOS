//
//  RatingViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import SwiftUI

@MainActor
class RatingViewModel: ViewModelWithGlobalState, Identifiable {
    // MARK: Stored Properties

    @Published var recipe: Recipe
    @Published var user: User?

    private let recipeService: RecipeService
    private let closeRatings: () -> Void

    var canAddRating: Bool {
        !recipe.ratings.contains { rating in
            rating.authorId == user?.id
        }
    }

    // MARK: Initialization

    init(recipe: Recipe, recipeService: RecipeService, closeRatings: @escaping () -> Void) {
        self.closeRatings = closeRatings
        self.recipe = recipe
        self.recipeService = recipeService

        Task {
            await fetchRatings()
        }
    }

    // MARK: Methods

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
