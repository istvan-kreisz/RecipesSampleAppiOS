//
//  AppEnvironment.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/25/23.
//

import Foundation

@MainActor
class AppEnvironment {
    
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
        self.recipeDBRepository = RealRecipeDBRepository(persistentStore: CoreDataStack(version: CoreDataStack.Version.actual))
        self.recipeWebRepository = RealRecipeWebRepository(session: configuredURLSession, baseURL: "https://europe-west1-recipessampleapp-d5a1f.cloudfunctions.net")
        self.recipeService = RealRecipeService(recipeDBRepository: recipeDBRepository, recipeWebRepository: recipeWebRepository)
    }
}
