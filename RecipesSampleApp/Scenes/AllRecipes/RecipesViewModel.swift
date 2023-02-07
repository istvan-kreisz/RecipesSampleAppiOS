//
//  RecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/20/23.
//

import Foundation

protocol RecipesViewModel: ViewModelWithGlobalState {
    var title: String { get }
    var recipes: [Recipe] { get }
    
    init(title: String, recipeService: RecipeService, openRecipe: @escaping (Recipe) -> Void)
    func open(recipe: Recipe)
    func refresh(searchText: String)
}

extension RecipesViewModel {
    func refresh() {
        refresh(searchText: "")
    }
}
