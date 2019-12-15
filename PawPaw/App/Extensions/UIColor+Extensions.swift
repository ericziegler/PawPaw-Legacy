//
//  UIColor+Extensions.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var main: UIColor {
        get {
            return UIColor(hex: 0xe65973)
        }
    }
    
    class var neutralTab: UIColor {
        get {
            return UIColor(hex: 0x777777)
        }
    }
    
    class var accentTab: UIColor {
        get {
            return UIColor.main
        }
    }
    
}
