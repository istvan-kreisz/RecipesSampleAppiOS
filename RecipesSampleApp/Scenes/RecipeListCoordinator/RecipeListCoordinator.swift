//
//  RecipeListCoordinator.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

class RecipeListCoordinator<ListViewModel>: ObservableObject, Identifiable where ListViewModel: RecipesViewModel {
    // MARK: Stored Properties

    @Published private(set) var viewModel: ListViewModel!
    @Published var detailViewModel: RecipeViewModel?
    @Published var ratingViewModel: RatingViewModel?
    @Published var addRecipeViewModel: AddRecipeViewModel?

    private let recipeService: RecipeService
    private let openURL: (URL) -> Void

    // MARK: Initialization

    init(title: String, recipeService: RecipeService, openURL: @escaping (URL) -> Void) {
        self.recipeService = recipeService
        self.openURL = openURL

        self.viewModel = ListViewModel(title: title, recipeService: recipeService) { [weak self] recipe in
            self?.open(recipe)
        }
    }

    // MARK: Methods

    func open(_ recipe: Recipe) {
        self.detailViewModel = .init(recipe: recipe,
                                     openRatings: { [weak self] in
                                         self?.openRatings(for: recipe)
                                     }, openURL: { [weak self] in
                                         self?.openURL($0)
                                     })
    }

    func openRatings(for recipe: Recipe) {
        Task { @MainActor in
            self.ratingViewModel = .init(recipe: recipe, recipeService: recipeService, closeRatings: closeRatings)
        }
    }

    func openAddRecipe() {
        Task { @MainActor in
            self.addRecipeViewModel = .init(recipeService: recipeService,
                                            closeAddRecipe: { [weak self] newRecipe in
                                                self?.addRecipeViewModel = nil
                                                if newRecipe != nil {
                                                    self?.viewModel.refresh()
                                                }
                                            },
                                            openURL: { [weak self] in
                                                self?.openURL($0)
                                            })
        }
    }

    func add(recipe: Recipe) {}

    func closeRatings() {
        self.ratingViewModel = nil
    }
}
