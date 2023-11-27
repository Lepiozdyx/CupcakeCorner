//
//  Order.swift
//  CupcakeCorner
//
//  Created by Alex on 25.11.2023.
//

import Foundation

@Observable
final class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = "" {
        didSet { save() }
    }
    var streetAddress = "" {
        didSet { save() }
    }
    var city = "" {
        didSet { save() }
    }
    var zip = "" {
        didSet { save() }
    }
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        // complicated cakes cost more
        cost += Decimal(type) / 2
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    // saving and loading an instance from UserDefaults
    private let userDefaultsKey = "SavedOrder"
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    init() {
        if let savedOrder = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: savedOrder) {
                name = decodedOrder.name
                streetAddress = decodedOrder.streetAddress
                city = decodedOrder.city
                zip = decodedOrder.zip
            }
        }
    }
}
