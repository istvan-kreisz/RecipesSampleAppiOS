//
//  CoreDataStack.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/21/23.
//

import CoreData
import Combine

protocol PersistentStore {
    typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
    var container: NSPersistentContainer { get }

    func count<T>(_ fetchRequest: NSFetchRequest<T>) async throws -> Int
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>,
                     context: NSManagedObjectContext,
                     map: @escaping (T) throws -> V?) async throws -> [V]
    @discardableResult func update<Result>(_ operation: @escaping DBOperation<Result>) async throws -> Result
}

extension PersistentStore {
    @MainActor
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping (T) throws -> V?) async throws -> [V] {
        assert(Thread.isMainThread)
        return try await fetch(fetchRequest, context: container.viewContext, map: map)
    }
}

enum CoreDataError: Error {
    case storeNotLoaded
    case notFound
}

class CoreDataStack: PersistentStore {
    private var continuations: [CheckedContinuation<Bool, Error>] = []
    let container: NSPersistentContainer
    private var isStoreLoaded: Result<Bool, Error> = .success(false) {
        didSet {
            continuations.forEach { continuation in
                switch isStoreLoaded {
                case let .success(value):
                    if value {
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(throwing: CoreDataError.storeNotLoaded)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
            continuations.removeAll()
        }
    }

    init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
         version vNumber: UInt) {
        let version = Version(vNumber)
        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFileURL(directory, domainMask) {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }

        container.loadPersistentStores { [weak self] storeDescription, error in
            if let error = error {
                self?.isStoreLoaded = .failure(error)
            } else {
                self?.container.viewContext.configureAsReadOnlyContext()
                self?.isStoreLoaded = .success(true)
            }
        }
    }

    @MainActor
    func count<T>(_ fetchRequest: NSFetchRequest<T>) async throws -> Int {
        assert(Thread.isMainThread)
        try await onStoreIsReady()
        let count = try container.viewContext.count(for: fetchRequest)
        return count
    }

    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>,
                     context: NSManagedObjectContext,
                     map: @escaping (T) throws -> V?) async throws -> [V] {
        try await onStoreIsReady()

        let result = try context.performAndWait { [weak context] () -> [T] in
            guard let managedObjects = try context?.fetch(fetchRequest) else { return [] }
            return managedObjects
        }
        return result.compactMap { try? map($0) }
    }

    @discardableResult func update<Result>(_ operation: @escaping DBOperation<Result>) async throws -> Result {
        try await onStoreIsReady()

        let context = container.newBackgroundContext()
        context.configureAsUpdateContext()
        let result = try context.performAndWait {
            do {
                let result = try operation(context)
                if context.hasChanges {
                    try context.save()
                }
                context.reset()
                return result
            } catch {
                context.reset()
                throw error
            }
        }
        return result
    }

    #warning("should only be accessed from one serial thread")
    private func onStoreIsReady() async throws {
        switch isStoreLoaded {
        case let .success(value):
            if value {
                return
            } else {
                let didLoad = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
                    continuations.append(continuation)
                }
                if !didLoad {
                    throw CoreDataError.storeNotLoaded
                }
            }
        case let .failure(error):
            throw error
        }
    }
}

// MARK: - Versioning

extension CoreDataStack.Version {
    static var actual: UInt { 1 }
}

extension CoreDataStack {
    struct Version {
        private let number: UInt

        init(_ number: UInt) {
            self.number = number
        }

        var modelName: String {
            "db_model_v1"
        }

        func dbFileURL(_ directory: FileManager.SearchPathDirectory, _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            FileManager.default.urls(for: directory, in: domainMask).first?.appendingPathComponent(subpathToDB)
        }

        private var subpathToDB: String {
            "db.sql"
        }
    }
}
