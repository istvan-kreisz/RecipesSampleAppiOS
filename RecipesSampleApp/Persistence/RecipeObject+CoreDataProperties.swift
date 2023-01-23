//
//  RecipeObject+CoreDataProperties.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/24/23.
//
//

import Foundation
import CoreData


extension RecipeObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeObject> {
        return NSFetchRequest<RecipeObject>(entityName: "RecipeObject")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var authorId: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var title: String?
    @NSManaged public var isVegetarian: Bool
    @NSManaged public var source: URL?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var steps: NSSet?
    @NSManaged public var ratings: NSSet?

}

// MARK: Generated accessors for ingredients
extension RecipeObject {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: SringHolderObject)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: SringHolderObject)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for steps
extension RecipeObject {

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: SringHolderObject)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: SringHolderObject)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)

}

// MARK: Generated accessors for ratings
extension RecipeObject {

    @objc(addRatingsObject:)
    @NSManaged public func addToRatings(_ value: RatingObject)

    @objc(removeRatingsObject:)
    @NSManaged public func removeFromRatings(_ value: RatingObject)

    @objc(addRatings:)
    @NSManaged public func addToRatings(_ values: NSSet)

    @objc(removeRatings:)
    @NSManaged public func removeFromRatings(_ values: NSSet)

}

extension RecipeObject : Identifiable {

}
