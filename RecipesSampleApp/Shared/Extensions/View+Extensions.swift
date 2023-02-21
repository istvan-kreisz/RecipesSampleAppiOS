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

    func withErrorAlert(error: Binding<Error?>) -> some View {
        let isAlertPresented = Binding<Bool>(get: { error.wrappedValue != nil },
                                             set: { newValue in
                                                 if !newValue {
                                                     error.wrappedValue = nil
                                                 }
                                             })
        return self
            .alert("Error", isPresented: isAlertPresented, actions: {
                Button("Okay", role: .cancel) {}
            }, message: {
                if let error = error.wrappedValue {
                    if let reachabilityError = error as? ReachabilityError {
                        switch reachabilityError {
                        case .offline:
                            Text("No internet connection")
                        }
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            })
    }
}
