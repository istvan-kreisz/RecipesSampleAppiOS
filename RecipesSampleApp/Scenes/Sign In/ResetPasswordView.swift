//
//  ResetPasswordView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/9/23.
//

import SwiftUI

struct ResetPasswordView<Model>: View where Model: ResetPasswordViewModelType {
    @ObservedObject var viewModel: Model
    @State private var resetResult: Result<Void, Error>?

    var body: some View {
        VStack {
            if let error = viewModel.error {
                ErrorBanner(errorMessage: error.localizedDescription)
            }
            Spacer()
            VStack(spacing: 10) {
                TextField("Email", text: $viewModel.email, prompt: nil)
                    .keyboardType(.emailAddress)
                    .padding()
                    .textContentType(.emailAddress)
                    .submitLabel(.done)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary, lineWidth: 1))
                    .padding(16.0)

                VStack(spacing: 10) {
                    Button {
                        Task {
                            await viewModel.resetPassword()
                            if viewModel.error == nil {
                                viewModel.navigateBack?()
                            }
                        }
                    } label: {
                        Text("Reset Password")
                            .frame(width: 200)
                            .font(.system(size: 18.0))
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.passwordResetDisabled)
                }
                .padding(.bottom)
            }
            Spacer()
        }
    }
}
