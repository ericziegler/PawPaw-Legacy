//
//  Pet.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

// MARK: Constants

let PetIdentifierCacheKey = "PetIdentifierCacheKey"
let PetShelterIdCacheKey = "PetShelterIdCacheKey"
let PetShelterAddressCacheKey = "PetShelterAddressCacheKey"
let PetShelterCityCacheKey = "PetShelterCityCacheKey"
let PetShelterStateCacheKey = "PetShelterStateCacheKey"
let PetShelterZipCacheKey = "PetShelterZipCacheKey"
let PetShelterPhoneCacheKey = "PetShelterPhoneCacheKey"
let PetShelterFormattedPhoneCacheKey = "PetShelterFormattedPhoneCacheKey"
let PetShelterEmailCacheKey = "PetShelterEmailCacheKey"
let PetPhotoURLsCacheKey = "PetPhotoURLsCacheKey"
let PetNameCacheKey = "PetNameCacheKey"
let PetBreedCacheKey = "PetBreedCacheKey"
let PetStoryCacheKey = "PetStoryCacheKey"
let PetTypeCacheKey = "PetTypeCacheKey"
let PetAgeCacheKey = "PetAgeCacheKey"
let PetGenderCacheKey = "PetGenderCacheKey"
let PetSizeCacheKey = "PetSizeCacheKey"
let PetHasShotsCacheKey = "PetHasShotsCacheKey"
let PetIsHouseTrainedCacheKey = "PetIsHouseTrainedCacheKey"
let PetIsAlteredCacheKey = "PetIsAlteredCacheKey"

class Pet: NSObject, NSCoding {

    // MARK: Properties
    
    var identifier: String = ""
    var shelterId: String = ""
    var shelterAddress: String = ""
    var shelterCity: String = ""
    var shelterState: String = ""
    var shelterZip: String = ""
    var shelterPhone: String = ""
    var shelterFormattedPhone: String = ""
    var shelterEmail: String = ""
    var photoURLs: [String] = [String]()
    var name: String = ""
    var breed: String = ""
    var story: String = ""
    var petType: PetType = .unknown
    var age: Age = .unknown
    var gender: Gender = .unknown
    var size: Size = .unknown
    var hasShots: Bool = false
    var isHouseTrained: Bool = false
    var isAltered: Bool = false
    var isFavorited: Bool = false
    
    var alteredDisplayText: String {
        get {
            var result = "Unknown"
            
            if self.isAltered {
                if self.gender == .male {
                    result = "Neutered"
                }
                else if self.gender == .female {
                    result = "Spayed"
                }
            }
            
            return result
        }
    }
    
    var isValidPet: Bool {
        get {
            if self.petType != .unknown && self.identifier.characters.count > 0 && self.shelterId.characters.count > 0 && self.name.characters.count > 0 && self.photoURLs.count > 0 {
                return true
            }
            return false
        }
    }
    
    // MARK: Init + Coding
    
    override init() {
        super.init()
    }
    
