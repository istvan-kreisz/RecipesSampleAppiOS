//
//  RatingCell.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/20/23.
//

import SwiftUI

struct RatingCell: View {
    let author: String
    let comment: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(author)
                Spacer()
            }

            if let comment = comment {
                Text(comment)
                    .font(.body)
            }
        }
        .padding(.vertical, 8)
    }
}
