//
//  ErrorBanner.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/20/23.
//

import SwiftUI

struct ErrorBanner: View {
    let errorMessage: String

    var body: some View {
        Text(errorMessage)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .padding(10)
            .frame(width: UIScreen.main.bounds.width - 40)
            .background(Color.red)
            .cornerRadius(10)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}
