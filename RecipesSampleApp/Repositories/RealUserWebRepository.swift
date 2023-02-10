//
//  RealUserWebRepository.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/10/23.
//

import Foundation

class RealUserWebRepository: UserWebRepository {
    let session: URLSession
    let baseURL: String

    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func fetchUser(userId: String) async throws -> User {
        try await call(endpoint: API.fetchUser(userId: userId))
    }
}

extension RealUserWebRepository {
    enum API {
        case fetchUser(userId: String)
    }
}

extension RealUserWebRepository.API: APICall {
    var path: String {
        switch self {
        case .fetchUser:
            return "fetchUser"
        }
    }

    var method: String {
        "POST"
    }

    var headers: [String: String]? {
        ["Accept": "application/json",
         "Content-Type": "application/json",
         "Authorization": "Bearer \(UserDefaults.standard.idToken ?? "")"]
    }

    func body() throws -> Data? {
        switch self {
        case let .fetchUser(userId):
            struct Payload: Encodable {
                let userId: String
            }
            return try data(body: Payload(userId: userId))
        }
    }
}
