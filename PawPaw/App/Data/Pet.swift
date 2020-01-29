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
let PetShelterEmailCacheKey = "PetShelterEmailCacheKey"
let PetPhotoURLsCacheKey = "PetPhotoURLsCacheKey"
let PetfinderURLCacheKey = "PetfinderURLCacheKey"
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
let PetIsFavoritedCacheKey = "PetIsFavoritedCacheKey"

typealias PetDetailCompletionBlock = (_ pet: Pet?, _ error: Error?) -> ()

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
    var petfinderURL: String = ""
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
            var result = "Fixed"
            
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
            if self.petType != .unknown && self.identifier.count > 0 && self.shelterId.count > 0 && self.name.count > 0 && self.photoURLs.count > 0 {
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
        if let cachedIdentifier = decoder.decodeObject(forKey: PetIdentifierCacheKey) as? String {
            self.identifier = cachedIdentifier
        }
        if let cachedShelterId = decoder.decodeObject(forKey: PetShelterIdCacheKey) as? String {
            self.shelterId = cachedShelterId
        }
        if let cachedShelterAddress = decoder.decodeObject(forKey: PetShelterAddressCacheKey) as? String {
            self.shelterAddress = cachedShelterAddress
        }
        if let cachedShelterCity = decoder.decodeObject(forKey: PetShelterCityCacheKey) as? String {
            self.shelterCity = cachedShelterCity
        }
        if let cachedShelterState = decoder.decodeObject(forKey: PetShelterStateCacheKey) as? String {
            self.shelterState = cachedShelterState
        }
        if let cachedShelterZip = decoder.decodeObject(forKey: PetShelterZipCacheKey) as? String {
            self.shelterZip = cachedShelterZip
        }
        if let cachedShelterPhone = decoder.decodeObject(forKey: PetShelterPhoneCacheKey) as? String {
            self.shelterPhone = cachedShelterPhone
        }
        if let cachedShelterEmail = decoder.decodeObject(forKey: PetShelterEmailCacheKey) as? String {
            self.shelterEmail = cachedShelterEmail
        }
        if let cachedPhotoData = decoder.decodeObject(forKey: PetPhotoURLsCacheKey) as? Data, let cachedPhotoURLs = NSKeyedUnarchiver.unarchiveObject(with: cachedPhotoData) as? [String] {
            self.photoURLs = cachedPhotoURLs
        }
        if let cachedPetFinderURL = decoder.decodeObject(forKey: PetfinderURLCacheKey) as? String {
            self.petfinderURL = cachedPetFinderURL
        }
        if let cachedName = decoder.decodeObject(forKey: PetNameCacheKey) as? String {
            self.name = cachedName
        }
        if let cachedBreed = decoder.decodeObject(forKey: PetBreedCacheKey) as? String {
            self.breed = cachedBreed
        }
        if let cachedStory = decoder.decodeObject(forKey: PetStoryCacheKey) as? String {
            self.story = cachedStory
        }
        if let petTypeValue = decoder.decodeObject(forKey: PetTypeCacheKey) as? String, let cachedType = PetType(rawValue: petTypeValue) {
            self.petType = cachedType
        }
        if let ageValue = decoder.decodeObject(forKey: PetAgeCacheKey) as? String, let cachedAge = Age(rawValue: ageValue) {
            self.age = cachedAge
        }
        if let genderValue = decoder.decodeObject(forKey: PetGenderCacheKey) as? String, let cachedGender = Gender(rawValue: genderValue) {
            self.gender = cachedGender
        }
        if let sizeValue = decoder.decodeObject(forKey: PetSizeCacheKey) as? String, let cachedSize = Size(rawValue: sizeValue) {
            self.size = cachedSize
        }
        self.hasShots = decoder.decodeBool(forKey: PetHasShotsCacheKey)
        self.isHouseTrained = decoder.decodeBool(forKey: PetIsHouseTrainedCacheKey)
        self.isAltered = decoder.decodeBool(forKey: PetIsAlteredCacheKey)
        self.isFavorited = decoder.decodeBool(forKey: PetIsFavoritedCacheKey)
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.identifier, forKey: PetIdentifierCacheKey)
        encoder.encode(self.shelterId, forKey: PetShelterIdCacheKey)
        encoder.encode(self.shelterAddress, forKey: PetShelterAddressCacheKey)
        encoder.encode(self.shelterCity, forKey: PetShelterCityCacheKey)
        encoder.encode(self.shelterState, forKey: PetShelterStateCacheKey)
        encoder.encode(self.shelterZip, forKey: PetShelterZipCacheKey)
        encoder.encode(self.shelterPhone, forKey: PetShelterPhoneCacheKey)
        encoder.encode(self.shelterEmail, forKey: PetShelterEmailCacheKey)
        let photoData = NSKeyedArchiver.archivedData(withRootObject: self.photoURLs)
        encoder.encode(photoData, forKey: PetPhotoURLsCacheKey)
        encoder.encode(self.petfinderURL, forKey: PetfinderURLCacheKey)
        encoder.encode(self.name, forKey: PetNameCacheKey)
        encoder.encode(self.breed, forKey: PetBreedCacheKey)
        encoder.encode(self.story, forKey: PetStoryCacheKey)
        encoder.encode(self.petType.rawValue, forKey: PetTypeCacheKey)
        encoder.encode(self.age.rawValue, forKey: PetAgeCacheKey)
        encoder.encode(self.gender.rawValue, forKey: PetGenderCacheKey)
        encoder.encode(self.size.rawValue, forKey: PetSizeCacheKey)
        encoder.encode(self.hasShots, forKey: PetHasShotsCacheKey)
        encoder.encode(self.isHouseTrained, forKey: PetIsHouseTrainedCacheKey)
        encoder.encode(self.isAltered, forKey: PetIsAlteredCacheKey)
        encoder.encode(self.isFavorited, forKey: PetIsFavoritedCacheKey)
    }
    
    // MARK: Loading
    
    func load(props: JSON) {
        // basic info
        if let parsedIdentifier = props["id"].int {
            self.identifier = String(parsedIdentifier)
        }
        if let parsedShelterId = props["organization_id"].string {
            self.shelterId = parsedShelterId
        }
        if let parsedPetfinderURL = props["url"].string {
            self.petfinderURL = parsedPetfinderURL
        }
        if let parsedName = props["name"].string {
            self.name = parsedName.strippingHTML()
        }
        if let parsedDescription = props["description"].string {
            self.story = parsedDescription.strippingHTML()
        }
        if let parsedType = props["type"].string, let typeEnum = PetType(rawValue: parsedType.lowercased()) {
            self.petType = typeEnum
        }
        if let parsedAge = props["age"].string, let ageEnum = Age(rawValue: parsedAge.lowercased()) {
            self.age = ageEnum
        }
        if let parsedSize = props["size"].string, let sizeEnum = Size(rawValue: parsedSize.lowercased()) {
            self.size = sizeEnum
        }
        if let parsedGender = props["gender"].string, let genderEnum = Gender(rawValue: parsedGender.lowercased()) {
            self.gender = genderEnum
        }
        
        // photos
        if let photosProps = props["photos"].array {
            for curPhotoProps in photosProps {
                var photoURL: String?
                if let photo = curPhotoProps["full"].string {
                    photoURL = photo
                }
                else if let photo = curPhotoProps["large"].string {
                    photoURL = photo
                }
                else if let photo = curPhotoProps["medium"].string {
                    photoURL = photo
                }
                else if let photo = curPhotoProps["small"].string {
                    photoURL = photo
                }
                if let photoURL = photoURL {
                    self.photoURLs.append(photoURL)
                }
            }
        }
        
        // breed
        if let breedsJSON = props.dictionary?["breeds"], let breedProps = breedsJSON.dictionary {
            if let breedProp = breedProps["primary"]?.string {
                self.breed = breedProp
            }
            else if let breedProp = breedProps["secondary"]?.string {
                self.breed = breedProp
            }
        }
    
        // pet options
        if let optionsJSON = props.dictionary?["attributes"], let optionsProps = optionsJSON.dictionary {
            if let hasShotsProp = optionsProps["shots_current"]?.bool {
                hasShots = hasShotsProp
            }
            if let alteredProps = optionsProps["spayed_neutered"]?.bool {
                   isAltered = alteredProps
            }
            if let houseTrainedProps = optionsProps["house_trained"]?.bool {
                      isHouseTrained = houseTrainedProps
            }
        }
        
        // shelter info
        if let contactJSON = props.dictionary?["contact"], let contactProps = contactJSON.dictionaryObject {
            if let addressProps = contactProps["address"] as? [String : Any] {
                if let streetProps1 = addressProps["address1"] as? String {
                    shelterAddress = streetProps1
                    if let streetProps2 = addressProps["address2"] as? String {
                        shelterAddress += streetProps2
                    }
                }
                if let cityProps = addressProps["city"] as? String {
                    shelterCity = cityProps
                }
                if let stateProps = addressProps["state"] as? String {
                    shelterState = stateProps
                }
                if let zipProps = addressProps["postcode"] as? String {
                    shelterZip = zipProps
                }
            }
            if let emailProps = contactProps["email"] as? String {
                shelterEmail = emailProps
            }
            if let phoneProps = contactProps["phone"] as? String {
                shelterPhone = phoneProps.formattedPhone()
            }
        }
    }

    static func loadDetailsWithId(petId: String, completion: PetDetailCompletionBlock?) {
        PetFinderAPI.shared.requestPetDetailsFor(petId: petId) { (json, error) in
            var resultError: Error? = error
            var resultPet: Pet?
            if resultError == nil {
                if let json = json, let petJSON = json.dictionary?["animal"] {
                    resultPet = Pet()
                    resultPet!.load(props: petJSON)
                    if resultPet!.isValidPet == false {
                        resultPet = nil
                    }
                }
            } else {
                resultError = PawPawError.JSONParsingError
            }
            if let completion = completion {
                completion(resultPet, resultError)
            }
        }
    }
    
    var formattedAddress: String {
        get {
            var result = ""
            
            if self.shelterAddress.count > 0 {
                result += self.shelterAddress
            }
            if self.shelterCity.count > 0 {
                if result.count > 0 {
                    result += "\n"
                }
                result += self.shelterCity
            }
            if self.shelterState.count > 0 {
                if self.shelterCity.count > 0 {
                    result += ", \(self.shelterState)"
                } else {
                    if result.count > 0 {
                        result += "\n"
                    }
                    result += self.shelterState
                }
            }
            if self.shelterZip.count > 0 {
                if self.shelterCity.count > 0 || self.shelterState.count > 0 {
                    result += " \(self.shelterZip)"
                } else {
                    if result.count > 0 {
                        result += "\n"
                    }
                    result += self.shelterZip
                }
            }
            
            return result
        }
    }

    // MARK: - Formatting

    func formatPhone(source: String) -> String? {
        if let formattedPhoneNumber = String.formatPhoneNumber(source: source) {
            return formattedPhoneNumber
        }
        else {
            return nil
        }
    }
    
}
