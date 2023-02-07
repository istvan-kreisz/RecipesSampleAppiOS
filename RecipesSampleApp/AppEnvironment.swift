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
//        self.recipeWebRepository = RealRecipeWebRepository(session: configuredURLSession, baseURL: "https://europe-west1-recipessampleapp-d5a1f.cloudfunctions.net")
        self.recipeWebRepository = RealRecipeWebRepository(session: configuredURLSession, baseURL: "http://127.0.0.1:5001/recipessampleapp-d5a1f/europe-west1")
        self.recipeService = RealRecipeService(recipeDBRepository: recipeDBRepository, recipeWebRepository: recipeWebRepository)
    }
}