    required init?(coder decoder: NSCoder) {
        if let cachedIdentifier = decoder.value(forKey: PetIdentifierCacheKey) as? String {
            self.identifier = cachedIdentifier
        }
        if let cachedShelterId = decoder.value(forKey: PetShelterIdCacheKey) as? String {
            self.shelterId = cachedShelterId
        }
        if let cachedShelterAddress = decoder.value(forKey: PetShelterAddressCacheKey) as? String {
            self.shelterAddress = cachedShelterAddress
        }
        if let cachedShelterCity = decoder.value(forKey: PetShelterCityCacheKey) as? String {
            self.shelterCity = cachedShelterCity
        }
        if let cachedShelterState = decoder.value(forKey: PetShelterStateCacheKey) as? String {
            self.shelterState = cachedShelterState
        }
        if let cachedShelterZip = decoder.value(forKey: PetShelterZipCacheKey) as? String {
            self.shelterZip = cachedShelterZip
        }
        if let cachedShelterPhone = decoder.value(forKey: PetShelterPhoneCacheKey) as? String {
            self.shelterPhone = cachedShelterPhone
        }
        if let cachedShelterFormattedPhone = decoder.value(forKey: PetShelterFormattedPhoneCacheKey) as? String {
            self.shelterFormattedPhone = cachedShelterFormattedPhone
        }
        if let cachedShelterEmail = decoder.value(forKey: PetShelterEmailCacheKey) as? String {
            self.shelterEmail = cachedShelterEmail
        }
        if let cachedPhotoData = decoder.value(forKey: PetPhotoURLsCacheKey) as? Data, let cachedPhotoURLs = NSKeyedUnarchiver.unarchiveObject(with: cachedPhotoData) as? [String] {
            self.photoURLs = cachedPhotoURLs
        }
        if let cachedName = decoder.value(forKey: PetNameCacheKey) as? String {
            self.name = cachedName
        }
        if let cachedBreed = decoder.value(forKey: PetBreedCacheKey) as? String {
            self.breed = cachedBreed
        }
        if let cachedStory = decoder.value(forKey: PetStoryCacheKey) as? String {
            self.story = cachedStory
        }
        if let petTypeValue = decoder.value(forKey: PetTypeCacheKey) as? String, let cachedType = PetType(rawValue: petTypeValue) {
            self.petType = cachedType
        }
        if let ageValue = decoder.value(forKey: PetAgeCacheKey) as? String, let cachedAge = Age(rawValue: ageValue) {
            self.age = cachedAge
        }
        if let genderValue = decoder.value(forKey: PetGenderCacheKey) as? String, let cachedGender = Gender(rawValue: genderValue) {
            self.gender = cachedGender
        }
        if let sizeValue = decoder.value(forKey: PetSizeCacheKey) as? String, let cachedSize = Size(rawValue: sizeValue) {
            self.size = cachedSize
        }
        self.hasShots = decoder.decodeBool(forKey: PetHasShotsCacheKey)
        self.isHouseTrained = decoder.decodeBool(forKey: PetIsHouseTrainedCacheKey)
        self.isAltered = decoder.decodeBool(forKey: PetIsAlteredCacheKey)
    }
    
    func encode(with encoder: NSCoder) {
        encoder.setValue(self.identifier, forKey: PetIdentifierCacheKey)
        encoder.setValue(self.shelterId, forKey: PetShelterIdCacheKey)
        encoder.setValue(self.shelterAddress, forKey: PetShelterAddressCacheKey)
        encoder.setValue(self.shelterCity, forKey: PetShelterCityCacheKey)
        encoder.setValue(self.shelterState, forKey: PetShelterStateCacheKey)
        encoder.setValue(self.shelterZip, forKey: PetShelterZipCacheKey)
        encoder.setValue(self.shelterPhone, forKey: PetShelterPhoneCacheKey)
        encoder.setValue(self.shelterFormattedPhone, forKey: PetShelterFormattedPhoneCacheKey)
        encoder.setValue(self.shelterEmail, forKey: PetShelterEmailCacheKey)
        let photoData = NSKeyedArchiver.archivedData(withRootObject: self.photoURLs)
        encoder.setValue(photoData, forKey: PetPhotoURLsCacheKey)
        encoder.setValue(self.name, forKey: PetNameCacheKey)
        encoder.setValue(self.breed, forKey: PetBreedCacheKey)
        encoder.setValue(self.story, forKey: PetStoryCacheKey)
        encoder.setValue(self.petType.rawValue, forKey: PetTypeCacheKey)
        encoder.setValue(self.age.rawValue, forKey: PetAgeCacheKey)
        encoder.setValue(self.gender.rawValue, forKey: PetGenderCacheKey)
        encoder.setValue(self.size.rawValue, forKey: PetSizeCacheKey)
        encoder.setValue(self.hasShots, forKey: PetHasShotsCacheKey)
        encoder.setValue(self.isHouseTrained, forKey: PetIsHouseTrainedCacheKey)
        encoder.setValue(self.isAltered, forKey: PetIsAlteredCacheKey)

    }
    
    // MARK: Loading
    
