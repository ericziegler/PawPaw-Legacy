//
//  String+PawPaw.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/2/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

extension String {

    func formattedPhone() -> String {
        var result = self.lowercased()
        
        result = result.replacingOccurrences(of: "a", with: "2")
        result = result.replacingOccurrences(of: "b", with: "2")
        result = result.replacingOccurrences(of: "c", with: "2")
        
        result = result.replacingOccurrences(of: "d", with: "3")
        result = result.replacingOccurrences(of: "e", with: "3")
        result = result.replacingOccurrences(of: "f", with: "3")
        
        result = result.replacingOccurrences(of: "g", with: "4")
        result = result.replacingOccurrences(of: "h", with: "4")
        result = result.replacingOccurrences(of: "i", with: "4")
        
        result = result.replacingOccurrences(of: "j", with: "5")
        result = result.replacingOccurrences(of: "k", with: "5")
        result = result.replacingOccurrences(of: "l", with: "5")
        
        result = result.replacingOccurrences(of: "m", with: "6")
        result = result.replacingOccurrences(of: "n", with: "6")
        result = result.replacingOccurrences(of: "o", with: "6")
        
        result = result.replacingOccurrences(of: "p", with: "7")
        result = result.replacingOccurrences(of: "q", with: "7")
        result = result.replacingOccurrences(of: "r", with: "7")
        result = result.replacingOccurrences(of: "s", with: "7")
        
        result = result.replacingOccurrences(of: "t", with: "8")
        result = result.replacingOccurrences(of: "u", with: "8")
        result = result.replacingOccurrences(of: "v", with: "8")
        
        result = result.replacingOccurrences(of: "w", with: "9")
        result = result.replacingOccurrences(of: "x", with: "9")
        result = result.replacingOccurrences(of: "z", with: "9")
        result = result.replacingOccurrences(of: "z", with: "9")
        
        let range = NSMakeRange(0, result.count)
        result = result.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: range.toRange(result))
        
        return result
    }
    
    func strippingHTML() -> String {
        var result = self.replacingOccurrences(of: "<br />", with: "\n")
        
        result = result.replacingOccurrences(of: "<br/>", with: "\n")
        result = result.replacingOccurrences(of: "<br></br>", with: "\n")
        result = result.replacingOccurrences(of: "<br>", with: "\n")
        result = result.replacingOccurrences(of: "<p />", with: "\n\n")
        result = result.replacingOccurrences(of: "<b/>", with: "\n\n")
        result = result.replacingOccurrences(of: "<p>", with: "\n\n")
        result = result.replacingOccurrences(of: "&#39;", with: "'")
        result = result.replacingOccurrences(of: "&#34;", with: "\"")
        
        result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        return result
    }
    
}
