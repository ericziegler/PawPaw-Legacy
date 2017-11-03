//
//  SwiftyJSON+PawPaw.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/30/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

extension JSON {

    func stringFor(key: String) -> String? {
        var result: String?
        
        if let parsedResult = self.dictionary?[key]?.dictionary?[TIdentifier]?.string {
            result = parsedResult
        }
        
        return result
    }
    
}
