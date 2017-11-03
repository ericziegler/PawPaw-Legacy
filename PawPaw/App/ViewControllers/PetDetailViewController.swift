//
//  PetDetailViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let PetDetailViewId = "PetDetailViewId"

class PetDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var pet: Pet!
    
    // MARK: Init
    
    class func createControllerFor(pet: Pet) -> PetDetailViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: PetDetailViewController = storyboard.instantiateViewController(withIdentifier: PetDetailViewId) as! PetDetailViewController
        viewController.pet = pet
        return viewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Actions
    
    @IBAction func backTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
