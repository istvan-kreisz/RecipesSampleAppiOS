//
//  MockRecipeService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import Foundation

@MainActor
class MockRecipeService: RecipeService {
    static let authorId1 = UUID(uuidString: "122d6856-a7ac-11ed-afa1-0242ac120002")!.uuidString
    static let authorId2 = UUID(uuidString: "122d6b8a-a7ac-11ed-afa1-0242ac120002")!.uuidString
    static let authorId3 = UUID(uuidString: "122d71f2-a7ac-11ed-afa1-0242ac120002")!.uuidString

    private let badRating: Rating
    private let averageRating: Rating
    private let goodRating: Rating

    init() {
        self.badRating = Rating(author: "Jupiter Jones",
                                authorId: Self.authorId1,
                                comment: "One word: Disgusting.",
                                dateAdded: Date(timeIntervalSinceNow: -100))
        self.averageRating = Rating(author: "Peter Crenshaw",
                                    authorId: Self.authorId2,
                                    comment: "Well, it was alright...",
                                    dateAdded: Date(timeIntervalSinceNow: -80))
        self.goodRating = Rating(author: "Robert Andrews",
                                 authorId: Self.authorId3,
                                 comment: "Best. Dish. Ever.",
                                 dateAdded: Date(timeIntervalSinceNow: -60))
    }

    private lazy var recipes =
        [Recipe(authorId: Self.authorId1,
                imageURL: URL(string: "https://publicdomainrecipes.org/recipes/orange-marmalade/Orange%20Marmalade_hu0aa2f9bacaf3459fa40fd69ec9d06da6_94464_350x350_fill_q75_box_smart1.jpg"),
                title: "Orange Marmalade",
                ingredients: ["12 oranges", "6 lemons", "1 gallon water", "10 pound sugar"],
                steps: ["Clean fruit with stiff brush and wipe dry; cut crosswise in very thin slices, reject the ends, pick out the seeds.",
                        "Pour the water over the fruit and let stand 36 hours.",
                        "Then put in preserving kettle and let cook slowly 2 hours.",
                        "Then add sugar and cook 1 hour or until the mixture jellies."],
                isVegetarian: true,
                source: URL(string: "https://publicdomainrecipes.org/recipes/orange-marmalade/"), dateAdded: Date(timeIntervalSinceNow: -100),
                ratings: [self.averageRating, self.badRating]),
         Recipe(authorId: Self.authorId1,
                imageURL: URL(string: "https://publicdomainrecipes.org/recipes/mushrooms-in-cream/Mushrooms%20in%20Cream_hu46031e1ef57493efe9e56c814b513ee6_41786_350x350_fill_q75_box_smart1.jpg"),
                title: "Mushrooms in Cream",
                ingredients: ["1/2 pound mushrooms",
                              "3 tablespoon butter",
                              "salt",
                              "pepper",
                              "flour",
                              "3/4 cup cream",
                              "toast"],
                steps: ["Wash mushrooms; remove stems, and peel caps, and cut in pieces; melt butter and cook until tender; sprinkle with salt and pepper; dredge with flour and add cream.",
                        "Let cook until heated thoroughly, then pour on pieces of toast and garnish with toast points."],
                isVegetarian: true,
                source: URL(string: "https://publicdomainrecipes.org/recipes/mushrooms-in-cream/"),
                dateAdded: Date(timeIntervalSinceNow: -80),
                ratings: [self.averageRating, self.goodRating, self.badRating]),
         Recipe(authorId: Self.authorId2,
                imageURL: URL(string: "https://publicdomainrecipes.org/recipes/roasted-wild-duck/Roasted%20Wild%20Duck_hu004b736d43b2db0e2f8c86e13334b46b_78997_350x350_fill_q75_box_smart1.jpg"),
                title: "Roasted Wild Duck",
                ingredients: ["duck",
                              "alcohol",
                              "soda water",
                              "onion",
                              "sage",
                              "celery salt",
                              "bacon",
                              "pepper",
                              "flour"],
                steps: ["Take a plump, young duck; rub all over with alcohol and then hold over the burner to singe; wash thoroughly with soda water; then boil in soda water or water in which there is a little onion for 10 minutes before stuffing; then rinse in clear water and wipe dry; stuff with dressing, to which has been added a little onion, sage, celery salt or bacon chopped fine; sprinkle with pepper and salt and dredge with flour; place pieces of bacon over it.",
                        "Roast under the flame until tender, turning and basting frequently with the tried out fat."],
                isVegetarian: false,
                source: URL(string: "https://publicdomainrecipes.org/recipes/roasted-wild-duck/"), dateAdded: Date(timeIntervalSinceNow: -90),
                ratings: [self.averageRating, self.goodRating]),
         Recipe(authorId: Self.authorId3,
                imageURL: URL(string: "https://publicdomainrecipes.org/recipes/roast-lamb-with-banana-croquettes/Roast%20Lamb%20with%20Banana%20Croquettes_hu877c9bedf9d18b9a490347620c64b440_55965_350x350_fill_q75_box_smart1.jpg"),
                title: "Roast Lamb with Banana Croquettes",
                ingredients: ["lamb",
                              "salt",
                              "pepper",
                              "flour",
                              "bacon",
                              "water",
                              "parsley",
                              "bananas",
                              "lemon juice",
                              "egg",
                              "bread crumbs",
                              "powdered sugar"],
                steps: ["Remove the superfluous fat from a leg of lamb and score the thin layer of fat on the outer side of the leg diagonally; rub over with salt and pepper; dredge with flour, and set on the rack in the baking pan.",
                        "Have the oven very hot at first, to sear over the outside; after 15 minutes reduce the heat and let cook about 2 hours; baste frequently with bacon fat melted in hot water.",
                        "Remove to a serving dish; slip a paper frill over the bone, and garnish with parsley and banana croquettes.",
                        "Remove the skin and coarse threads from the bananas and trim the pulp of each to a cylinder-shape croquette; coat each with lemon juice to keep from discoloring; then roll in egg and then in sifted bread crumbs; fry in deep fat, and dust with powdered sugar."],
                isVegetarian: false,
                source: URL(string: "https://publicdomainrecipes.org/recipes/roast-lamb-with-banana-croquettes/"),
                dateAdded: Date(timeIntervalSinceNow: -100),
                ratings: [self.averageRating])]

    func fetchRatings(for recipe: Recipe, loadMore: Bool) async -> PaginatedResult<[Rating]> {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            return .init(data: recipes[index].ratings, isLastPage: true)
        } else {
            return .init(data: [], isLastPage: true)
        }
    }

    func fetchAllRecipes(searchText: String, loadMore: Bool) async -> PaginatedResult<[Recipe]> {
        let recipes = recipes.filter { $0.isMatching(searchText) }
        return .init(data: recipes, isLastPage: true)
    }

    func fetchRecipes(createdBy user: User, searchText: String, loadMore: Bool) async -> PaginatedResult<[Recipe]> {
        let recipes = recipes.filter { $0.authorId == user.id && $0.isMatching(searchText) }
        return .init(data: recipes, isLastPage: true)
    }

    func add(recipe: Recipe) {
        recipes.append(recipe)
    }

    func add(rating: Rating, to recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            var newRecipe = recipe
            newRecipe.ratings.append(rating)
            recipes[index] = newRecipe
        }
    }
}
