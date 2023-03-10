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
            List {
                ForEach(viewModel.recipes) { (recipe: Recipe) in
                    NavigationLink(value: recipe) {
                        HStack {
                            LazyImage(url: recipe.imageURL) { state in
                                if let image = state.image {
                                    image.resizingMode(.aspectFill)
                                } else {
                                    Color.blue.opacity(0.1)
                                }
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)

                            Text(recipe.title)
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden, edges: .all)
                }.frame(height: 70)
                
                EndOfListLoader(loadingText: "Loading recipes...", isEndOfList: viewModel.isEndOfList, isEmpty: viewModel.recipes.isEmpty) {
                    if viewModel.recipes.isEmpty {
                        try await viewModel.refresh(searchText: searchText)
                    } else {
                        try await viewModel.loadMore(searchText: searchText)
                    }
                }
                
                Spacer(minLength: 50)
                    .listRowSeparator(.hidden, edges: .all)
            }
            .listStyle(.plain)
            .refreshable {
                try? await viewModel.refresh(searchText: searchText)
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { text in
                Task {
                    try await viewModel.refresh(searchText: text)
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}
