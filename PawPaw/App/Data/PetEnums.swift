//
//  PetEnums.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

enum PetType: String {
    case unknown = ""
    case cat = "cat"
    case dog = "dog"
    
    static var allTypes: [PetType] {
        return [.cat, .dog]
    }
}

enum Size: String {
 
    case unknown = ""
    case extraSmall = "extra small"
    case small = "small"
    case medium = "medium"
    case large = "large"
    case extraLarge = "extra large"
    
    var formattedValue: String {
        get {
            switch self {
            case .unknown:
                return "Unknown"
            case .extraSmall:
                return "Extra Small"
            case .small:
                return "Small"
            case .medium:
                return "Medium"
            case .large:
                return "Large"
            case .extraLarge:
                return "Extra Large"
            }
        }
    }
    
    static var allSizes: [Size] {
        get {
            return [.extraSmall, .small, .medium, .large, .extraLarge]
        }
    }
    
}

enum Age: String {

    case unknown = ""
    case baby = "baby"
    case young = "young"
    case adult = "adult"
    case senior = "senior"
    
    var formattedValueForCat: String {
        if self == .baby {
            return "Kitten"
        }
        return self.defaultFormattedValue()
    }
    
    var formattedValueForDog: String {
        if self == .baby {
            return "Puppy"
        }
        return self.defaultFormattedValue()
    }
    
    private func defaultFormattedValue() -> String {
        if self == .young {
            return "Young"
        }
        else if self == .adult {
            return "Adult"
        }
        else if self == .senior {
            return "Senior"
        }
        return "Unknown"
    }
    
    static var allAges: [Age] {
        get {
            return [.baby, .young, .adult, .senior]
        }
    }
    
}

enum Gender: String {
    
    case unknown = ""
    case female = "female"
    case male = "male"
    
    var formattedValue: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
    
    static var allGenders: [Gender] {
        return [.female, .male]
    }
    
}
