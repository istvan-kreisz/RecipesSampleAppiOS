//
//  Spinner.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/22/23.
//

import SwiftUI

struct Spinner: View {
    let text: String?

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ProgressView()
                .progressViewStyle(.circular)
            if let text = text {
                Text(text)
                    .font(.caption2)
            }
            Spacer()
        }
    }
}
