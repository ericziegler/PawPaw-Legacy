//
//  PetListViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let PetListViewId = "PetListViewId"

// MARK: Enums

enum PetListType: Int {
    case random
    case find
    case breed
    case shelter
    case favorite
}

class PetListViewController: BaseViewController {

    // MARK: Properties
    
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var listView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noDataLabel: UILabel!
    
    var loadingView: LoadingView?
    var listType = PetListType.random
    var petList = PetList()
    var ages = [Age]()
    var genders = [Gender]()
    var sizes = [Size]()
    var type = PetType.dog
    var breed = ""
    var shelter = Shelter()
    var showBackButton = false
    var showLocationButton = false
    var titleString: String = "Paw Paw"
    
    // MARK: Init
    
    class func createControllerFor(listType: PetListType) -> PetListViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: PetListViewController = storyboard.instantiateViewController(withIdentifier: PetListViewId) as! PetListViewController
        viewController.listType = listType
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.loadPets()
        NotificationCenter.default.addObserver(forName: LocationUpdateSuccessNotification, object: nil, queue: nil, using: locationUpdateDidSucceed)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.listType == .favorite {
            self.petList = PetList()
            self.petList.loadFavorites()
            self.listView.reloadData()
        }
    }
    
    private func setupNavBar() {
        self.backButton.isHidden = !self.showBackButton
        self.locationButton.isHidden = !self.showLocationButton
        self.titleLabel.text = self.titleString
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update flow layout
        let layout = self.listView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let squareSize = CGFloat((self.listView.bounds.size.width / 2.0) - 2)
        layout.itemSize = CGSize(width: squareSize, height: squareSize)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
    }
    
    // MARK: Actions
    
    @IBAction func backTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func locationTapped(_ sender: AnyObject) {
        let locationVC = LocationViewController.createController()
        locationVC.canShowCloseButton = true
        locationVC.modalPresentationStyle = .fullScreen
        self.present(locationVC, animated: true, completion: nil)
    }
    
    // MARK: Loading
    
    private func loadPets() {
        if let zip = ZipManager.shared.zip {
            self.loadingView?.dismissWith(animation: false)
            self.loadingView = LoadingView.displayIn(parentView: self.view, animated: true)
            if self.listType == .random {
                self.petList.loadRandomPetsNear(zip: zip, completion: { (pets, error) in
                    self.handlePetRequestWith(error: error)
                })
            }
            else if self.listType == .find {
                self.petList.loadPetsFor(type: self.type, sizes: self.sizes, genders: self.genders, ages: self.ages, zip: zip, offset: 0, completion: { (pets, error) in
                    self.handlePetRequestWith(error: error)
                })
            }
            else if self.listType == .breed {
                self.petList.loadPetsFor(type: self.type, breed: self.breed, zip: zip, offset: 0, completion: { (pets, error) in
                    self.handlePetRequestWith(error: error)
                })
            }
            else if self.listType == .shelter {
                self.shelter.loadPetsWith(offset: 0, completion: { (pets, error) in
                    if let pets = pets {
                        self.petList.pets = pets
                    }
                    self.handlePetRequestWith(error: error)
                })
            }
            else if self.listType == .favorite {
                self.petList.loadFavorites()
                self.loadingView?.dismissWith(animation: true)
                if self.petList.pets.count == 0 {
                    self.noDataLabel.isHidden = false
                } else {
                    self.noDataLabel.isHidden = true
                }
                self.listView.reloadData()
            }
        }
    }
    
    // MARK: Convenience Functions
    
    private func handlePetRequestWith(error: Error?) {
        DispatchQueue.main.async {
            self.loadingView?.dismissWith(animation: true)
            if let _ = error {
                self.displayErrorAlert()
            } else {
                if self.petList.pets.count == 0 {
                    self.noDataLabel.isHidden = false
                } else {
                    self.noDataLabel.isHidden = true
                }
                self.listView.reloadData()
            }
        }
    }
    
    private func displayErrorAlert() {
        let alert = UIAlertController(title: "Sorry About That!", message: "An error occurred while trying to load pets.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func petAtIndex(index: Int) -> Pet? {
        var result: Pet?
        if index < self.petList.pets.count {
            result = self.petList.pets[index]
        }
        return result
    }
    
    // MARK: Notifications
    
    func locationUpdateDidSucceed(notification: Notification) -> Void {
        self.loadPets()
    }
    
}

extension PetListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.petList.pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetCellId, for: indexPath) as! PetCell
        if let pet = self.petAtIndex(index: indexPath.row) {
            cell.layoutFor(pet: pet)
        }
        return cell
    }
}

extension PetListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.petList.pets.count {
            if let pet = self.petAtIndex(index: indexPath.row) {
                let petDetailController = PetDetailViewController.createControllerFor(pet: pet)
                self.navigationController?.pushViewController(petDetailController, animated: true)
            }
        }
    }
    
}

