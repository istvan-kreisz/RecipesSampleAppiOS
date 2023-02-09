//
//  RecipeViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

class RecipeViewModel: ObservableObject, Identifiable {
    @Published var recipe: Recipe

    let openRatings: () -> Void
    let openURL: (URL) -> Void

    init(recipe: Recipe,
         openRatings: @escaping () -> Void,
         openURL: @escaping (URL) -> Void) {
        self.recipe = recipe
        self.openRatings = openRatings
        self.openURL = openURL
    }
}
