//
//  RecipeListCoordinator.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

@MainActor
class RecipeListCoordinator<ListViewModel>: ObservableObject, Identifiable where ListViewModel: RecipesViewModel {
    @Published var error: Error?
    @Published private(set) var viewModel: ListViewModel!
    @Published var ratingViewModel: RatingViewModel?
    @Published var addRecipeViewModel: AddRecipeViewModel?

    private let recipeService: RecipeService
    private let networkMonitor: NetworkMonitor
    private let openURL: (URL) -> Void

    init(title: String, recipeService: RecipeService, networkMonitor: NetworkMonitor, openURL: @escaping (URL) -> Void) {
        self.recipeService = recipeService
        self.networkMonitor = networkMonitor
        self.openURL = openURL
        self.viewModel = ListViewModel(title: title, recipeService: recipeService)
    }

    func getRecipeViewModel(_ recipe: Recipe) -> RecipeViewModel {
        return .init(recipe: recipe,
                     openRatings: { [weak self] in
                         self?.openRatings(for: recipe)
                     }, openURL: { [weak self] in
                         self?.openURL($0)
                     })
    }

    func openRatings(for recipe: Recipe) {
        Task { @MainActor in
            self.ratingViewModel = .init(recipe: recipe, recipeService: recipeService, closeRatings: { [weak self] in
                self?.closeRatings()
            })
        }
    }

    func openAddRecipe() {
        if networkMonitor.isReachable {
            Task { @MainActor in
                self.addRecipeViewModel = .init(recipeService: recipeService,
                                                networkMonitor: networkMonitor,
                                                closeAddRecipe: { [weak self] newRecipe in
                                                    self?.addRecipeViewModel = nil
                                                    if newRecipe != nil {
                                                        Task {
                                                            try await self?.viewModel.refresh()
                                                        }
                                                    }
                                                },
                                                openURL: { [weak self] in
                                                    self?.openURL($0)
                                                })
            }
        } else {
            self.error = ReachabilityError.offline
        }
    }

    func closeRatings() {
        self.ratingViewModel = nil
    }
}
