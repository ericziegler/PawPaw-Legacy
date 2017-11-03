//
//  NSRange+PawPaw.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/2/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

extension NSRange {
    
    func toRange(_ string: String) -> Range<String.Index> {
        let start = string.characters.index(string.startIndex, offsetBy: self.location)
        let end = string.index(start, offsetBy: self.length)
        
        return start..<end
    }
    
}
