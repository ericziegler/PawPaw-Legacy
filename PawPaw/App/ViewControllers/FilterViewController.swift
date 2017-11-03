//
//  FilterViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let FilterViewId = "FilterViewId"
let FilterDisabledOpacity: Float = 0.45

class FilterViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var petTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var extraSmallButton: UIButton!
    @IBOutlet var smallButton: UIButton!
    @IBOutlet var mediumButton: UIButton!
    @IBOutlet var largeButton: UIButton!
    @IBOutlet var extraLargeButton: UIButton!
    @IBOutlet var babyButton: UIButton!
    @IBOutlet var youngButton: UIButton!
    @IBOutlet var adultButton: UIButton!
    @IBOutlet var seniorButton: UIButton!
    @IBOutlet var findButton: UIButton!
    
    var petType = PetType.dog
    var genders: [Gender] = Gender.allGenders
    var ages: [Age] = Age.allAges
    var sizes: [Size] = Size.allSizes
    
    // MARK: Init
    
    class func createController() -> FilterViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: FilterViewController = storyboard.instantiateViewController(withIdentifier: FilterViewId) as! FilterViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtons()
        self.updateForPetType()
    }
    
    private func setupButtons() {
        self.femaleButton.layer.cornerRadius = ButtonCornerRadius
        self.maleButton.layer.cornerRadius = ButtonCornerRadius
        self.extraSmallButton.layer.cornerRadius = ButtonCornerRadius
        self.smallButton.layer.cornerRadius = ButtonCornerRadius
        self.mediumButton.layer.cornerRadius = ButtonCornerRadius
        self.largeButton.layer.cornerRadius = ButtonCornerRadius
        self.extraLargeButton.layer.cornerRadius = ButtonCornerRadius
        self.babyButton.layer.cornerRadius = ButtonCornerRadius
        self.youngButton.layer.cornerRadius = ButtonCornerRadius
        self.adultButton.layer.cornerRadius = ButtonCornerRadius
        self.seniorButton.layer.cornerRadius = ButtonCornerRadius
        self.findButton.layer.cornerRadius = ButtonCornerRadius
    }
    
    private func updateForPetType() {
        if self.petTypeSegmentedControl.selectedSegmentIndex == 0 {
            self.babyButton.setTitle("Puppy", for: .normal)
            self.findButton.setTitle("Find Dogs!", for: .normal)
        } else {
            self.babyButton.setTitle("Kitten", for: .normal)
            self.findButton.setTitle("Find Cats!", for: .normal)
        }
    }
    
    // MARK: Actions
    
    @IBAction func petTypeValueChanged(_ sender: AnyObject) {
        self.updateForPetType()
    }
    
    @IBAction func filterTapped(_ sender: AnyObject) {
        if let button = sender as? UIButton {
            if button.layer.opacity == 1 {
                button.layer.opacity = FilterDisabledOpacity
            } else {
                button.layer.opacity = 1
            }
        }
    }
    
    @IBAction func findTapped(_ sender: AnyObject) {
        // pet type
        if self.petTypeSegmentedControl.selectedSegmentIndex == 0 {
            self.petType = .dog
        } else {
            self.petType = .cat
        }
        
        // gender
        self.genders.removeAll()
        if self.femaleButton.layer.opacity == 1 {
            self.genders.append(.female)
        }
        if self.maleButton.layer.opacity == 1 {
            self.genders.append(.male)
        }
        
        // size
        self.sizes.removeAll()
        if self.extraSmallButton.layer.opacity == 1 {
            self.sizes.append(.extraSmall)
        }
        if self.smallButton.layer.opacity == 1 {
            self.sizes.append(.small)
        }
        if self.mediumButton.layer.opacity == 1 {
            self.sizes.append(.medium)
        }
        if self.largeButton.layer.opacity == 1 {
            self.sizes.append(.large)
        }
        if self.extraLargeButton.layer.opacity == 1 {
            self.sizes.append(.extraLarge)
        }
        
        // age
        self.ages.removeAll()
        if self.babyButton.layer.opacity == 1 {
            self.ages.append(.baby)
        }
        if self.youngButton.layer.opacity == 1 {
            self.ages.append(.young)
        }
        if self.adultButton.layer.opacity == 1 {
            self.ages.append(.adult)
        }
        if self.seniorButton.layer.opacity == 1 {
            self.ages.append(.senior)
        }
        
        let listViewController = PetListViewController.createControllerFor(listType: .find)
        listViewController.type = self.petType
        listViewController.genders = self.genders
        listViewController.sizes = self.sizes
        listViewController.ages = self.ages
        listViewController.titleString = "Pet Results"
        listViewController.showBackButton = true
        self.navigationController?.pushViewController(listViewController, animated: true)
    }
    
}
