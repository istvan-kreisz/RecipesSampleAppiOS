//
//  UserObject+CoreDataProperties.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/8/23.
//
//

import Foundation
import CoreData


extension UserObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserObject> {
        return NSFetchRequest<UserObject>(entityName: "UserObject")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?

}

extension UserObject : Identifiable {

}
