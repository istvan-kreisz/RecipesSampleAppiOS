//
//  UserWebRepository.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/10/23.
//

import Foundation

protocol UserWebRepository: WebRepository, AnyObject {
    func fetchUser(userId: String) async throws -> User
    func setup(authService: AuthService)
}
