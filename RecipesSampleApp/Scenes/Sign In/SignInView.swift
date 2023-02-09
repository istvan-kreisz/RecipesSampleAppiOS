//
//  SignInView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct SignInView<Model>: View where Model: SignInViewModelType {
    enum Field {
        case email
        case password
    }

    @ObservedObject var viewModel: Model
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack(spacing: 10) {
            VStack {
                TextField("Email", text: $viewModel.emailSignIn, prompt: nil)
                    .keyboardType(.emailAddress)
                    .padding()
                    .focused($focusedField, equals: .email)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)

                SecureField("Password", text: $viewModel.passwordSignIn, prompt: nil)
                    .padding()
                    .focused($focusedField, equals: .password)
                    .textContentType(.password)
                    .submitLabel(.done)
            }
            .onSubmit {
                switch focusedField {
                case .email:
                    focusedField = .password
                case .password:
                    if !viewModel.signInDisabled {
                        Task {
                            await viewModel.signIn()
                        }
                    }
                case .none:
                    break
                }
            }
            .padding(16.0)

            VStack(spacing: 10) {
                Button {
                    viewModel.navigateToSignUp?()
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 18.0))
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 48.0, idealHeight: 48.0, maxHeight: 48.0)
                        .contentShape(Rectangle())
                }

                Button {
                    Task {
                        await viewModel.signIn()
                    }
                } label: {
                    Text("Sign In")
                        .font(.system(size: 18.0))
                        .frame(maxWidth: .infinity, minHeight: 48.0, idealHeight: 48.0, maxHeight: 48.0)
                        .contentShape(Rectangle())
                }
                .disabled(viewModel.signInDisabled)
            }
            .padding(.bottom)
        }
        .centeredVertically()
    }
}
