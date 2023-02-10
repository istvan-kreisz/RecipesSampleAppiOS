//
//  Logger.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/7/23.
//

import Foundation

enum LogLevel: String, CaseIterable {
    case debug, warning, error
}

enum LogType: String {
    case database, cache, auth, network
}

func log(_ value: Any, logLevel: LogLevel, logType: LogType? = nil) {
    guard DebugSettings.shared.isInDebugMode,
          LogLevel.allCases.firstIndex(of: logLevel)! >= LogLevel.allCases.firstIndex(of: DebugSettings.shared.logLevel)!
    else { return }
    
    let logLevelEmojis: [LogLevel: String] = [.debug: "🐞", .warning: "⚠️", .error: "⛔️"]
    let logTypeEmojis: [LogType: String] = [.database: "Database 💾", .cache: "Cache 💿", .auth: "Auth 👤", .network: "Network 🌐"]
    
    let logLevelEmoji = logLevelEmojis[logLevel] ?? ""
    let logTypeEmoji = logType.map { logTypeEmojis[$0] ?? "" } ?? "🖨️"
    
    print("---> \(logLevelEmoji) \(logTypeEmoji)")
    print(value)
    print("*****************************************")
}
