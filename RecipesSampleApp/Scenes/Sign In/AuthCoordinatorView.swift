//
//  AuthCoordinatorView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import SwiftUI

#warning("show errors")
struct AuthCoordinatorView: View {
    @ObservedObject var coordinator: AuthCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            SignInView(viewModel: coordinator.signInViewModel)
                .navigationTitle(Text("Sign In"))
                .navigationDestination(for: Int.self) { i in
                    SignUpView(viewModel: coordinator.signUpViewModel)
                        .navigationTitle(Text("Sign Up"))
                        .navigationBarBackButtonHidden()
                }
        }
        .alert("Password Reset Complete", isPresented: $coordinator.showPasswordAlert, actions: {})
        .modifier(SheetModifier(item: $coordinator.resetPasswordViewModel, content: { viewModel in
            NavigationView {
                ResetPasswordView(viewModel: viewModel)
                    .navigationTitle(Text("Reset Password"))
            }
        }))
    }
}
