//
//  SignInViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

protocol SignInViewModelDelegate: AnyObject {
    func signInViewModelDidCancel()
    func signInViewModelDidSignIn()
}

protocol SignInViewModelType: ObservableObject & AnyObject {
    var signInError: Error? { get }
    var email: String { get set }
    var password: String { get set }
    var signInDisabled: Bool { get }
    
    func cancel()
    func signIn() async
}

class SignInViewModel: SignInViewModelType {
    private let authService: AuthService

    private weak var delegate: SignInViewModelDelegate?

    @Published var signInError: Error?

    @Published var email: String = ""
    @Published var password: String = ""

    var signInDisabled: Bool {
        password.isEmpty || email.isEmpty
    }

    init(authService: AuthService) {
        self.authService = authService
    }

    func setup(delegate: SignInViewModelDelegate) {
        self.delegate = delegate
    }

    func signIn() async {
        do {
            self.signInError = nil
            _ = try await authService.signInWith(email: email, password: password)
            delegate?.signInViewModelDidSignIn()
        } catch let error {
            #warning("display error")
            self.signInError = error
        }
    }
    
    func cancel() {
        delegate?.signInViewModelDidCancel()
    }
}
