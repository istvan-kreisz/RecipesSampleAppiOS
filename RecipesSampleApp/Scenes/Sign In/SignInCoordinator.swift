//
//  SignInCoordinator.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import Foundation

@MainActor
class AuthCoordinator: ObservableObject {
    @Published var signInViewModel: SignInViewModel
    @Published var signUpViewModel: SignUpViewModel
    @Published var resetPasswordViewModel: ResetPasswordViewModel?
    
    @Published var navigationStack: [Int] = []
    @Published var presentPasswordReset = false

    init(authService: AuthService) {
        self.signInViewModel = .init(authService: authService)
        self.signUpViewModel = .init(authService: authService)
        self.resetPasswordViewModel = .init(authService: authService)
        
        self.signInViewModel.navigateToSignUp = { [weak self] in
            self?.navigationStack.append(0)
        }
    }
}

extension AuthCoordinator: ResetPasswordViewModelDelegate {
    func didResetPassword() {
        // dismiss password reset modal
    }
}
