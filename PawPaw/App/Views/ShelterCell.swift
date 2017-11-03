//
//  ShelterCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/2/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let ShelterCellId = "ShelterCellId"

class ShelterCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    
    // MARK: Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.contactLabel.text = nil
    }
    
    // MARK: Layout
    
    func layoutFor(shelter: Shelter) {
        self.nameLabel.text = shelter.name
        
        if shelter.address.characters.count > 0 {
            self.contactLabel.text = shelter.address
        }
        else if shelter.formattedPhone.characters.count > 0 {
            self.contactLabel.text = shelter.formattedPhone
        }
        else if shelter.email.characters.count > 0 {
            self.contactLabel.text = shelter.email
        }
        else if shelter.city.characters.count > 0 && shelter.state.characters.count > 0 {
            self.contactLabel.text = "\(shelter.city), \(shelter.state)"
        } else {
            self.contactLabel.text = "--"
        }
    }
    
}
