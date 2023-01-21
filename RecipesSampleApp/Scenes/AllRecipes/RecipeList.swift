//
//  RecipeList.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct RecipeList<ViewModel>: ViewWithUser where ViewModel: RecipesViewModel {
    // MARK: Stored Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: Views

    var body: some View {
        List(viewModel.recipes) { (recipe: Recipe) in
            HStack {
                AsyncImage(url: recipe.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                Text(recipe.title)
                    .font(.headline)
                Spacer()
            }
            .onNavigation { viewModel.open(recipe: recipe) }
        }
        .refreshable {
            viewModel.refresh()
        }
        .navigationTitle(viewModel.title)
    }
}
