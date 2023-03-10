//
//  HomeCoordinator.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct HomeCoordinatorView: View {
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
                .sheet(item: $coordinator.openedURL) {
                    SafariView(url: $0)
                        .edgesIgnoringSafeArea(.all)
                }
            } else {
                // Display loading screen here
                EmptyView()
            }
        }
    }
}
