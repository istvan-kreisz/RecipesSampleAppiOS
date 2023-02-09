//
//  ResetPasswordViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import Foundation

protocol ResetPasswordViewModelType: ObservableObject & AnyObject {
    var passwordResetError: Error? { get }
    var emailPasswordReset: String { get set }
    var passwordResetDisabled: Bool { get }
    var navigateBack: (() -> Void)? { get }
    
    func resetPassword() async
}

class ResetPasswordViewModel: ResetPasswordViewModelType, Identifiable {
    private let authService: AuthService

    @Published var passwordResetError: Error?
    @Published var emailPasswordReset: String = ""
    
    var navigateBack: (() -> Void)?
    
    var passwordResetDisabled: Bool {
        emailPasswordReset.isEmpty
    }

    init(authService: AuthService) {
        self.authService = authService
    }

    func resetPassword() async {
        do {
            passwordResetError = nil
            _ = try await authService.resetPassword(email: emailPasswordReset)
        } catch let error {
            log(error.localizedDescription, logLevel: .error, logType: .auth)
            self.passwordResetError = error
        }
    }
}
