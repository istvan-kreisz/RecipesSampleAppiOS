//
//  RecipeView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI
import NukeUI

struct RecipeView<RatingModifier: ViewModifier>: View {
    @ObservedObject var viewModel: RecipeViewModel
    let ratingModifier: RatingModifier

    var body: some View {
        List {
            if let imageURL = viewModel.recipe.imageURL {
                LazyImage(url: imageURL) { state in
                    if let image = state.image {
                        image.resizingMode(.aspectFill)
                    } else {
                        Color.blue.opacity(0.1)
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 3)
                .clipped()
                .overlay(sourceOverlay, alignment: .bottom)
                .listRowInsets(.init())
            }

            Section(header: Text("Ingredients")) {
                ForEach(viewModel.recipe.ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                }
            }

            Section(header: Text("Directions")) {
                ForEach(viewModel.recipe.steps, id: \.self) { step in
                    Text(step)
                }
            }
        }
        .navigationBarItems(trailing: ratingsButton)
        .navigationTitle(Text(viewModel.recipe.title))
    }

    @ViewBuilder
    private var ratingsButton: some View {
        Button(action: viewModel.openRatings) {
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
        }
        .modifier(ratingModifier)
    }

    @ViewBuilder
    private var sourceOverlay: some View {
        if let source = viewModel.recipe.source {
            HStack {
                Image(systemName: "safari")
                Text("Source")
                Spacer()
            }
            .font(.headline)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color(.systemBackground).opacity(0.75))
            .onTapGesture { viewModel.openURL(source) }
        }
    }

}
