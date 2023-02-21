//
//  SignInViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

@MainActor
protocol SignInViewModelType: ObservableObject & AnyObject, AnimatedError {
    var error: Error? { get set }
    var email: String { get set }
    var password: String { get set }
    var signInDisabled: Bool { get }
    var navigateToSignUp: (() -> Void)? { get }
    var navigateToPasswordReset: (() -> Void)? { get }

    func signIn() async
    func signInWithApple() async
    func signInWithGoogle() async
}

@MainActor
class SignInViewModel: SignInViewModelType {
    private let authService: AuthService

    @Published var error: Error?
    @Published var email: String = ""
    @Published var password: String = ""

    var navigateToSignUp: (() -> Void)?
    var navigateToPasswordReset: (() -> Void)?

    var signInDisabled: Bool {
        password.isEmpty || email.isEmpty
    }

    init(authService: AuthService) {
        self.authService = authService
    }

    private func signIn(signInBlock: () async throws -> Void) async {
        do {
            error = nil
            try await signInBlock()
        } catch let error {
            log(error, logLevel: .error, logType: .auth)
            showDisappearingError(error: error)
        }
    }

    func signIn() async {
        await signIn {
            _ = try await authService.signInWith(email: email, password: password)
        }
    }

    func signInWithGoogle() async {
        await signIn {
            _ = try await authService.signInWithGoogle()
        }
    }

    func signInWithApple() async {
        await signIn {
            _ = try await authService.signInWithApple()
        }
    }
}
