//
//  NetworkingHelpers.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/25/23.
//

import Foundation
import UIKit

protocol WebRepository {
    associatedtype API
    var session: URLSession { get }
    var baseURL: String { get }
    var authService: AuthService? { get }
}

extension WebRepository {
    private func request(endpoint: APICall, httpCodes: HTTPCodes = .success) async throws -> Data {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            let (data, response) = try await session.data(for: request)

            guard let code = (response as? HTTPURLResponse)?.statusCode else { throw APIError.unexpectedResponse }
            guard httpCodes.contains(code) else { throw APIError.httpCode(code) }

            return data
        } catch {
            log(error, logLevel: .error, logType: .network)
            if let apiError = error as? APIError {
                if case let APIError.httpCode(code) = apiError {
                    if code == 401 {
                        Task {
                            try? await authService?.signOut()
                        }
                    }
                }
            }
            throw error
        }
    }

    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) async throws -> Value where Value: Decodable {
        let data = try await request(endpoint: endpoint, httpCodes: httpCodes)
        let model = try JSONDecoder().decode(Value.self, from: data)
        return model
    }

    func call(endpoint: APICall, httpCodes: HTTPCodes = .success) async throws {
        _ = try await request(endpoint: endpoint, httpCodes: httpCodes)
    }

    func downloadImage(endpoint: APICall, httpCodes: HTTPCodes = .success) async throws -> UIImage {
        let data = try await request(endpoint: endpoint, httpCodes: httpCodes)

        guard let image = UIImage(data: data) else { throw APIError.imageDeserialization }

        return image
    }

    func paginatedFetch<T>(paginationState: PaginationState<T>,
                           loadMore: Bool,
                           getLastLoadedPath: (_ lastLoadedItem: T) -> [String],
                           getEndPoint: (_ lastLoadedPath: [String]?) -> APICall) async throws -> (result: PaginatedResult<[T]>, paginationState: PaginationState<T>) {
        var lastLoadedPath: [String]? = nil
        if loadMore {
            if let lastLoadedItem = paginationState.lastLoaded, !paginationState.isLastPage {
                lastLoadedPath = getLastLoadedPath(lastLoadedItem)
            } else {
                return (result: .init(data: [], isLastPage: true), paginationState: paginationState.setLastPage(true))
            }
        }
        let result: PaginatedResult<[T]> = try await call(endpoint: getEndPoint(lastLoadedPath))
        return (result: result, paginationState: .init(lastLoaded: result.data.last, isLastPage: result.isLastPage))
    }
}
