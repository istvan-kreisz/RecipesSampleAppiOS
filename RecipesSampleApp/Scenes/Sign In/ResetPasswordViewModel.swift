//
//  ResetPasswordViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import Foundation

protocol ResetPasswordViewModelDelegate: AnyObject {
    func didResetPassword()
}

protocol ResetPasswordViewModelType: ObservableObject & AnyObject {
    var passwordResetError: Error? { get }
    var emailPasswordReset: String { get set }
    var passwordResetDisabled: Bool { get }
    
    func resetPassword() async
}

class ResetPasswordViewModel: ResetPasswordViewModelType {
    private let authService: AuthService

    private weak var delegate: ResetPasswordViewModelDelegate?

    @Published var passwordResetError: Error?
    @Published var emailPasswordReset: String = ""
    
    var passwordResetDisabled: Bool {
        emailPasswordReset.isEmpty
    }

    init(authService: AuthService) {
        self.authService = authService
    }

    func setup(delegate: ResetPasswordViewModelDelegate) {
        self.delegate = delegate
    }
    
    func resetPassword() async {
        do {
            passwordResetError = nil
            _ = try await authService.resetPassword(email: emailPasswordReset)
            delegate?.didResetPassword()
        } catch let error {
            log(error.localizedDescription, logLevel: .error, logType: .auth)
            self.passwordResetError = error
        }
    }
}
