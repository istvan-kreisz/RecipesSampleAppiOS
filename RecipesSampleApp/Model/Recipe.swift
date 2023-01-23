//
//  Recipe.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import SwiftUI

struct Recipe: Identifiable, Equatable {
    // MARK: Stored Properties

    var id = UUID()
    var authorId: String
    var imageURL: URL?
    var title: String
    var ingredients: [String]
    var steps: [String]
    var isVegetarian: Bool
    var source: URL?
    var ratings: [Rating] = []

    func isMatching(_ searchText: String) -> Bool {
        searchText.isEmpty ? true : title.lowercased().fuzzyMatch(searchText.lowercased())
    }
}

extension Recipe {
    init?(from recipeObject: RecipeObject) {
        guard let id = recipeObject.id,
              let authorId = recipeObject.authorId,
              let title = recipeObject.title,
              let ingredients = recipeObject.ingredients?.compactMap({ $0 as? String }),
              let steps = recipeObject.steps?.compactMap({ $0 as? String }),
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
        self.ratings = ratings
    }
}

extension Recipe {
    struct Rating: Identifiable, Equatable {
        var id = UUID()
        var author: String
        var authorId: String
        var comment: String
    }
}


extension Recipe.Rating {
    init?(from ratingObject: RatingObject) {
        guard let id = ratingObject.id,
              let author = ratingObject.author,
              let authorId = ratingObject.authorId,
              let comment = ratingObject.comment
        else { return nil }
        self.id = id
        self.authorId = authorId
        self.author = author
        self.comment = comment
    }
}
