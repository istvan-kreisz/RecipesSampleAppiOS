//
//  SringHolder+CoreDataProperties.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/23/23.
//
//

import Foundation
import CoreData


extension SringHolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SringHolder> {
        return NSFetchRequest<SringHolder>(entityName: "SringHolder")
    }

    @NSManaged public var string: String?

}

extension SringHolder : Identifiable {

}
