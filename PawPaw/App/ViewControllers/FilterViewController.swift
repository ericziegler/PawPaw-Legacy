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

class FilterViewController: BaseViewController {
    
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
        self.updateButton(self.femaleButton, isSelected: false)
        self.maleButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.maleButton, isSelected: false)
        self.extraSmallButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.extraSmallButton, isSelected: false)
        self.smallButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.smallButton, isSelected: false)
        self.mediumButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.mediumButton, isSelected: false)
        self.largeButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.largeButton, isSelected: false)
        self.extraLargeButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.extraLargeButton, isSelected: false)
        self.babyButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.babyButton, isSelected: false)
        self.youngButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.youngButton, isSelected: false)
        self.adultButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.adultButton, isSelected: false)
        self.seniorButton.layer.cornerRadius = ButtonCornerRadius
        self.updateButton(self.seniorButton, isSelected: false)
        self.findButton.layer.cornerRadius = ButtonCornerRadius
    }
    
    private func updateButton(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth = 0
            button.backgroundColor = UIColor.main
            button.setTitleColor(UIColor.white, for: .normal)
        } else {
            button.layer.borderColor = UIColor.main.cgColor
            button.layer.borderWidth = 1
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.main, for: .normal)
        }
    }
    
    private func hasValidFilters() -> Bool {
        var genderSelected = false
        var sizeSelected = false
        var ageSelected = false
        
        if self.femaleButton.layer.borderWidth == 0 ||
            self.maleButton.layer.borderWidth == 0 {
            genderSelected = true
        }
        if self.extraSmallButton.layer.borderWidth == 0 ||
            self.smallButton.layer.borderWidth == 0 ||
            self.mediumButton.layer.borderWidth == 0 ||
            self.largeButton.layer.borderWidth == 0 ||
            self.extraLargeButton.layer.borderWidth == 0 {
            sizeSelected = true
        }
        if self.babyButton.layer.borderWidth == 0 ||
            self.youngButton.layer.borderWidth == 0 ||
            self.adultButton.layer.borderWidth == 0 ||
            self.seniorButton.layer.borderWidth == 0 {
            ageSelected = true
        }
        
        if genderSelected && sizeSelected && ageSelected {
            return true
        }
        return false
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
        if let button = sender as? UIButton, let bgColor = button.backgroundColor {
            if bgColor == UIColor.main {
                self.updateButton(button, isSelected: false)
            } else {
                self.updateButton(button, isSelected: true)
            }
        }
    }
    
    @IBAction func findTapped(_ sender: AnyObject) {
        if self.hasValidFilters() {
            // pet type
            if self.petTypeSegmentedControl.selectedSegmentIndex == 0 {
                self.petType = .dog
            } else {
                self.petType = .cat
            }
            
            // gender
            self.genders.removeAll()
            if self.femaleButton.layer.borderWidth == 0 {
                self.genders.append(.female)
            }
            if self.maleButton.layer.borderWidth == 0 {
                self.genders.append(.male)
            }
            
            // size
            self.sizes.removeAll()
            if self.extraSmallButton.layer.borderWidth == 0 {
                self.sizes.append(.extraSmall)
            }
            if self.smallButton.layer.borderWidth == 0 {
                self.sizes.append(.small)
            }
            if self.mediumButton.layer.borderWidth == 0 {
                self.sizes.append(.medium)
            }
            if self.largeButton.layer.borderWidth == 0 {
                self.sizes.append(.large)
            }
            if self.extraLargeButton.layer.borderWidth == 0 {
                self.sizes.append(.extraLarge)
            }
            
            // age
            self.ages.removeAll()
            if self.babyButton.layer.borderWidth == 0 {
                self.ages.append(.baby)
            }
            if self.youngButton.layer.borderWidth == 0 {
                self.ages.append(.young)
            }
            if self.adultButton.layer.borderWidth == 0 {
                self.ages.append(.adult)
            }
            if self.seniorButton.layer.borderWidth == 0 {
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
        } else {
            let alert = UIAlertController(title: "Invalid Filters", message: "You must select at least one GENDER, one SIZE, and one AGE.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
