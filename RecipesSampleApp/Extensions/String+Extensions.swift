//
//  String+Extensions.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/21/23.
//

import Foundation

extension String {
    func fuzzyMatch(_ needle: String) -> Bool {
        if needle.isEmpty { return true }
        var remainder: String.SubSequence = needle[...]
        for char in self {
            let currentChar = remainder[remainder.startIndex]
            if char == currentChar {
                remainder.removeFirst()
                if remainder.isEmpty { return true }
            }
        }
        return false
    }
}
