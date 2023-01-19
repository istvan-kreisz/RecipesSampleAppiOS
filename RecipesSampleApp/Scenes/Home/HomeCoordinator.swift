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
    @Published var veggieCoordinator: RecipeListCoordinator!
    @Published var meatCoordinator: RecipeListCoordinator!

    @Published var openedURL: URL?

    @Published var user: User? = nil

    var cancellables = Set<AnyCancellable>()

    var isAuthenticated: Bool {
        user != nil
    }

    // MARK: Initialization

    init(recipeService: RecipeService) {
        self.recipeService = recipeService

        self.veggieCoordinator = .init(title: "Veggie",
                                       recipeService: recipeService,
                                       parent: self,
                                       filter: { $0.isVegetarian })

        self.meatCoordinator = .init(title: "Meat",
                                     recipeService: recipeService,
                                     parent: self,
                                     filter: { !$0.isVegetarian })

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
