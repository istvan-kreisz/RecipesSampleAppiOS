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
        let user = User(id: "istvan", name: "istvan", email: "istvan", dateAdded: Date())
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
        self._user.send(User(id: "istvan", name: "istvan", email: "istvan", dateAdded: Date()))
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

extension UserWrapper: Equatable {
    public static func == (lhs: UserWrapper, rhs: UserWrapper) -> Bool {
        lhs.user == rhs.user
    }
}

public struct User: Equatable, Codable {
    var id = UUID().uuidString
    let name: String
    let email: String
    let dateAdded: Date

    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.email == rhs.email
            && lhs.dateAdded == rhs.dateAdded
    }
}
