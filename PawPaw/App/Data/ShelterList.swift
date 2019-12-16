//
//  ShelterList.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

// MARK: Constants

typealias ShelterCompletionBlock = (_ shelters: [Shelter], _ error: Error?) -> ()

class ShelterList {

    // MARK: Properties
    
    var shelters = [Shelter]()
    
    func loadSheltersFor(zip: String, completion: ShelterCompletionBlock?) {
        PetFinderAPI.shared.requestSheltersNear(zip: zip) { [unowned self] (json, error) in
            var resultError: Error? = error
            var sheltersLoadedCount = 0
            var sheltersCount = 0
            if resultError == nil {
                if let json = json, let sheltersJSON = json.dictionary?["organizations"], let sheltersProps = sheltersJSON.array {
                    self.shelters.removeAll()
                    sheltersCount = sheltersProps.count
                    for curShelterProps in sheltersProps {
                        let shelter = Shelter()
                        shelter.load(props: curShelterProps) { (error) in
                            if error != nil || shelter.isValidShelter == false {
                                print("Error loading shelter.")
                            } else {
                                self.shelters.append(shelter)
                            }
                            sheltersLoadedCount += 1
                        }
                    }
                } else {
                    resultError = PawPawError.JSONParsingError
                }
            }
            while sheltersLoadedCount != sheltersCount {
                print("Shelter progress: \(sheltersLoadedCount) / \(sheltersCount)")
            }
            if let completion = completion {
                completion(self.shelters, resultError)
            }
        }
    }
    
}
