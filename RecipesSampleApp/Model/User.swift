//
//  User.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/7/23.
//

import Foundation

struct User: Equatable, Codable {
    var id = UUID().uuidString
    let name: String
    let email: String
    let dateAdded: Date
}
