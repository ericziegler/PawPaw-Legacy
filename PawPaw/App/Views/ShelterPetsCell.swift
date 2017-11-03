//
//  ShelterPetsCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/2/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let ShelterPetsCellId = "ShelterPetsCellId"
let ShelterPetsCellHeight: CGFloat = 80.0

// MARK: Protocol

protocol ShelterPetsCellDelegate {
    func petsButtonTappedFor(shelterPetsCell: ShelterPetsCell)
}

class ShelterPetsCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet var petsButton: UIButton!
    
    var delegate: ShelterPetsCellDelegate?
    
    // MARK: Layout
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.petsButton.layer.cornerRadius = ButtonCornerRadius
    }
    
    // MARK: Actions
    
    @IBAction func petsTapped(_ sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.petsButtonTappedFor(shelterPetsCell: self)
        }
    }
    
}
