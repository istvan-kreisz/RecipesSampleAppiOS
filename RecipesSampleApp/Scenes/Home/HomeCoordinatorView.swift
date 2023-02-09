//
//  HomeCoordinator.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct HomeCoordinatorView: View {
    @StateObject var user = GlobalState(user: nil)
    @ObservedObject var coordinator: HomeCoordinator

    var body: some View {
        if let authCoordinator = coordinator.authCoordinator {
            AuthCoordinatorView(coordinator: authCoordinator)
        } else {
            if coordinator.isAuthenticated {
                TabView(selection: $coordinator.tab) {
                    RecipeListCoordinatorView(coordinator: coordinator.allRecipesCoordinator)
                        .tabItem { Label("All Recipes", systemImage: "square.stack") }
                        .tag(HomeTab.meat)

                    RecipeListCoordinatorView(coordinator: coordinator.userRecipesCoordinator)
                        .tabItem { Label("Your Recipes", systemImage: "heart") }
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
