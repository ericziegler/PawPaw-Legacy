//
//  PetCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/2/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let PetCellId = "PetCellId"

class PetCell: UICollectionViewCell {

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
        if let photoURL = pet.photoURLs.first {
            DispatchQueue.main.async {
                self.photoImageView.loadImageUsingCache(withUrl: photoURL)
            }
        }
        self.nameLabel.text = pet.name
    }
    
}
