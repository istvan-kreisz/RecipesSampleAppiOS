//
//  User.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/7/23.
//

import Foundation

struct User: Equatable {
    var id = UUID()
    let name: String
    let email: String
    let dateAdded: Date
}

extension User {
    init?(from userObject: UserObject) {
        guard let id = userObject.id,
              let name = userObject.name,
              let email = userObject.email,
              let dateAdded = userObject.dateAdded
        else { return nil }
        self.id = id
        self.name = name
        self.email = email
        self.dateAdded = dateAdded
    }
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id, email, name, dateAdded
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(dateAdded, forKey: .dateAdded)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        dateAdded = try container.decode(Date.self, forKey: .dateAdded)
    }
}

extension User: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(User.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return result
    }
}
