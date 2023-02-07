//
//  WithUserModifier.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/21/23.
//

import SwiftUI

struct WithGlobalState: ViewModifier {
    @EnvironmentObject var globalState: GlobalState

    let userUpdated: (User?) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear { userUpdated(globalState.user) }
            .onChange(of: globalState.user) { newValue in
                userUpdated(newValue)
            }
    }
}

extension View {
    func withGlobalState(userUpdated: @escaping (User?) -> Void) -> some View {
        self
            .modifier(WithGlobalState(userUpdated: userUpdated))
    }
}

protocol ViewWithGlobalState: View {
    associatedtype ViewModelType: ViewModelWithGlobalState
    var viewModel: ViewModelType { get }
}

extension ViewWithGlobalState {
    func withGlobalState() -> some View {
        self
            .withGlobalState(userUpdated: { user in
                Task { @MainActor in
                    guard user != self.viewModel.user else { return }
                    self.viewModel.user = user
                }
            })
    }
}

@MainActor
protocol ViewModelWithGlobalState: ObservableObject {
    var user: User? { get set }
}
