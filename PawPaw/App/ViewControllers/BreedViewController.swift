//
//  BreedViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let BreedViewId = "BreedViewId"

class BreedViewController: BaseViewController {
    
    // MARK: Properties
    
    @IBOutlet var petTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var breedTable: UITableView!
    
    var showingDogs = true
    let sectionTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    // MARK: Init
    
    class func createController() -> BreedViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: BreedViewController = storyboard.instantiateViewController(withIdentifier: BreedViewId) as! BreedViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.breedTable.sectionIndexBackgroundColor = UIColor.clear
        self.breedTable.sectionIndexColor = UIColor.accentTab
    }
    
    // MARK: Actions
    
    @IBAction func segmentChanged(_ sender: AnyObject) {
        if self.petTypeSegmentedControl.selectedSegmentIndex == 0 {
            self.showingDogs = true
        } else {
            self.showingDogs = false
        }
        self.breedTable.reloadData()
    }
    
    // MARK: Convenience Methods
    
    func breedAtIndexPath(indexPath: IndexPath) -> String {
        var breed = ""
        let letter = self.sectionTitles[indexPath.section]
        if self.showingDogs {
            if let breeds = BreedList.shared.dogBreeds[letter] {
                breed = breeds[indexPath.row]
            }
        } else {
            if let breeds = BreedList.shared.catBreeds[letter] {
                breed = breeds[indexPath.row]
            }
        }
        return breed
    }
    
}

extension BreedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = self.sectionTitles[section]
        var breeds = [String]()
        if self.showingDogs {
            if let tempBreeds = BreedList.shared.dogBreeds[letter] {
                breeds = tempBreeds
            }
        } else {
            if let tempBreeds = BreedList.shared.catBreeds[letter] {
                breeds = tempBreeds
            }
        }
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BreedCellId, for: indexPath) as! BreedCell
        let breed = self.breedAtIndexPath(indexPath: indexPath)
        cell.layoutFor(breed: breed)
        return cell
    }
    
}

extension BreedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petVC = PetListViewController.createControllerFor(listType: .breed)
        let breed = self.breedAtIndexPath(indexPath: indexPath)
        petVC.titleString = breed
        petVC.breed = breed
        petVC.showBackButton = true
        if self.showingDogs {
            petVC.type = .dog
        } else {
            petVC.type = .cat
        }
        self.navigationController?.pushViewController(petVC, animated: true)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitles
    }
    
}
