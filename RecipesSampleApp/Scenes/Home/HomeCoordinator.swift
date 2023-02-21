//
//  HomeViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import SwiftUI
import Combine

enum HomeTab {
    case meat
    case veggie
    case settings
}

@MainActor
class HomeCoordinator: ObservableObject, UserListener {
    private let recipeService: RecipeService
    private let authService: AuthService
    private let networkMonitor: NetworkMonitor
    var cancellable: AnyCancellable?

    @Published var tab = HomeTab.meat
    @Published var authCoordinator: AuthCoordinator?
    @Published var allRecipesCoordinator: RecipeListCoordinator<AllRecipesViewModel>!
    @Published var userRecipesCoordinator: RecipeListCoordinator<UserRecipesViewModel>!

    @Published var openedURL: URL?

    @Published var user: User? = nil

    var isAuthenticated: Bool {
        user != nil
    }

    init(recipeService: RecipeService, authService: AuthService, networkMonitor: NetworkMonitor) {
        self.recipeService = recipeService
        self.authService = authService
        self.networkMonitor = networkMonitor

        self.allRecipesCoordinator = RecipeListCoordinator<AllRecipesViewModel>(title: "All Recipes",
                                                                                recipeService: recipeService,
                                                                                networkMonitor: networkMonitor) { [weak self] url in
            self?.open(url)
        }

        self.userRecipesCoordinator = RecipeListCoordinator<UserRecipesViewModel>(title: "Your Recipes",
                                                                                  recipeService: recipeService,
                                                                                  networkMonitor: networkMonitor) { [weak self] url in
            self?.open(url)
        }

        cancellable = listenToUserUpdates(updateStrategy: .userUpdatedOrChanged) { [weak self] newValue in
            guard let self = self else { return }
            self.user = newValue
            if newValue == nil {
                self.authCoordinator = AuthCoordinator(authService: self.authService)
            } else {
                self.authCoordinator = nil
            }
        }
    }

    func open(_ url: URL) {
        self.openedURL = url
    }

    func signOut() {
        Task {
            try await authService.signOut()
        }
    }
}
