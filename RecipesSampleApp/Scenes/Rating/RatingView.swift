//
//  RatingView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation
import SwiftUI

struct RatingView: ViewWithUser {
    // MARK: Stored Properties

    @State var comment = ""
    @State var showAddRatingModal = false
    @ObservedObject var viewModel: RatingViewModel

    // MARK: Views

    var body: some View {
        List {
            ForEach(viewModel.recipe.ratings) { rating in
                RatingCell(author: rating.author, comment: rating.comment)
            }
        }
        .font(.headline)
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
    }
}
