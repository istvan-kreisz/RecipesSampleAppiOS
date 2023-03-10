//
//  RatingView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import SwiftUI

struct RatingView: View {
    @State var comment = ""
    @State var showAddRatingModal = false
    @ObservedObject var viewModel: RatingViewModel

    var body: some View {
        VStack {
            if let error = viewModel.error {
                ErrorBanner(errorMessage: error.localizedDescription)
            }
            List {
                ForEach(viewModel.ratings) { rating in
                    RatingCell(author: rating.author, comment: rating.comment)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden, edges: .all)
                }
                EndOfListLoader(loadingText: "Loading ratings...", isEndOfList: viewModel.isEndOfList, isEmpty: viewModel.ratings.isEmpty) {
                    if viewModel.ratings.isEmpty {
                        try await viewModel.refresh()
                    } else {
                        try await viewModel.loadMore()
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                try? await viewModel.refresh()
            }
        }
        .onChange(of: viewModel.fetchResult, perform: { newValue in
            print("-----------")
            print(newValue)
        })
        .navigationTitle(viewModel.recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button("Close", action: {
            viewModel.close()
        }), trailing: viewModel.canAddRating ? Button(action: {
            comment = ""
            showAddRatingModal = true
        }, label: {
            Image(systemName: "plus")
        }) : nil)
        .alert("Add a rating", isPresented: $showAddRatingModal) {
            TextField("Add a comment", text: $comment)
            Button {
                viewModel.addRating(comment: comment)
            } label: {
                Text("Add a rating")
            }
        }
        .withErrorAlert(error: $viewModel.error)
    }
}
