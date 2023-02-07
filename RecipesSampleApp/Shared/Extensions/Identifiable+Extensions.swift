//
//  Identifiable+Extensions.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/20/23.
//

import Foundation

extension Identifiable where ID: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
