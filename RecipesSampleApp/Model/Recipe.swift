//
//  Recipe.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import SwiftUI

struct Recipe: Identifiable, Equatable, Codable, Hashable {
    var id = UUID().uuidString
    var authorId: String
    var imageURL: URL?
    var title: String
    var ingredients: [String]
    var steps: [String]
    var isVegetarian: Bool
    var source: URL?
    var dateAdded: Date = Date()
    var ratings: [Rating] = []
    
    enum CodingKeys: String, CodingKey {
        case id, authorId, imageURL, title, ingredients, steps, isVegetarian, source, dateAdded
    }

    func isMatching(_ searchText: String) -> Bool {
        searchText.isEmpty ? true : title.lowercased().fuzzyMatch(searchText.lowercased())
    }
    
    var dbPath: [String] {
        ["users", authorId, "recipes", id]
    }
}

extension Recipe {
    init?(from recipeObject: RecipeObject) {
        guard let id = recipeObject.id,
              let authorId = recipeObject.authorId,
              let title = recipeObject.title,
              let dateAdded = recipeObject.dateAdded,
              let ingredients = recipeObject.ingredients,
              let steps = recipeObject.steps,
              let ratings = recipeObject.ratings?.compactMap({ $0 as? Rating })
        else { return nil }
        self.id = id
        self.authorId = authorId
        self.imageURL = recipeObject.imageURL
        self.title = title
        self.ingredients = ingredients
        self.steps = steps
        self.isVegetarian = recipeObject.isVegetarian
        self.source = recipeObject.source
        self.dateAdded = dateAdded
        self.ratings = ratings
    }
}
