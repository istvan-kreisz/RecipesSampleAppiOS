//
//  SignInViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

@MainActor
protocol SignInViewModelType: ObservableObject & AnyObject {
    var signInError: Error? { get }
    var emailSignIn: String { get set }
    var passwordSignIn: String { get set }
    var signInDisabled: Bool { get }
    var navigateToSignUp: (() -> Void)? { get }
    var navigateToPasswordReset: (() -> Void)? { get }
    
    func signIn() async
    func signInWithApple() async
    func signInWithGoogle() async
}

class SignInViewModel: SignInViewModelType {
    private let authService: AuthService

    @Published var signInError: Error?
    @Published var emailSignIn: String = ""
    @Published var passwordSignIn: String = ""
    
    var navigateToSignUp: (() -> Void)?
    var navigateToPasswordReset: (() -> Void)?

    var signInDisabled: Bool {
        passwordSignIn.isEmpty || emailSignIn.isEmpty
    }

    init(authService: AuthService) {
        self.authService = authService
    }
    
    private func signIn(signInBlock: () async throws -> Void) async {
        do {
            signInError = nil
            try await signInBlock()
        } catch let error {
            log(error.localizedDescription, logLevel: .error, logType: .auth)
            self.signInError = error
        }
    }

    func signIn() async {
        await signIn {
            _ = try await authService.signInWith(email: emailSignIn, password: passwordSignIn)
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
