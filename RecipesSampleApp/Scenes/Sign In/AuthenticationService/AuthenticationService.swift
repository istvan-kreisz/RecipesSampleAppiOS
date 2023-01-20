//
//  AuthenticationService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import Combine
import SwiftUI

public protocol AuthenticationServiceProtocol: AnyObject {
    var user: AnyPublisher<User?, Never> { get }

    func signIn(username: String, password: String) async throws -> User
    func signOut() async throws
}

public actor AuthenticationService: AuthenticationServiceProtocol {
    private let _user: CurrentValueSubject<User?, Never> = CurrentValueSubject(nil)
    public nonisolated var user: AnyPublisher<User?, Never> { self._user.eraseToAnyPublisher() }

    public func login(username: String, password: String) async throws -> User {
        let user = User(username: username, password: password)
        self._user.send(user)
        return user
    }
    
    public func logout() async throws {
        self._user.send(nil)
    }

    public func signIn(username: String, password: String) async throws -> User {
        let user = try await login(username: username, password: password)
        return user
    }

    public func signOut() async throws {
        try await logout()
    }
    
    public init() {
        self._user.send(User(username: "", password: ""))
    }
}

extension AuthenticationService {
    enum Errors: Error {
        case userIsOutOfSync
    }
}

public class UserWrapper: ObservableObject {
    @Published public var user: User?
    
    public init(user: User?) {
        self.user = user
    }
}

public struct User: Equatable {
    public let username: String
    public let password: String

    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username
            && lhs.password == rhs.password
    }
}
