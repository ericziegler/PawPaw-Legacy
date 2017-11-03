//
//  ShelterInfoCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/2/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let ShelterInfoCellId = "ShelterInfoCellId"
let ShelterInfoCellHeight: CGFloat = 68

class ShelterInfoCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var infoLabel: TopAlignedLabel!
    @IBOutlet var iconImageView: UIImageView!
    
    // MARK: Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.headingLabel.text = nil
        self.infoLabel.text = nil
        self.iconImageView.image = nil
    }
    
    // MARK: Layout
    
    func layoutFor(heading: String, value: String) {
        self.headingLabel.text = heading
        self.infoLabel.text = value
        
        self.iconImageView.image = nil
        if value.characters.count > 0 {
            var image: UIImage?
            
            if heading.lowercased() == "address:" {
                image = UIImage(named: "Address")
            }
            else if heading.lowercased() == "email:" {
                image = UIImage(named: "Email")
            }
            else if heading.lowercased() == "phone:" {
                image = UIImage(named: "Phone")
            }
            self.iconImageView.image = image
        }
    }
    
}
