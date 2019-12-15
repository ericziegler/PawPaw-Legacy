//
//  Shelter.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation
import CoreLocation

class Shelter {

    // MARK: Properties
    
    var identifier: String = ""
    var name: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    var email: String = ""
    var phone: String = ""
    var formattedPhone: String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var pets: [Pet] = [Pet]()
    
    var isValidShelter: Bool {
        get {
            if self.identifier.count > 0 && self.name.count > 0 && self.coordinate.latitude != 0.0 && self.coordinate.longitude != 0.0 {
                return true
            }
            return false
        }
    }
    
    var formattedAddress: String {
        get {
            var result = ""
            
            if self.address.count > 0 {
                result += self.address
            }
            if self.city.count > 0 {
                if result.count > 0 {
                    result += "\n"
                }
                result += self.city
            }
            if self.state.count > 0 {
                if self.city.count > 0 {
                    result += ", \(self.state)"
                } else {
                    if result.count > 0 {
                        result += "\n"
                    }
                    result += self.state
                }
            }
            if self.zip.count > 0 {
                if self.city.count > 0 || self.state.count > 0 {
                    result += " \(self.zip)"
                } else {
                    if result.count > 0 {
                        result += "\n"
                    }
                    result += self.zip
                }
            }
            
            return result
        }
    }
    
    // MARK: Loading
    
    func load(props: JSON) {
        if let parsedIdentifier = props.stringFor(key: "id") {
            self.identifier = parsedIdentifier
        }
        if let parsedName = props.stringFor(key: "name") {
            self.name = parsedName.strippingHTML()
        }
        
        var address1 = ""
        var address2 = ""
        if let parsedAddress1 = props.stringFor(key: "address1") {
            address1 = parsedAddress1
        }
        if let parsedAddress2 = props.stringFor(key: "address2") {
            address2 = parsedAddress2
        }
        if (address1.count > 0 || address2.count > 0) {
            self.address = "\(address1) \(address2)"
        }
        
        if let parsedCity = props.stringFor(key: "city") {
            self.city = parsedCity
        }
        if let parsedState = props.stringFor(key: "state") {
            self.state = parsedState
        }
        if let parsedZip = props.stringFor(key: "zip") {
            self.zip = parsedZip
        }
        if let parsedEmail = props.stringFor(key: "email") {
            self.email = parsedEmail
        }
        if let parsedPhone = props.stringFor(key: "phone") {
            self.formattedPhone = parsedPhone
            self.phone = parsedPhone.formattedPhone()
        }        
        if let parsedLatitudeString = props.stringFor(key: "latitude"), let parsedLatitude = Double(parsedLatitudeString),
            let parsedLongitudeString = props.stringFor(key: "longitude"), let parsedLongitude = Double(parsedLongitudeString) {
            self.coordinate = CLLocationCoordinate2DMake(parsedLatitude, parsedLongitude)
        }
    }
    
    func loadPetsWith(offset: Int, completion: PetCompletionBlock?) {
        PetFinderAPI.shared.requestPetsFor(shelterId: self.identifier, offset: 0) { [weak self] (json, error) in
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
                strongSelf.pets += resultPets
                if let completion = completion {
                    completion(strongSelf.pets, resultError)
                }
            }
        }
    }
    
}
