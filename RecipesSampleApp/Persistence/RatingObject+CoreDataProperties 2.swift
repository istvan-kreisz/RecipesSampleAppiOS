//
//  RatingObject+CoreDataProperties.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/24/23.
//
//

import Foundation
import CoreData


extension RatingObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RatingObject> {
        return NSFetchRequest<RatingObject>(entityName: "RatingObject")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var author: String?
    @NSManaged public var authorId: String?
    @NSManaged public var comment: String?

}

extension RatingObject : Identifiable {

}
