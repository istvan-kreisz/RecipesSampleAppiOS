//
//  RatingViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

class RatingViewModel: ObservableObject, Identifiable {
    // MARK: Stored Properties

    @Published var recipe: Recipe
    @Published var meanRating = 0.0
    @Published var ratings = [Recipe.Rating]()

    private let recipeService: RecipeService
    private let closeRatings: () -> Void

    // MARK: Initialization

    init(recipe: Recipe, recipeService: RecipeService, closeRatings: @escaping () -> Void) {
        self.closeRatings = closeRatings
        self.recipe = recipe
        self.recipeService = recipeService

        Task {
            let ratings = await recipeService.fetchRatings(for: recipe)
            self.ratings = ratings
            self.meanRating = Double(ratings.map(\.value).reduce(0, +)) / Double(ratings.count)
        }
    }

    // MARK: Methods

    func close() {
        closeRatings()
    }
}
