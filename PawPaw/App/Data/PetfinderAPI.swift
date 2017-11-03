//
//  PetfinderAPI.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

// MARK: Constants

let PetFinderURL = "https://api.petfinder.com"

#if DEBUG
let APIKey = "46e28d7c8ef3048f289b447a0500510a"
let APISecret = "ce338a1ef64c96b5ec64be18d578a136"
#else
let APIKey = "4d22879ff758059f1de3e57668425ce5"
let APISecret = "d13bfbd0070c6b197ccb3564693ac79c"
#endif

typealias RequestCompletionBlock = (_ response: JSON?, _ error: Error?) -> ()
let TIdentifier = "$t"

class PetFinderAPI {

    // MARK: Properties
    
    // MARK: Init
    
    static let shared = PetFinderAPI()
    
    // MARK: Shelter Requests
    
    func requestSheltersNear(zip: String, completion: RequestCompletionBlock?) {
        let request = self.buildRequestFor(fileName: "shelter.find", params: ["location" : zip])
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            if let completion = completion {
                let result = self.buildJSONResponse(data: data, error: error)
                completion(result.0, result.1)
            }
        }
        task.resume()
    }
    
    // MARK: Pet Requests
    
    func requestPetsFor(shelterId: String, offset: Int, completion: RequestCompletionBlock?) {
        let request = self.buildRequestFor(fileName: "shelter.getPets", params: ["id" : shelterId, "offset" : String(offset)])
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            if let completion = completion {
                let result = self.buildJSONResponse(data: data, error: error)
                completion(result.0, result.1)
            }
        }
        task.resume()
    }
    
    func requestPetsFor(type: PetType, zip: String, offset: Int, completion: RequestCompletionBlock?) {
        let request = self.buildRequestFor(fileName: "pet.find", params: ["animal" : type.rawValue, "location" : zip, "offset" : String(offset), "output" : "full"])
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            if let completion = completion {
                let result = self.buildJSONResponse(data: data, error: error)
                completion(result.0, result.1)
            }
        }
        task.resume()
    }
    
    func requestPetsFor(type: PetType, breed: String, zip: String, offset: Int, completion: RequestCompletionBlock?) {
        let request = self.buildRequestFor(fileName: "pet.find", params: ["animal" : type.rawValue, "breed" : breed, "location" : zip, "offset" : String(offset), "output" : "full"])
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            if let completion = completion {
                let result = self.buildJSONResponse(data: data, error: error)
                completion(result.0, result.1)
            }
        }
        task.resume()
    }
    
    // MARK: Convenience Functions
    
    private func buildRequestFor(fileName: String, params: [String : String]) -> URLRequest {
        var urlString = "\(PetFinderURL)/\(fileName)?format=json&key=\(APIKey)"
        for curKey in Array(params.keys) {
            if let curValue = params[curKey] {
                urlString += "&\(curKey)=\(curValue)"
            }
        }
        return URLRequest(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
    }
    
    private func buildJSONResponse(data: Data?, error: Error?) -> (JSON?, Error?) {
        var result: (JSON?, Error?)?
        if let error = error {
            result = (nil, error)
        } else {
            if let data = data {
                guard let json = try? JSON(data: data) else {
                    return (nil, PawPawError.JSONParsingError)
                }
                result = (json, nil)
            } else {
                result = (nil, PawPawError.JSONParsingError)
            }
        }
        if let result = result {
            return result
        } else {
            return (nil, PawPawError.JSONParsingError)
        }
    }
    
}
