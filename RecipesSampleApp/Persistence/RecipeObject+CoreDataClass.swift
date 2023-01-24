//
//  RecipeObject+CoreDataClass.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/24/23.
//
//

import Foundation
import CoreData

@objc(RecipeObject)
public class RecipeObject: NSManagedObject {
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
