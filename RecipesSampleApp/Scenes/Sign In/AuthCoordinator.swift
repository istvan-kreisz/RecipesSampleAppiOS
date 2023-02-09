//
//  AuthCoordinator.swift
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
    
    @Published var showPasswordAlert = false
    
    private func setupResetPasswordViewModel(authService: AuthService) {
        let viewModel = ResetPasswordViewModel(authService: authService)
        resetPasswordViewModel = viewModel
        viewModel.navigateBack = { [weak self] in
            self?.resetPasswordViewModel = nil
            self?.showPasswordAlert = true
        }
    }

    init(authService: AuthService) {
        self.signInViewModel = .init(authService: authService)
        self.signUpViewModel = .init(authService: authService)
        
        self.signInViewModel.navigateToSignUp = { [weak self] in
            self?.navigationStack.append(0)
        }
        self.signInViewModel.navigateToPasswordReset = { [weak self, weak authService] in
            guard let self = self, let authService = authService else { return }
            self.setupResetPasswordViewModel(authService: authService)
        }
        
        self.signUpViewModel.navigateToSignIn = { [weak self] in
            _ = self?.navigationStack.popLast()
        }
        self.signUpViewModel.navigateToPasswordReset = { [weak self, weak authService] in
            guard let self = self, let authService = authService else { return }
            self.setupResetPasswordViewModel(authService: authService)
        }
    }
}
