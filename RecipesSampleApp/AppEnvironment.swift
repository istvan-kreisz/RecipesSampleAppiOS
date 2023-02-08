//
//  AppEnvironment.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/25/23.
//

import Foundation

@MainActor
class AppEnvironment {
    let authService: AuthService
    let recipeDBRepository: RecipeDBRepository
    let recipeWebRepository: RecipeWebRepository
    let recipeService: RecipeService

    private let baseURL: String = {
        !DebugSettings.shared.ipAddress.isEmpty ?
            "http://\(DebugSettings.shared.ipAddress):5001/recipessampleapp-d5a1f/europe-west1" :
            "https://europe-west1-recipessampleapp-d5a1f.cloudfunctions.net"
    }()

    static let shared = AppEnvironment()

    private var configuredURLSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()

    private init() {
        self.authService = RealAuthService()
        self.recipeDBRepository = RealRecipeDBRepository(persistentStore: CoreDataStack(version: CoreDataStack.Version.actual))
        self.recipeWebRepository = RealRecipeWebRepository(session: configuredURLSession, baseURL: baseURL)
        self.recipeService = RealRecipeService(recipeDBRepository: recipeDBRepository, recipeWebRepository: recipeWebRepository)
    }
}
