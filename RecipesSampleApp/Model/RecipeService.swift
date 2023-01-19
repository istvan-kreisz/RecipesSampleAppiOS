//
//  RecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

protocol RecipeService {
    func fetchRatings(for recipe: Recipe) async -> [Recipe.Rating]
    func fetchAllRecipes() async -> [Recipe]
    func fetchRecipes(createdBy user: User) async -> [Recipe]
}