    func load(props: JSON) {
        // basic info
        if let parsedIdentifier = props.stringFor(key: "id") {
            self.identifier = parsedIdentifier
        }
        if let parsedShelterId = props.stringFor(key: "shelterId") {
            self.shelterId = parsedShelterId
        }
        if let parsedName = props.stringFor(key: "name") {
            self.name = parsedName.strippingHTML()
        }
        if let parsedDescription = props.stringFor(key: "description") {
            self.story = parsedDescription.strippingHTML()
        }
        if let parsedType = props.stringFor(key: "animal"), let typeEnum = PetType(rawValue: parsedType.lowercased()) {
            self.petType = typeEnum
        }
        if let parsedAge = props.stringFor(key: "age"), let ageEnum = Age(rawValue: parsedAge.lowercased()) {
            self.age = ageEnum
        }
        if let parsedSize = props.stringFor(key: "size"), let sizeEnum = Size(rawValue: parsedSize.lowercased()) {
            self.size = sizeEnum
        }
        if let parsedGender = props.stringFor(key: "sex"), let genderEnum = Gender(rawValue: parsedGender.lowercased()) {
            self.gender = genderEnum
        }
        
        // photos
        if let mediaJSON = props.dictionary?["media"], let photosJSON = mediaJSON.dictionary?["photos"], let photosProps = photosJSON.dictionary?["photo"]?.array {
            for curPhotoProps in photosProps {
                if let photoURL = curPhotoProps.dictionary?[TIdentifier]?.string, photoURL.range(of: "&-x.") != nil {
                    self.photoURLs.append(photoURL)
                }
            }
        }
        
        // breed
        if let breedsJSON = props.dictionary?["breeds"], let breedProps = breedsJSON.dictionary?["breed"], let parsedBreed = breedProps.dictionary?[TIdentifier]?.string {
            self.breed = parsedBreed
        }
    
        // pet options
        if let optionsJSON = props.dictionary?["options"], let optionJSON = optionsJSON.dictionary?["option"]?.array {
            for curOption in optionJSON {
                if let option = curOption.dictionary?[TIdentifier]?.string {
                    if option == "hasShots" {
                        self.hasShots = true
                    }
                    else if option == "houseTrained" {
                        self.isHouseTrained = true
                    }
                    else if option == "altered" {
                        self.isAltered = true
                    }
                }
            }
        }
        
        // shelter info
        if let contactJSON = props.dictionary?["contact"] {
            var address1 = ""
            var address2 = ""
            if let parsedAddress1 = contactJSON.stringFor(key: "address1") {
                address1 = parsedAddress1
            }
            if let parsedAddress2 = contactJSON.stringFor(key: "address2") {
                address2 = parsedAddress2
            }
            if (address1.characters.count > 0 || address2.characters.count > 0) {
                self.shelterAddress = "\(address1) \(address2)"
            }
            
            if let parsedCity = contactJSON.stringFor(key: "city") {
                self.shelterCity = parsedCity
            }
            if let parsedState = contactJSON.stringFor(key: "state") {
                self.shelterState = parsedState
            }
            if let parsedZip = contactJSON.stringFor(key: "zip") {
                self.shelterZip = parsedZip
            }
            if let parsedEmail = contactJSON.stringFor(key: "email") {
                self.shelterEmail = parsedEmail
            }
            if let parsedPhone = contactJSON.stringFor(key: "phone") {
                self.shelterFormattedPhone = parsedPhone
                self.shelterPhone = parsedPhone.formattedPhone()
            }
        }
    }
    
    var formattedAddress: String {
        get {
            var result = ""
            
            if self.shelterAddress.characters.count > 0 {
                result += self.shelterAddress
            }
            if self.shelterCity.characters.count > 0 {
                if result.characters.count > 0 {
                    result += "\n"
                }
                result += self.shelterCity
            }
            if self.shelterState.characters.count > 0 {
                if self.shelterCity.characters.count > 0 {
                    result += ", \(self.shelterState)"
                } else {
                    if result.characters.count > 0 {
                        result += "\n"
                    }
                    result += self.shelterState
                }
            }
            if self.shelterZip.characters.count > 0 {
                if self.shelterCity.characters.count > 0 || self.shelterState.characters.count > 0 {
                    result += " \(self.shelterZip)"
                } else {
                    if result.characters.count > 0 {
                        result += "\n"
                    }
                    result += self.shelterZip
                }
            }
            
            return result
        }
    }
    
}
