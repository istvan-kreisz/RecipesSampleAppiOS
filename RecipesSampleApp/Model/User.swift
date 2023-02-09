//
//  User.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/7/23.
//

import Foundation

struct User: Equatable, Codable {
    var id = UUID()
    let name: String
    let email: String
    let dateAdded: Date
}

extension User {
    init?(from userObject: UserObject) {
        guard let id = userObject.id,
              let name = userObject.name,
              let email = userObject.email,
              let dateAdded = userObject.dateAdded
        else { return nil }
        self.id = id
        self.name = name
        self.email = email
        self.dateAdded = dateAdded
    }
}
