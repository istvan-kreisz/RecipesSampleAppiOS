//
//  Rating+CoreDataProperties.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/23/23.
//
//

import Foundation
import CoreData


extension Rating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rating> {
        return NSFetchRequest<Rating>(entityName: "Rating")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var author: String?
    @NSManaged public var authorId: String?
    @NSManaged public var comment: String?

}

extension Rating : Identifiable {

}
