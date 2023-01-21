//
//  WithUserModifier.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/21/23.
//

import SwiftUI

struct WithUser: ViewModifier {
    @EnvironmentObject var user: UserWrapper

    let userUpdated: (User?) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear { userUpdated(user.user) }
            .onChange(of: user.user) { newValue in
                userUpdated(newValue)
            }
    }
}

extension View {
    func withUser(userUpdated: @escaping (User?) -> Void) -> some View {
        self
            .modifier(WithUser(userUpdated: userUpdated))
    }
}

protocol ViewWithUser: View {
    associatedtype ViewModelType: ViewModelWithUser
    var viewModel: ViewModelType { get }
}

extension ViewWithUser {
    func withUser() -> some View {
        self
            .withUser(userUpdated: { user in
                Task { @MainActor in
                    self.viewModel.user = user
                }
            })
    }
}

@MainActor
protocol ViewModelWithUser: ObservableObject {
    var user: User? { get set }
}
