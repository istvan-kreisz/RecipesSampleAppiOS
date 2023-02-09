//
//  SignUpView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import SwiftUI

struct SignUpView<Model>: View where Model: SignUpViewModelType {
    enum Field {
        case email
        case password
    }

    @ObservedObject var viewModel: Model
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack(spacing: 10) {
            Form {
                Label("Email", image: "envelope.fill")
                    .padding(EdgeInsets(top: 8.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
                TextField("Email", text: $viewModel.emailSignUp, prompt: nil)
                    .keyboardType(.emailAddress)
                    .padding()
                    .focused($focusedField, equals: .email)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)

                Label("Password", image: "lock.fill")
                    .padding(EdgeInsets(top: 8.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
                    .padding(.top)
                SecureField("Password", text: $viewModel.passwordSignUp, prompt: nil)
                    .padding()
                    .focused($focusedField, equals: .password)
                    .textContentType(.password)
                    .submitLabel(.done)
            }
            .padding(16.0)

            VStack(spacing: 10) {
                Button {
                    //
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 18.0))
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 48.0, idealHeight: 48.0, maxHeight: 48.0)
                        .contentShape(Rectangle())
                }

                Button {
                    Task {
                        await viewModel.signUp()
                    }
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 18.0))
                        .frame(maxWidth: .infinity, minHeight: 48.0, idealHeight: 48.0, maxHeight: 48.0)
                        .contentShape(Rectangle())
                }
                .disabled(viewModel.signUpDisabled)
            }
            .padding(.bottom)
        }
        .centeredVertically()
    }
}

