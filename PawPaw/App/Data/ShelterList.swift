//
//  ShelterList.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

// MARK: Constants

typealias ShelterCompletionBlock = (_ shelters: [Shelter]?, _ error: Error?) -> ()

class ShelterList {

    // MARK: Properties
    
    var shelters = [Shelter]()
    
    func loadSheltersFor(zip: String, completion: ShelterCompletionBlock?) {
        PetFinderAPI.shared.requestSheltersNear(zip: zip) { [weak self] (json, error) in
            var resultShelters: [Shelter]?
            var resultError: Error? = error
            if resultError == nil {
                if let json = json, let petfinderJSON = json.dictionary?["petfinder"], let sheltersJSON = petfinderJSON.dictionary?["shelters"], let sheltersProps = sheltersJSON.dictionary?["shelter"]?.array {
                    resultShelters = [Shelter]()
                    for curShelterProps in sheltersProps {
                        let shelter = Shelter()
                        shelter.load(props: curShelterProps)
                        if shelter.isValidShelter {
                            resultShelters?.append(shelter)
                        }
                    }
                } else {
                    resultError = PawPawError.JSONParsingError
                }
            }
            if let strongSelf = self, let resultShelters = resultShelters {
                strongSelf.shelters = resultShelters
            }
            if let completion = completion {
                completion(resultShelters, resultError)
            }
        }
    }
    
}
