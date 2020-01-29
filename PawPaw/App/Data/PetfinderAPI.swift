//
//  PetfinderAPI.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

// MARK: Constants

let PetFinderURL = "https://api.petfinder.com/v2"

#if DEBUG
let APIKey = "Edyur498OSOPQofijM57vmmXCqqpLfpQrTUQgEU4cnFzx4DfYL"
let APISecret = "BkJn34mUFHXq0ulFyxuE5hi8tT31HtO1C7DsUDIH"
#else
let APIKey = "Faa66DyjJP5T6geA3YhE9HV7kluozrYG2KZbEoY00qR8Bkrb5w"
let APISecret = "25E5gnzUXFgnoMdvqIQcOL6dRuYDcaxjkqGdbLPW"
#endif

let AccessTokenCacheKey = "AccessTokenCacheKey"
let AccessTokenTimestampCacheKey = "AccessTokenTimestampCacheKey"
let AccessTokenTimeLimit: TimeInterval = 3480

let PetFinderDescriptionSeparator = "<div class=\"u-vr4x\">"

typealias RequestCompletionBlock = (_ response: JSON?, _ error: Error?) -> ()

class PetFinderAPI {

    // MARK: Properties

    var accessToken: String?
    var tokenTimestamp: Date?
    var requestingToken = false
    
    // MARK: Init
    
    static let shared = PetFinderAPI()

    init() {
        loadAccessToken()
    }

    // MARK: Access Token Requests

    func requestAccessToken() {
        guard let url = URL(string: "\(PetFinderURL)/oauth2/token"),
        let payload = "grant_type=client_credentials&client_id=\(APIKey)&client_secret=\(APISecret)".data(using: .utf8) else
        {
            return
        }
        requestingToken = true
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = payload
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            let result = self.buildJSONResponse(data: data, error: error)
            self.accessToken = result.0?.dictionary?["access_token"]?.rawString()
            self.tokenTimestamp = Date()
            self.requestingToken = false
            self.saveAccessToken()
            print("Access token acquired: \(self.accessToken)")
        }
        task.resume()
    }

    private func validateAccessToken() {
        if let timestamp = tokenTimestamp {
            if Date().timeIntervalSince(timestamp) > AccessTokenTimeLimit {
                clearAccessToken()
                requestAccessToken()
            }
        } else {
            clearAccessToken()
        }
    }

    private func clearAccessToken() {
        accessToken = nil
        tokenTimestamp = nil
        saveAccessToken()
    }

    private func saveAccessToken() {
        UserDefaults.standard.set(accessToken, forKey: AccessTokenCacheKey)
        UserDefaults.standard.set(tokenTimestamp, forKey: AccessTokenTimestampCacheKey)
        UserDefaults.standard.synchronize()
    }

    private func loadAccessToken() {
        if let token = UserDefaults.standard.object(forKey: AccessTokenCacheKey) as? String {
            accessToken = token
        }
        if let timestamp = UserDefaults.standard.object(forKey: AccessTokenTimestampCacheKey) as? Date {
            tokenTimestamp = timestamp
        }
        if accessToken == nil {
            requestAccessToken()
        }
    }
    
    // MARK: Shelter Requests
    
    func requestSheltersNear(zip: String, completion: @escaping RequestCompletionBlock) {
        validateAccessToken()
        guard let request = self.buildRequestFor(fileName: "organizations", params: ["location" : zip, "distance" : "100", "sort" : "distance", "limit" : "100"]) else {
            completion(nil, PawPawError.InvalidRequestError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            let result = self.buildJSONResponse(data: data, error: error)
            completion(result.0, result.1)
        }
        task.resume()
    }
    
    // MARK: Pet Requests
    
    func requestPetsFor(shelterId: String, completion: @escaping RequestCompletionBlock) {
        validateAccessToken()
        guard let request = self.buildRequestFor(fileName: "animals", params: ["organization" : shelterId, "page" : "1", "limit" : "100"]) else {
            completion(nil, PawPawError.InvalidRequestError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            let result = self.buildJSONResponse(data: data, error: error)
            completion(result.0, result.1)
        }
        task.resume()
    }
    
    func requestPetsFor(type: PetType, zip: String, completion: @escaping RequestCompletionBlock) {
        validateAccessToken()
        guard let request = self.buildRequestFor(fileName: "animals", params: ["type" : type.rawValue, "location" : zip, "page" : "1", "limit" : "32"]) else {
            completion(nil, PawPawError.InvalidRequestError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            let result = self.buildJSONResponse(data: data, error: error)
            completion(result.0, result.1)
        }
        task.resume()
    }
    
    func requestPetsFor(type: PetType, breed: String, zip: String, completion: @escaping RequestCompletionBlock) {
        validateAccessToken()
        guard let request = self.buildRequestFor(fileName: "animals", params: ["type" : type.rawValue, "breed" : breed, "location" : zip, "page" : "1", "limit" : "100"]) else {
            completion(nil, PawPawError.InvalidRequestError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            let result = self.buildJSONResponse(data: data, error: error)
            completion(result.0, result.1)
        }
        task.resume()
    }

    func requestPetDetailsFor(petId: String, completion: @escaping RequestCompletionBlock) {
        validateAccessToken()
        guard let request = self.buildRequestFor(fileName: "animals/\(petId)", params: [:]) else {
            completion(nil, PawPawError.InvalidRequestError)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            let result = self.buildJSONResponse(data: data, error: error)
            completion(result.0, result.1)
        }
        task.resume()
    }

    func requestBreedsFor(type: PetType, completion: @escaping RequestCompletionBlock) {
        validateAccessToken()
        guard let request = self.buildRequestFor(fileName: "types/\(type.rawValue)/breeds", params: [:]) else {
            completion(nil, PawPawError.InvalidRequestError)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            let result = self.buildJSONResponse(data: data, error: error)
            completion(result.0, result.1)
        }
        task.resume()
    }
    
    // MARK: Convenience Functions
    
    private func buildRequestFor(fileName: String, params: [String : String]) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(PetFinderURL)/\(fileName)") else {
            return nil
        }

        var queryItems = [URLQueryItem]()
        for (curKey, curValue) in params {
            queryItems.append(URLQueryItem(name: curKey, value: curValue))
        }
        urlComponents.queryItems = queryItems

        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            while accessToken == nil {
                print("Waiting for Access Token.")
            }
            request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")

            return request
        }

        return nil
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
