//
//  BreedCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/2/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let BreedCellId = "BreedCellId"

class BreedCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var breedLabel: UILabel!
    
    // MARK: Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.breedLabel.text = nil
    }
    
    // MARK: Layout
    
    func layoutFor(breed: String) {
        self.breedLabel.text = breed
    }
    
}
