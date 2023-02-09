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
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary, lineWidth: 1))

                SecureField("Password", text: $viewModel.passwordSignIn, prompt: nil)
                    .padding()
                    .focused($focusedField, equals: .password)
                    .textContentType(.password)
                    .submitLabel(.done)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary, lineWidth: 1))
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
                    Task {
                        await viewModel.signIn()
                    }
                } label: {
                    Text("Sign In")
                        .frame(width: 200)
                        .font(.system(size: 18.0))
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.signInDisabled)

                Text("Don't have an account?")
                    .font(.system(size: 12.0))
                    .padding(.top, 5)
                Button {
                    viewModel.navigateToSignUp?()
                } label: {
                    Text("Create Account")
                        .frame(width: 200)
                        .font(.system(size: 18.0))
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Button {
                    viewModel.navigateToPasswordReset?()
                } label: {
                    Text("Forgot password?")
                        .font(.system(size: 12.0, weight: .semibold))
                        .underline()
                }
            }
            .padding(.bottom)
        }
        .centeredVertically()
    }
}
