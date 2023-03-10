//
//  EndOfListLoader.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 3/1/23.
//

import SwiftUI

struct EndOfListLoader: View {
    let loadingText: String
    let isEndOfList: Bool
    let isEmpty: Bool
    let loadMore: () async throws -> Void

    var body: some View {
        if isEndOfList {
            Text(isEmpty ? "Nothing here" : "That's it!")
                .padding(.top, 21)
                .centeredHorizontally()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden, edges: .all)
        } else {
            Spinner(text: loadingText)
                .padding(.top, 21)
                .centeredHorizontally()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden, edges: .all)
                .onAppear {
                    if !isEndOfList {
                        Task {
                            try await loadMore()
                        }
                    }
                }
        }
    }
}
