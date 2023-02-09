//
//  RatingStars.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct RatingStars: View {
    let rating: Int

    var body: some View {
        HStack(spacing: 0) {
            star(isFilled: true)
            star(isFilled: rating > 1)
            star(isFilled: rating > 2)
            star(isFilled: rating > 3)
            star(isFilled: rating > 4)
        }
    }

    private func star(isFilled: Bool) -> some View {
        Image(systemName: isFilled ? "star.fill" : "star")
    }

}
