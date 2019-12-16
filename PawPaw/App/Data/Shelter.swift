//
//  Shelter.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - Constants

typealias ShelterLoadCompletionBlock = (_ error: Error?) -> ()

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
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var isLoading = false
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
    
    func load(props: JSON, completion: @escaping ShelterLoadCompletionBlock) {
        isLoading = true
        if let propsDict = props.dictionaryObject {
            // identifier
            if let idProps = propsDict["id"] as? String {
                identifier = idProps
            }
            // name
            if let nameProp = propsDict["name"] as? String {
                name = nameProp
            }
            // address
            if let addressProps = propsDict["address"] as? [String : Any] {
                // street address
                if let streetProps1 = addressProps["address1"] as? String {
                    address = streetProps1
                    if let streetProps2 = addressProps["address2"] as? String {
                        address += streetProps2
                    }
                }
                // city
                if let cityProps = addressProps["city"] as? String {
                    city = cityProps
                }
                // state
                if let stateProps = addressProps["state"] as? String {
                    state = stateProps
                }
                // zip
                if let zipProps = addressProps["postcode"] as? String {
                    zip = zipProps
                }
            }
            // email
            if let emailProps = propsDict["email"] as? String {
                email = emailProps
            }
            // phone
            if let phoneProps = propsDict["phone"] as? String {
                phone = phoneProps.formattedPhone()
            }
            // location
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(formattedAddress.replacingOccurrences(of: "\n", with: ", ")) { (placemarks, error) in
                guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    self.isLoading = false
                    completion(PawPawError.GeocodingError)
                    return
                }
                self.coordinate = location.coordinate
                self.isLoading = false
                completion(nil)
            }
        } else {
            isLoading = false
        }
    }
    
    func loadPetsWith(offset: Int, completion: PetCompletionBlock?) {
        PetFinderAPI.shared.requestPetsFor(shelterId: self.identifier) { [weak self] (json, error) in
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
