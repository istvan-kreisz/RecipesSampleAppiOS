//
//  RatingViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import SwiftUI

@MainActor
class RatingViewModel: ViewModelWithUser, Identifiable {
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
        let ratings = await recipeService.fetchRatings(for: recipe)
        self.recipe.ratings = ratings
    }
    
    private func addRating(rating: Recipe.Rating) async {
        await recipeService.add(rating: rating, to: recipe)
        await fetchRatings()
    }
    
    func addRating(comment: String) {
        guard let user = user else { return }
        let newRating = Recipe.Rating(author: user.username, authorId: user.id, comment: comment)
        Task {
            await addRating(rating: newRating)
        }
    }

    func close() {
        closeRatings()
    }
}
