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

class HomeCoordinator: ObservableObject {
    // MARK: Stored Properties

    private let authenticationService = AuthenticationService()
    private let recipeService: RecipeService

    @Published var tab = HomeTab.meat
    @Published var signInViewModel: SignInViewModel?
    @Published var allRecipesCoordinator: RecipeListCoordinator<AllRecipesViewModel>!
    @Published var userRecipesCoordinator: RecipeListCoordinator<UserRecipesViewModel>!

    @Published var openedURL: URL?

    @Published var user: User? = nil
    
    var cancellables = Set<AnyCancellable>()

    var isAuthenticated: Bool {
        user != nil
    }

    // MARK: Initialization

    init(recipeService: RecipeService) {
        self.recipeService = recipeService
        
        self.allRecipesCoordinator = RecipeListCoordinator<AllRecipesViewModel>(title: "All Recipes", recipeService: recipeService) { [weak self] url in
            self?.open(url)
        }

        self.userRecipesCoordinator = RecipeListCoordinator<UserRecipesViewModel>(title: "Your Recipes", recipeService: recipeService) { [weak self] url in
            self?.open(url)
        }

        self.authenticationService.user
            .sink { newUser in
                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    self.user = newUser
                    if newUser == nil {
                        self.signInViewModel = SignInViewModel(authenticationService: self.authenticationService)

                    } else {
                        self.signInViewModel = nil
                    }
                }
            }.store(in: &cancellables)
    }

    // MARK: Methods

    func open(_ url: URL) {
        self.openedURL = url
    }

    func signOut() {
        Task {
            try await authenticationService.signOut()
        }
    }
}
