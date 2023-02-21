//
//  AnimatedError.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/20/23.
//

import SwiftUI

@MainActor
protocol AnimatedError: AnyObject {
    var error: Error? { get set }
}

extension AnimatedError {
    func showDisappearingError(error: Error) {
        withAnimation {
            self.error = error
        }
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
            Task { @MainActor [weak self] in
                withAnimation {
                    self?.error = nil
                }
            }
        }
    }
}
