//
//  PaginatedViewModel.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/22/23.
//

import SwiftUI

@MainActor
protocol PaginatedViewModel: AnyObject {
    associatedtype T: Equatable, Codable, Identifiable
    var fetchResult: PaginatedResult<[T]> { get set }
    var error: Error? { get set }
}

extension PaginatedViewModel {
    func loadItems(reload: Bool, fetchBlock: @escaping (_ reload: Bool) async throws -> PaginatedResult<[T]>) async throws {
        do {
            let newFetchResult = try await fetchBlock(reload)
            if reload {
                fetchResult = newFetchResult
            } else {
                let currentRecipeIds = fetchResult.data.map(\.id)
                fetchResult.data += newFetchResult.data.filter { !currentRecipeIds.contains($0.id) }
                fetchResult.isLastPage = newFetchResult.isLastPage
            }
        } catch {
            self.error = error
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                Task { @MainActor [weak self] in
                    withAnimation {
                        self?.error = nil
                    }
                }
            }
        }
    }

    var items: [T] {
        fetchResult.data
    }

    var isEndOfList: Bool {
        fetchResult.isLastPage
    }
}
