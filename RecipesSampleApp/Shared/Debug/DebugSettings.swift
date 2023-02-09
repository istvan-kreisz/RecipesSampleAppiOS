//
//  DebugSettings.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/7/23.
//

import Foundation

struct DebugSettings {
    let isInDebugMode: Bool

    private init() {
        #if DEBUG
            isInDebugMode = true
        #else
            isInDebugMode = false
        #endif
    }

    static let shared = DebugSettings()

    struct Credentials {
        let username: String
        let password: String
    }

    var loginCredentials: Credentials? {
        guard isInDebugMode else { return nil }
        if let username = string(for: "username"), let password = string(for: "password") {
            return .init(username: username, password: password)
        } else {
            return nil
        }
    }

    private func string(for key: String) -> String? {
        guard isInDebugMode else { return nil }
        return ProcessInfo.processInfo.environment[key]
    }

    private func bool(for key: String) -> Bool {
        guard let value = string(for: key) else { return false }
        return Bool(value) ?? false
    }

    private func double(for key: String) -> Double? {
        guard let value = string(for: key) else { return nil }
        return Double(value)
    }
    
    var logLevel: LogLevel {
        if let string = string(for: "logLevel") {
            return LogLevel(rawValue: string) ?? .error
        } else {
            return .error
        }
    }

    var clearUserDefaults: Bool {
        bool(for: "clearUserDefaults")
    }
    
    var useEmulators: Bool {
        bool(for: "useEmulators")
    }
    
    var clearCoreData: Bool {
        bool(for: "clearCoreData")
    }
}
