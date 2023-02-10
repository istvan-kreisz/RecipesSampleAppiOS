//
//  RealUserDBRepository.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/8/23.
//

import Foundation
import CoreData

#warning("delete?")
class RealUserDBRepository: UserDBRepository {
    
    let persistentStore: PersistentStore

    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func fetchUser(userId: String) async throws -> User {
        let fetchRequest = UserObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        fetchRequest.fetchLimit = 1
        let result = try await persistentStore.fetch(fetchRequest) { User(from: $0) }
        guard let user = result.first else {
            throw CoreDataError.notFound
        }
        return user
    }
}
