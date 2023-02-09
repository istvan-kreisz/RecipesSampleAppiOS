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
class HomeCoordinator: ObservableObject {
    private let recipeService: RecipeService
    private let authService: AuthService

    @Published var tab = HomeTab.meat
    @Published var authCoordinator: AuthCoordinator?
    @Published var allRecipesCoordinator: RecipeListCoordinator<AllRecipesViewModel>!
    @Published var userRecipesCoordinator: RecipeListCoordinator<UserRecipesViewModel>!

    @Published var openedURL: URL?

    @Published var user: User? = nil
    
    var cancellables = Set<AnyCancellable>()

    var isAuthenticated: Bool {
        user != nil
    }

    init(recipeService: RecipeService, authService: AuthService) {
        self.recipeService = recipeService
        self.authService = authService
        
        self.allRecipesCoordinator = RecipeListCoordinator<AllRecipesViewModel>(title: "All Recipes", recipeService: recipeService) { [weak self] url in
            self?.open(url)
        }

        self.userRecipesCoordinator = RecipeListCoordinator<UserRecipesViewModel>(title: "Your Recipes", recipeService: recipeService) { [weak self] url in
            self?.open(url)
        }

        self.authService.user
            .sink { newUser in
                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    self.user = newUser
                    if newUser == nil {
                        self.authCoordinator = AuthCoordinator(authService: self.authService)
                    } else {
                        self.authCoordinator = nil
                    }
                }
            }.store(in: &cancellables)
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
