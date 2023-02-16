//
//  UserDefaults+Extensions.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/14/23.
//

import Foundation

extension UserDefaults {

    enum Keys: String, CaseIterable {
        case user
        case idToken
    }

    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }

}
