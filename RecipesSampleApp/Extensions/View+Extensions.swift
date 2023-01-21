//
//  View+Extensions.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/21/23.
//

import SwiftUI

extension View {
    func leftAligned(spacing: CGFloat? = nil) -> some View {
        HStack(spacing: spacing) {
            self
            Spacer()
        }
    }

    func rightAligned(spacing: CGFloat? = nil) -> some View {
        HStack(spacing: spacing) {
            Spacer()
            self
        }
    }

    func topAligned(spacing: CGFloat? = nil) -> some View {
        VStack(spacing: spacing) {
            self
            Spacer()
        }
    }

    func bottomAligned(spacing: CGFloat? = nil) -> some View {
        VStack(spacing: spacing) {
            Spacer()
            self
        }
    }

    func centeredVertically(spacing: CGFloat? = nil) -> some View {
        VStack(spacing: spacing) {
            Spacer()
            self
            Spacer()
        }
    }

    func centeredHorizontally(spacing: CGFloat? = nil) -> some View {
        HStack(spacing: spacing) {
            Spacer()
            self
            Spacer()
        }
    }
}
