//
//  RecipeList.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI
import NukeUI

struct RecipeList<ViewModel>: View where ViewModel: RecipesViewModel {
    @ObservedObject var viewModel: ViewModel
    @State var searchText = ""

    var body: some View {
        VStack {
            if let error = viewModel.error {
                ErrorBanner(errorMessage: error.localizedDescription)
            }
            List(viewModel.recipes) { (recipe: Recipe) in
                NavigationLink(value: recipe) {
                    HStack {
                        LazyImage(url: recipe.imageURL) { state in
                            if let image = state.image {
                                image.resizingMode(.aspectFill)
                            } else {
                                Color.blue.opacity(0.1)
                            }
                        }
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
 
                        Text(recipe.title)
                            .font(.headline)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
            .refreshable {
                viewModel.refresh()
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { text in
                viewModel.refresh(searchText: text)
            }
        }
        .navigationTitle(viewModel.title)
    }
}
