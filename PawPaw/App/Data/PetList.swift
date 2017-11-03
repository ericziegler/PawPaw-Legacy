//
//  PetList.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

// MARK: Constants

typealias PetCompletionBlock = (_ pets: [Pet]?, _ error: Error?) -> ()
let PetLoadThreshold: Int = 50
let FavoritePetsCacheKey = "FavoritePetsCacheKey"

class PetList {

    // MARK: Properties
    
    var pets = [Pet]()
    private var lastLoadedCount = 0
    
    // MARK: Loading
    
    func loadRandomPetsNear(zip: String, completion: PetCompletionBlock?) {
        self.pets.removeAll()
        self.loadPetsFor(type: .cat, sizes: Size.allSizes, genders: Gender.allGenders, ages: Age.allAges, zip: zip, offset: 0) { [weak self] (cats, error) in
            if let strongSelf = self {
                strongSelf.loadPetsFor(type: .dog, sizes: Size.allSizes, genders: Gender.allGenders, ages: Age.allAges, zip: zip, offset: 0) { (dogs, error) in
                    strongSelf.pets.shuffle()
                    if let completion = completion {
                        completion(strongSelf.pets, error)
                    }
                }
            }
        }
    }
    
    func loadPetsFor(type: PetType, sizes: [Size], genders: [Gender], ages: [Age], zip: String, offset: Int, completion: PetCompletionBlock?) {
        self.lastLoadedCount = offset
        PetFinderAPI.shared.requestPetsFor(type: type, zip: zip, offset: offset) { [weak self] (json, error) in
            var resultPets: [Pet]?
            var resultError: Error? = error
            if let strongSelf = self {
                if resultError == nil {
                    if let json = json, let petfinderJSON = json.dictionary?["petfinder"], let petsJSON = petfinderJSON.dictionary?["pets"], let petsProps = petsJSON.dictionary?["pet"]?.array {
                        resultPets = [Pet]()
                        for curPetProps in petsProps {
                            let pet = Pet()
                            pet.load(props: curPetProps)
                            if pet.isValidPet && strongSelf.canAdd(pet: pet, forSizes: sizes, genders: genders, ages: ages) {
                                resultPets?.append(pet)
                            }
                        }
                    } else {
                        resultError = PawPawError.JSONParsingError
                    }
                }
                if let resultPets = resultPets {
                    strongSelf.pets.append(contentsOf: resultPets)
                    
                    if strongSelf.pets.count >= PetLoadThreshold || strongSelf.pets.count == strongSelf.lastLoadedCount {
                        if let completion = completion {
                            completion(strongSelf.pets, resultError)
                        }
                    } else {
                        strongSelf.loadPetsFor(type: type, sizes: sizes, genders: genders, ages: ages, zip: zip, offset: strongSelf.pets.count, completion: completion)
                    }
                }
            }
        }
    }
    
    func loadPetsFor(type: PetType, breed: String, zip: String, offset: Int, completion: PetCompletionBlock?) {
        PetFinderAPI.shared.requestPetsFor(type: type, breed: breed, zip: zip, offset: offset) { [weak self] (json, error) in
            var resultPets: [Pet]?
            var resultError: Error? = error
            if resultError == nil {
                if let json = json, let petfinderJSON = json.dictionary?["petfinder"], let petsJSON = petfinderJSON.dictionary?["pets"], let petsProps = petsJSON.dictionary?["pet"]?.array {
                    resultPets = [Pet]()
                    for curPetProps in petsProps {
                        let pet = Pet()
                        pet.load(props: curPetProps)
                        if pet.isValidPet {
                            resultPets?.append(pet)
                        }
                    }
                } else {
                    resultError = PawPawError.JSONParsingError
                }
            }
            if let strongSelf = self, let resultPets = resultPets {
                strongSelf.pets.append(contentsOf: resultPets)
            }
            if let completion = completion {
                completion(resultPets, resultError)
            }
        }
    }
    
    // MARK: Favorites
    
    func addFavorite(pet: Pet) {
        self.pets.append(pet)
        self.saveFavorites()
    }
    
    func removeFavorite(pet: Pet) {
        var index: Int?
        
        for i in 0..<self.pets.count {
            let curPet = self.pets[i]
            if curPet.identifier == pet.identifier {
                index = i
                break
            }
        }
        
        if let index = index {
            self.pets.remove(at: index)
            self.saveFavorites()
        }
    }
    
    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: FavoritePetsCacheKey), let cachedPets = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Pet] {
            self.pets = cachedPets
        }
    }
    
    func saveFavorites() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.pets)
        UserDefaults.standard.set(data, forKey: FavoritePetsCacheKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Filtering
    
    func canAdd(pet: Pet, forSizes sizes: [Size], genders: [Gender], ages: [Age]) -> Bool {
        var result = false
        if sizes.contains(pet.size) && genders.contains(pet.gender) && ages.contains(pet.age) {
            result = true
        }
        return result
    }
    
}