//
//  SignUpViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import Foundation

protocol SignUpViewModelType: ObservableObject & AnyObject {
    var signUpError: Error? { get }
    var emailSignUp: String { get set }
    var passwordSignUp: String { get set }
    var signUpDisabled: Bool { get }
        
    func signUp() async
    func signUpWithGoogle() async
    func signUpWithApple() async
}

class SignUpViewModel: SignUpViewModelType {
    private let authService: AuthService

    @Published var signUpError: Error?
    @Published var emailSignUp: String = ""
    @Published var passwordSignUp: String = ""
    
    var signUpDisabled: Bool {
        passwordSignUp.isEmpty || emailSignUp.isEmpty
    }
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    private func signUp(signUpBlock: () async throws -> Void) async {
        do {
            signUpError = nil
            try await signUpBlock()
        } catch let error {
            log(error.localizedDescription, logLevel: .error, logType: .auth)
            self.signUpError = error
        }
    }

    func signUp() async {
        await signUp {
            _ = try await authService.signUpWith(email: emailSignUp, password: passwordSignUp)
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
