//
//  AddRecipeViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/21/23.
//

import Foundation

class AddRecipeViewModel: ViewModelWithGlobalState, Identifiable {
    struct InputErrors {
        var titleMissing = false
        var ingredientsMissing = false
        var stepsMissing = false

        var hasErrors: Bool {
            titleMissing || ingredientsMissing || stepsMissing
        }
    }

    // MARK: Stored Properties

    private let recipeService: RecipeService
    private let closeAddRecipe: (_ newRecipe: Recipe?) -> Void
    let openURL: (URL) -> Void

    @Published var inputErrors = InputErrors()
    @Published var recipe: Recipe {
        didSet {
            if !recipe.title.isEmpty, inputErrors.titleMissing {
                inputErrors.titleMissing = false
            }
            if !recipe.ingredients.isEmpty, inputErrors.ingredientsMissing {
                inputErrors.ingredientsMissing = false
            }
            if !recipe.steps.isEmpty, inputErrors.stepsMissing {
                inputErrors.stepsMissing = false
            }
        }
    }

    @Published var user: User? {
        didSet {
            guard let user = user else { return }
            recipe.authorId = user.id
        }
    }

    // MARK: Initialization

    init(recipeService: RecipeService, closeAddRecipe: @escaping (_ newRecipe: Recipe?) -> Void, openURL: @escaping (URL) -> Void) {
        self.recipeService = recipeService
        self.recipe = Recipe(authorId: "",
                             imageURL: nil,
                             title: "",
                             ingredients: [],
                             steps: [],
                             isVegetarian: false,
                             source: nil,
                             dateAdded: Date(),
                             ratings: [])
        self.closeAddRecipe = closeAddRecipe
        self.openURL = openURL
    }

    func add(ingredient: String) {
        guard !ingredient.isEmpty else { return }
        recipe.ingredients.append(ingredient)
    }

    func add(step: String) {
        guard !step.isEmpty else { return }
        recipe.steps.append(step)
    }

    func delete(ingredientsAt indexSet: IndexSet) {
        recipe.ingredients.remove(atOffsets: indexSet)
    }

    func delete(stepsAt indexSet: IndexSet) {
        recipe.steps.remove(atOffsets: indexSet)
    }

    func addRecipe() {
        if recipe.title.isEmpty {
            inputErrors.titleMissing = true
        }
        if recipe.ingredients.isEmpty {
            inputErrors.ingredientsMissing = true
        }
        if recipe.steps.isEmpty {
            inputErrors.stepsMissing = true
        }
        guard !inputErrors.hasErrors else { return }

        Task {
            do {
                try await recipeService.add(recipe: recipe)
                closeAddRecipe(recipe)
            } catch {
                print(error)
                closeAddRecipe(nil)
            }
        }
    }
}
