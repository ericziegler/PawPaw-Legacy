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

// MARK: Protocol

protocol PetPhotoCellDelegate {
    func favoriteTappedFor(cell: PetPhotoCell, isFavorited: Bool)
    func photosTappedFor(cell: PetPhotoCell)
}

class PetPhotoCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameBackground: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var scrimView: UIView!
    
    var delegate: PetPhotoCellDelegate?
    private var pet: Pet?
    
    // MARK: Init

    override func awakeFromNib() {
        super.awakeFromNib()
        let photoButton = UIButton(frame: scrimView.frame)
        photoButton.addTarget(self, action: #selector(photosTapped(_:)), for: .touchUpInside)
        scrimView.insertSubview(photoButton, belowSubview: nameBackground)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
        self.nameLabel.text = nil
    }
    
    // MARK: Actions
    
    @IBAction func favoriteTapped(_ sender: AnyObject) {
        if let pet = self.pet {
            pet.isFavorited = !pet.isFavorited
            self.updateFavoriteButtonFor(pet: pet)
            if let delegate = self.delegate {
                delegate.favoriteTappedFor(cell: self, isFavorited: pet.isFavorited)
            }
        }
    }
    
    @IBAction func photosTapped(_ sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.photosTappedFor(cell: self)
        }
    }
    
    // MARK: Layout
    
    func layoutFor(pet: Pet) {
        self.pet = pet
        self.updateFavoriteButtonFor(pet: pet)
        self.nameLabel.text = pet.name
        if let photoURL = pet.photoURLs.first {
            self.photoImageView.loadImageUsingCache(withUrl: photoURL)
        }
    }
    
    func updateFavoriteButtonFor(pet: Pet) {
        if pet.isFavorited {
            self.favoriteButton.setImage(UIImage(named: "FavoriteFilled"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(named: "FavoriteOutline"), for: .normal)
        }
    }
    
}
