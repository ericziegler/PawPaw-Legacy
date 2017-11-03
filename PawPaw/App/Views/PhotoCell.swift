//
//  PhotoCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/3/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let PhotoCellId = "PhotoCellId"

class PhotoCell: UICollectionViewCell {
    
    // MARK: Properties
    
    @IBOutlet var photoImageView: GTZoomableImageView!
    
    // MARK: Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    // MARK: Layout
    
    func layoutFor(photoURL: String) {
        self.photoImageView.imageView.loadImageUsingCache(withUrl: photoURL)
    }
    
}
