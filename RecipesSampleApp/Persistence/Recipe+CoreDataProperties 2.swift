//
//  Recipe+CoreDataProperties.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/23/23.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
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
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: SringHolder)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: SringHolder)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for steps
extension Recipe {

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: SringHolder)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: SringHolder)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)

}

// MARK: Generated accessors for ratings
extension Recipe {

    @objc(addRatingsObject:)
    @NSManaged public func addToRatings(_ value: Rating)

    @objc(removeRatingsObject:)
    @NSManaged public func removeFromRatings(_ value: Rating)

    @objc(addRatings:)
    @NSManaged public func addToRatings(_ values: NSSet)

    @objc(removeRatings:)
    @NSManaged public func removeFromRatings(_ values: NSSet)

}

extension Recipe : Identifiable {

}
