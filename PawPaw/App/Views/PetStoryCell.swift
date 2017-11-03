//
//  PetStoryCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/3/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let PetStoryCellId = "PetStoryCellId"

class PetStoryCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var storyLabel: UILabel!
    
    // MARK: Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.storyLabel.text = nil
    }
    
    // MARK: Layout
    
    func layoutFor(story: String) {
        self.storyLabel.text = story
    }
    
}
