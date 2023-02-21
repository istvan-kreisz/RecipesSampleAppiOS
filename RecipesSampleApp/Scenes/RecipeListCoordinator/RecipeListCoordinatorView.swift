//
//  RecipeListCoordinatorView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct RecipeListCoordinatorView<ListViewModel>: View where ListViewModel: RecipesViewModel {
    @ObservedObject var coordinator: RecipeListCoordinator<ListViewModel>

    var body: some View {
        let isAlertPresented = Binding<Bool>(get: { coordinator.error != nil },
                                             set: { newValue in
                                                 if !newValue {
                                                     coordinator.error = nil
                                                 }
                                             })

        NavigationStack {
            ZStack {
                RecipeList(viewModel: coordinator.viewModel)
                    .navigationDestination(for: Recipe.self) { recipe in
                        let viewModel = coordinator.getRecipeViewModel(recipe)
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            phoneRecipeView(viewModel)
                        } else {
                            padRecipeView(viewModel)
                        }
                    }
                VStack(alignment: .center) {
                    Spacer()
                    Button {
                        coordinator.openAddRecipe()
                    } label: {
                        Text("Add Recipe")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 20)
                }
            }
            .modifier(SheetModifier(item: $coordinator.addRecipeViewModel, content: { viewModel in
                NavigationView {
                    AddRecipeView(viewModel: viewModel)
                }
            }))
        }
        .withErrorAlert(error: $coordinator.error)
    }

    @ViewBuilder
    private func phoneRecipeView(_ viewModel: RecipeViewModel) -> some View {
        RecipeView(viewModel: viewModel, ratingModifier: SheetModifier(item: $coordinator.ratingViewModel) { viewModel in
            NavigationView {
                RatingView(viewModel: viewModel)
            }
        })
    }

    @ViewBuilder
    private func padRecipeView(_ viewModel: RecipeViewModel) -> some View {
        RecipeView(viewModel: viewModel,
                   ratingModifier: PopoverModifier(item: $coordinator.ratingViewModel) {
                       RatingView(viewModel: $0)
                           .frame(width: 500, height: 500)
                   })
    }
}
