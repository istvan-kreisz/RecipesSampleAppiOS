//
//  RecipesViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/20/23.
//

import Foundation

@MainActor
protocol RecipesViewModel: ObservableObject {
    var title: String { get }
    var recipes: [Recipe] { get }
    
    init(title: String, recipeService: RecipeService)
    func refresh(searchText: String)
}

extension RecipesViewModel {
    func refresh() {
        refresh(searchText: "")
    }
}
