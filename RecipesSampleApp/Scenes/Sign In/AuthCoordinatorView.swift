//
//  AuthCoordinatorView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import SwiftUI

struct AuthCoordinatorView: View {
    @EnvironmentObject var globalState: GlobalState
    @ObservedObject var coordinator: AuthCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            SignInView(viewModel: coordinator.signInViewModel)
                .navigationTitle(Text("Sign In"))
                .navigationDestination(for: Int.self) { i in
                    SignUpView(viewModel: coordinator.signUpViewModel)
                        .navigationTitle(Text("Sign Up"))
                }
        }
    }
}
