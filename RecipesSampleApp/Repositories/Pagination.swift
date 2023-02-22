//
//  Pagination.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/22/23.
//

import Foundation

struct PaginatedResult<T: Codable & Equatable>: Codable, Equatable {
    var data: T
    var isLastPage: Bool
}

struct PaginationState<T> {
    var lastLoaded: T?
    var isLastPage: Bool

    mutating func reset() {
        self = .init(lastLoaded: nil, isLastPage: false)
    }
}
