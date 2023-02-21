//
//  ResetPasswordViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import Foundation

@MainActor
protocol ResetPasswordViewModelType: ObservableObject & AnyObject, AnimatedError {
    var error: Error? { get set }
    var email: String { get set }
    var passwordResetDisabled: Bool { get }
    var navigateBack: (() -> Void)? { get }
    
    func resetPassword() async
}

class ResetPasswordViewModel: ResetPasswordViewModelType, Identifiable {
    private let authService: AuthService

    @Published var error: Error?
    @Published var email: String = ""
    
    var navigateBack: (() -> Void)?
    
    var passwordResetDisabled: Bool {
        email.isEmpty
    }

    init(authService: AuthService) {
        self.authService = authService
    }

    func resetPassword() async {
        do {
            error = nil
            _ = try await authService.resetPassword(email: email)
        } catch let error {
            showDisappearingError(error: error)
            log(error, logLevel: .error, logType: .auth)
        }
    }
}
