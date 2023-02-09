//
//  UserObject+CoreDataClass.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/8/23.
//
//

import Foundation
import CoreData

@objc(UserObject)
public class UserObject: NSManagedObject {
    static func initFrom(user: User, context: NSManagedObjectContext) -> UserObject {
        let userObject = UserObject(entity: UserObject.entity(), insertInto: context)
        userObject.id = user.id
        userObject.name = user.name
        userObject.email = user.email
        userObject.dateAdded = user.dateAdded
        return userObject
    }
}
