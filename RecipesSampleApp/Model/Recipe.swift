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
}

extension Recipe {

    struct Rating: Identifiable, Equatable {

        // MARK: Stored Properties

        var id = UUID()
        var author: String
        var authorId: String
        var comment: String
    }
}
