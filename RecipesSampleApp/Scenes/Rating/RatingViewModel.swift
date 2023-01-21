//
//  RatingViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
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
            .modifier(WithUser(userUpdated: { user in
                Task { @MainActor in
                    self.viewModel.user = user
                }
            }))
    }
}

protocol ViewModel: ObservableObject {}

@MainActor
protocol ViewModelWithUser: ViewModel {
    var user: User? { get set }
}

@MainActor
class RatingViewModel: ViewModelWithUser, Identifiable {
    // MARK: Stored Properties

    @Published var recipe: Recipe
    @Published var user: User?

    private let recipeService: RecipeService
    private let closeRatings: () -> Void

    var canAddRating: Bool {
        !recipe.ratings.contains { rating in
            rating.authorId == user?.id
        }
    }

    // MARK: Initialization

    init(recipe: Recipe, recipeService: RecipeService, closeRatings: @escaping () -> Void) {
        self.closeRatings = closeRatings
        self.recipe = recipe
        self.recipeService = recipeService

        Task {
            await fetchRatings()
        }
    }

    // MARK: Methods
    
    private func fetchRatings() async {
        let ratings = await recipeService.fetchRatings(for: recipe)
        self.recipe.ratings = ratings
    }
    
    private func addRating(rating: Recipe.Rating) async {
        await recipeService.add(rating: rating, to: recipe)
        await fetchRatings()
    }
    
    func addRating(comment: String) {
        guard let user = user else { return }
        let newRating = Recipe.Rating(author: user.username, authorId: user.id, comment: comment)
        Task {
            await addRating(rating: newRating)
        }
    }

    func close() {
        closeRatings()
    }
}
