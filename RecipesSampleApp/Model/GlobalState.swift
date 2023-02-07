//
//  GlobalState.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/7/23.
//

import Foundation

class GlobalState: ObservableObject {
    @Published public var user: User?

    public init(user: User?) {
        self.user = user
    }
}

extension GlobalState: Equatable {
    public static func == (lhs: GlobalState, rhs: GlobalState) -> Bool {
        lhs.user == rhs.user
    }
}
