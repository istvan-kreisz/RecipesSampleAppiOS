//
//  RatingObject+CoreDataClass.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/24/23.
//
//

import Foundation
import CoreData

@objc(RatingObject)
public class RatingObject: NSManagedObject {

}

extension RatingObject {
    static func initFrom(rating: Recipe.Rating, context: NSManagedObjectContext) -> RatingObject {
        let ratingObject = RatingObject(entity: RatingObject.entity(), insertInto: context)
        ratingObject.id = rating.id
        ratingObject.author = rating.author
        ratingObject.authorId = rating.authorId
        ratingObject.comment = rating.comment
        return ratingObject
    }
}
