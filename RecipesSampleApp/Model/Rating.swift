//
//  Rating.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/22/23.
//

import Foundation

struct Rating: Identifiable, Equatable, Codable {
    var id = UUID().uuidString
    var author: String
    var authorId: String
    var comment: String
    var dateAdded: Date
    
    func dbPath(recipe: Recipe) -> [String] {
        ["users", authorId, "recipes", recipe.id, "ratings", id]
    }
}

extension Rating {
    init?(from ratingObject: RatingObject) {
        guard let id = ratingObject.id,
              let author = ratingObject.author,
              let authorId = ratingObject.authorId,
              let comment = ratingObject.comment,
              let dateAdded = ratingObject.dateAdded
        else { return nil }
        self.id = id
        self.authorId = authorId
        self.author = author
        self.comment = comment
        self.dateAdded = dateAdded
    }
}
