//
//  UserDBRepository.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/8/23.
//

import Foundation

protocol UserDBRepository {
    func fetchUser(userId: String) async throws -> User
}
