//
//  SignUpViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import Foundation

@MainActor
protocol SignUpViewModelType: ObservableObject & AnyObject, AnimatedError {
    var error: Error? { get set }
    var email: String { get set }
    var password: String { get set }
    var signUpDisabled: Bool { get }
    var navigateToSignIn: (() -> Void)? { get }
    var navigateToPasswordReset: (() -> Void)? { get }
        
    func signUp() async
    func signUpWithGoogle() async
    func signUpWithApple() async
}

@MainActor
class SignUpViewModel: SignUpViewModelType {
    private let authService: AuthService

    @Published var error: Error?
    @Published var email: String = ""
    @Published var password: String = ""
    
    var navigateToSignIn: (() -> Void)?
    var navigateToPasswordReset: (() -> Void)?
    
    var signUpDisabled: Bool {
        password.isEmpty || email.isEmpty
    }
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    private func signUp(signUpBlock: () async throws -> Void) async {
        do {
            error = nil
            try await signUpBlock()
        } catch let error {
            showDisappearingError(error: error)
            log(error, logLevel: .error, logType: .auth)
        }
    }

    func signUp() async {
        await signUp {
            _ = try await authService.signUpWith(email: email, password: password)
        }
    }
    
    func signUpWithGoogle() async {
        await signUp {
            _ = try await authService.signInWithGoogle()
        }
    }
    
    func signUpWithApple() async {
        await signUp {
            _ = try await authService.signInWithApple()
        }
    }
}
