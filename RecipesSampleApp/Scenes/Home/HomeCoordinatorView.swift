//
//  HomeCoordinator.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct HomeCoordinatorView: View {
    // MARK: Stored Properties

    @StateObject var user = UserWrapper(user: nil)
    @ObservedObject var coordinator: HomeCoordinator

    // MARK: Views

    var body: some View {
        if let signInViewModel = coordinator.signInViewModel {
            SignInView<SignInViewModel>(viewModel: signInViewModel)
        } else {
            if coordinator.isAuthenticated {
                TabView(selection: $coordinator.tab) {
                    RecipeListCoordinatorView(coordinator: coordinator.meatCoordinator)
                        .tabItem { Label("Meat", systemImage: "hare.fill") }
                        .tag(HomeTab.meat)

                    RecipeListCoordinatorView(coordinator: coordinator.veggieCoordinator)
                        .tabItem { Label("Veggie", systemImage: "leaf.fill") }
                        .tag(HomeTab.veggie)

                    NavigationView {
                        SettingsView(coordinator: coordinator)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem { Label("Settings", systemImage: "gear") }
                    .tag(HomeTab.settings)
                }
                // todo: use SheetModifier
                .sheet(item: $coordinator.openedURL) {
                    SafariView(url: $0)
                        .edgesIgnoringSafeArea(.all)
                }
                .onReceive(coordinator.$user) { user in
                    self.user.user = user
                }
                .environmentObject(user)
            } else {
                EmptyView()
            }
        }
    }
}
