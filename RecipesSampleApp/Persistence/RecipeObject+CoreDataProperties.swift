//
//  RecipeObject+CoreDataProperties.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/24/23.
//
//

import Foundation
import CoreData

public extension RecipeObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<RecipeObject> {
        return NSFetchRequest<RecipeObject>(entityName: "RecipeObject")
    }

    @NSManaged var id: UUID?
    @NSManaged var authorId: String?
    @NSManaged var imageURL: URL?
    @NSManaged var title: String?
    @NSManaged var isVegetarian: Bool
    @NSManaged var source: URL?
    @NSManaged var dateAdded: Date?
    @NSManaged var steps: [String]?
    @NSManaged var ingredients: [String]?
    @NSManaged var ratings: NSSet?
}

// MARK: Generated accessors for ratings

public extension RecipeObject {
    @objc(addRatingsObject:)
    @NSManaged func addToRatings(_ value: RatingObject)

    @objc(removeRatingsObject:)
    @NSManaged func removeFromRatings(_ value: RatingObject)

    @objc(addRatings:)
    @NSManaged func addToRatings(_ values: NSSet)

    @objc(removeRatings:)
    @NSManaged func removeFromRatings(_ values: NSSet)
}

extension RecipeObject: Identifiable {}

extension RecipeObject {
    static func initFrom(recipe: Recipe, context: NSManagedObjectContext) -> RecipeObject {
        let recipeObject = RecipeObject(entity: RecipeObject.entity(), insertInto: context)
        recipeObject.id = recipe.id
        recipeObject.authorId = recipe.authorId
        recipeObject.imageURL = recipe.imageURL
        recipeObject.title = recipe.title
        recipeObject.isVegetarian = recipe.isVegetarian
        recipeObject.source = recipe.source
        recipeObject.dateAdded = recipe.dateAdded
        recipeObject.steps = recipe.steps
        recipeObject.ingredients = recipe.ingredients
        recipeObject.ratings = []
        return recipeObject
    }
}
