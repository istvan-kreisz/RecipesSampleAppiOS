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
    var username: String { get set }
    var password: String { get set }
    var signInDisabled: Bool { get }
    
    func cancel()
    func signIn() async
}

class SignInViewModel: SignInViewModelType {
    private let authenticationService: AuthenticationServiceProtocol

    private weak var delegate: SignInViewModelDelegate?

    @Published var signInError: Error?

    @Published var username: String = ""
    @Published var password: String = ""

    var signInDisabled: Bool {
        password.isEmpty || username.isEmpty
    }

    init(authenticationService: AuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }

    func setup(delegate: SignInViewModelDelegate) {
        self.delegate = delegate
    }

    func signIn() async {
        do {
            self.signInError = nil
            _ = try await authenticationService.signIn(username: username, password: password)
            delegate?.signInViewModelDidSignIn()
        } catch let error {
            self.signInError = error
        }
    }
    
    func cancel() {
        delegate?.signInViewModelDidCancel()
    }
}
