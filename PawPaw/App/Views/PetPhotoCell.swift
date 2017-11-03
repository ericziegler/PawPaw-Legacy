//
//  PetPhotoCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/3/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let PetPhotoCellId = "PetPhotoCellId"
let PetPhotoCellHeight: CGFloat = 215

class PetPhotoCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
        self.nameLabel.text = nil
    }
    
    // MARK: Layout
    
    func layoutFor(pet: Pet) {
        self.nameLabel.text = pet.name
        if let photoURL = pet.photoURLs.first {
            self.photoImageView.loadImageUsingCache(withUrl: photoURL)
        }
    }
    
}
