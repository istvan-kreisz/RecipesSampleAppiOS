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
    @Published var title: String
    @Published var recipes = [Recipe]()
    @Published var error: Error?

    var user: User? {
        didSet {
            refresh()
        }
    }

    private let recipeService: RecipeService
    var cancellable: AnyCancellable?

    required init(title: String, recipeService: RecipeService) {
        self.title = title
        self.recipeService = recipeService

        cancellable = listenToUserUpdates(updateStrategy: .userChanged) { [weak self] newValue in
            self?.user = newValue
        }
    }

    func refresh(searchText: String) {
        guard let user = user else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let recipes = try await recipeService.fetchRecipes(createdBy: user, searchText: searchText)
                self.recipes = recipes
            } catch {
                showDisappearingError(error: error)
            }
        }
    }
}
