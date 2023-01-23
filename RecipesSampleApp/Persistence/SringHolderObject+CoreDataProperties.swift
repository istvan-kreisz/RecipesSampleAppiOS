//
//  SringHolderObject+CoreDataProperties.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/24/23.
//
//

import Foundation
import CoreData


extension SringHolderObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SringHolderObject> {
        return NSFetchRequest<SringHolderObject>(entityName: "SringHolderObject")
    }

    @NSManaged public var string: String?

}

extension SringHolderObject : Identifiable {

}
