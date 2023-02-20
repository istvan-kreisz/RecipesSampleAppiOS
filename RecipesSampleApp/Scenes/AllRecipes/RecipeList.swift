//
//  RecipeList.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct RecipeList<ViewModel>: View where ViewModel: RecipesViewModel {
    @ObservedObject var viewModel: ViewModel
    @State var searchText = ""

    var body: some View {
        VStack {
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(10)
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .background(Color.red)
                    .cornerRadius(10)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            List(viewModel.recipes) { (recipe: Recipe) in
                NavigationLink(value: recipe) {
                    HStack {
                        AsyncImage(url: recipe.imageURL) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                            } else {
                                Color.blue.opacity(0.1)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                            }
                        }
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
