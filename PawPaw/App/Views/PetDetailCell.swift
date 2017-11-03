//
//  PetDetailCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/3/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let PetDetailCellId = "PetDetailCellId"
let PetDetailCellHeight: CGFloat = 44.0

class PetDetailCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var infoTypeLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    // MARK: Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.infoTypeLabel.text = nil
        self.valueLabel.text = nil
    }
    
    // MARK: Layout
    
    func layoutFor(infoType: String, value: String) {
        self.infoTypeLabel.text = infoType
        self.valueLabel.text = value
    }
    
}
