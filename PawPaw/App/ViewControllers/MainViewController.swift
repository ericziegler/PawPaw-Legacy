//
//  MainViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Enums

enum MainViewTab: Int {
    case home
    case find
    case breed
    case shelter
    case favorite
}

class MainViewController: UIViewController {

    // MARK: Properties

    @IBOutlet var homeButton: UIButton!
    @IBOutlet var findButton: UIButton!
    @IBOutlet var breedButton: UIButton!
    @IBOutlet var shelterButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var homeLabel: UILabel!
    @IBOutlet var findLabel: UILabel!
    @IBOutlet var breedLabel: UILabel!
    @IBOutlet var shelterLabel: UILabel!
    @IBOutlet var favoriteLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    var curTab = MainViewTab.home
    
    var homeNavController: UINavigationController!
    var findNavController: UINavigationController!
    var breedNavController: UINavigationController!
    var shelterNavController: UINavigationController!
    var favoriteNavController: UINavigationController!
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createViewControllers()
        self.place(viewController: self.homeNavController)
        self.updateButtonAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ZipManager.shared.zip == nil {
            let locationVC = LocationViewController.createController()
            locationVC.canShowCloseButton = false
            self.present(locationVC, animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func createViewControllers() {
        let home = PetListViewController.createControllerFor(listType: .random)
        self.homeNavController = UINavigationController(rootViewController: home)
        self.homeNavController.isNavigationBarHidden = true
        home.showBackButton = false
        home.showLocationButton = true
        home.titleString = "Paw Paw"
        
        let find = FilterViewController.createController()
        self.findNavController = UINavigationController(rootViewController: find)
        self.findNavController.isNavigationBarHidden = true
        
        let breed = BreedViewController.createController()
        self.breedNavController = UINavigationController(rootViewController: breed)
        self.breedNavController.isNavigationBarHidden = true
        
        let shelter = ShelterListViewController.createController()
        self.shelterNavController = UINavigationController(rootViewController: shelter)
        self.shelterNavController.isNavigationBarHidden = true
        
        let favorite = PetListViewController.createControllerFor(listType: .favorite)
        self.favoriteNavController = UINavigationController(rootViewController: favorite)
        self.favoriteNavController.isNavigationBarHidden = true
        favorite.showBackButton = false
        favorite.showLocationButton = false
        favorite.titleString = "My Favorites"
    }
    
    // MARK: Actions
    
    @IBAction func homeTapped(_ sender: AnyObject) {
        self.curTab = .home
        self.place(viewController: self.homeNavController)
        self.updateButtonAppearance()
    }
    
    @IBAction func findTapped(_ sender: AnyObject) {
        self.curTab = .find
        self.place(viewController: self.findNavController)
        self.updateButtonAppearance()
    }
    
    @IBAction func breedTapped(_ sender: AnyObject) {
        self.curTab = .breed
        self.place(viewController: self.breedNavController)
        self.updateButtonAppearance()
    }
    
    @IBAction func shelterTapped(_ sender: AnyObject) {
        self.curTab = .shelter
        self.place(viewController: self.shelterNavController)
        self.updateButtonAppearance()
    }
    
    @IBAction func favoriteTapped(_ sender: AnyObject) {
        self.curTab = .favorite
        self.place(viewController: self.favoriteNavController)
        self.updateButtonAppearance()
    }
    
    // MARK: View Controller Management
    
    private func place(viewController: UIViewController) {
        for curView in self.containerView.subviews {
            curView.removeFromSuperview()
        }
        self.addChildViewController(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: ["childView" : viewController.view]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: ["childView" : viewController.view]))
    }
    
    private func updateButtonAppearance() {
        switch self.curTab {
        case .home:
            self.homeButton.setImage(UIImage(named: "HomeAccent"), for: .normal)
            self.findButton.setImage(UIImage(named: "FindNeutral"), for: .normal)
            self.breedButton.setImage(UIImage(named: "BreedNeutral"), for: .normal)
            self.shelterButton.setImage(UIImage(named: "ShelterNeutral"), for: .normal)
            self.favoriteButton.setImage(UIImage(named: "FavoriteNeutral"), for: .normal)
            
            self.homeLabel.textColor = UIColor.accentTab
            self.findLabel.textColor = UIColor.neutralTab
            self.breedLabel.textColor = UIColor.neutralTab
            self.shelterLabel.textColor = UIColor.neutralTab
            self.favoriteLabel.textColor = UIColor.neutralTab
        case .find:
            self.homeButton.setImage(UIImage(named: "HomeNeutral"), for: .normal)
            self.findButton.setImage(UIImage(named: "FindAccent"), for: .normal)
            self.breedButton.setImage(UIImage(named: "BreedNeutral"), for: .normal)
            self.shelterButton.setImage(UIImage(named: "ShelterNeutral"), for: .normal)
            self.favoriteButton.setImage(UIImage(named: "FavoriteNeutral"), for: .normal)
            
            self.homeLabel.textColor = UIColor.neutralTab
            self.findLabel.textColor = UIColor.accentTab
            self.breedLabel.textColor = UIColor.neutralTab
            self.shelterLabel.textColor = UIColor.neutralTab
            self.favoriteLabel.textColor = UIColor.neutralTab
        case .breed:
            self.homeButton.setImage(UIImage(named: "HomeNeutral"), for: .normal)
            self.findButton.setImage(UIImage(named: "FindNeutral"), for: .normal)
            self.breedButton.setImage(UIImage(named: "BreedAccent"), for: .normal)
            self.shelterButton.setImage(UIImage(named: "ShelterNeutral"), for: .normal)
            self.favoriteButton.setImage(UIImage(named: "FavoriteNeutral"), for: .normal)
            
            self.homeLabel.textColor = UIColor.neutralTab
            self.findLabel.textColor = UIColor.neutralTab
            self.breedLabel.textColor = UIColor.accentTab
            self.shelterLabel.textColor = UIColor.neutralTab
            self.favoriteLabel.textColor = UIColor.neutralTab
        case .shelter:
            self.homeButton.setImage(UIImage(named: "HomeNeutral"), for: .normal)
            self.findButton.setImage(UIImage(named: "FindNeutral"), for: .normal)
            self.breedButton.setImage(UIImage(named: "BreedNeutral"), for: .normal)
            self.shelterButton.setImage(UIImage(named: "ShelterAccent"), for: .normal)
            self.favoriteButton.setImage(UIImage(named: "FavoriteNeutral"), for: .normal)
            
            self.homeLabel.textColor = UIColor.neutralTab
            self.findLabel.textColor = UIColor.neutralTab
            self.breedLabel.textColor = UIColor.neutralTab
            self.shelterLabel.textColor = UIColor.accentTab
            self.favoriteLabel.textColor = UIColor.neutralTab
        case .favorite:
            self.homeButton.setImage(UIImage(named: "HomeNeutral"), for: .normal)
            self.findButton.setImage(UIImage(named: "FindNeutral"), for: .normal)
            self.breedButton.setImage(UIImage(named: "BreedNeutral"), for: .normal)
            self.shelterButton.setImage(UIImage(named: "ShelterNeutral"), for: .normal)
            self.favoriteButton.setImage(UIImage(named: "FavoriteAccent"), for: .normal)
            
            self.homeLabel.textColor = UIColor.neutralTab
            self.findLabel.textColor = UIColor.neutralTab
            self.breedLabel.textColor = UIColor.neutralTab
            self.shelterLabel.textColor = UIColor.neutralTab
            self.favoriteLabel.textColor = UIColor.accentTab
        }
    }
    
}
