//
//  SignInView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct SignInView<Model>: View where Model: SignInViewModelType {
    @ObservedObject var viewModel: Model

    @State private var showCard: Bool = false

    var body: some View {
        VStack {
            Spacer()
            if self.showCard {
                CardView(color: Color.clear, cornerRadius: .large) {
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Email")
                                .padding(EdgeInsets(top: 8.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
                            TextField("Email", text: $viewModel.email, prompt: nil)
                                .padding()
                            Text("Password").padding(.top)
                                .padding(EdgeInsets(top: 8.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
                            SecureField("Password", text: $viewModel.password, prompt: nil)
                                .padding()
                        }
                        .padding(16.0)

                        HStack {
                            Button {
                                viewModel.cancel()
                            } label: {
                                Text("Cancel")
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
                }
                .fixedSize(horizontal: false, vertical: true)
                .clipped()
                .shadow(radius: 3.0)
                .padding(36.0)
                .transition(.scale(scale: 0.0))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background(Rectangle().fill(.white).blur(radius: 0.3, opaque: true)
            .edgesIgnoringSafeArea(.all))
        .onAppear {
            withAnimation(.spring()) {
                showCard = true
            }
        }
    }
}
