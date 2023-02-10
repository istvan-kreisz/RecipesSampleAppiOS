//
//  AuthService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/6/23.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
protocol AuthService: AnyObject {
    func setup(userChanged: @escaping (User?) -> Void)
    
    func signUpWith(email: String, password: String) async throws
    func signInWith(email: String, password: String) async throws
    func signInWithApple() async throws
    func signInWithGoogle() async throws
    func signOut() async throws
    func resetPassword(email: String) async throws
}
