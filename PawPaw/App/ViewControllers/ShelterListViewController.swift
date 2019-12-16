//
//  ShelterListViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let ShelterListViewId = "ShelterListViewId"

class ShelterListViewController: BaseViewController {
    
    // MARK: Properties
    
    @IBOutlet var shelterTable: UITableView!
    
    var loadingView: LoadingView?
    var shelterList = ShelterList()
    
    // MARK: Init
    
    class func createController() -> ShelterListViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ShelterListViewController = storyboard.instantiateViewController(withIdentifier: ShelterListViewId) as! ShelterListViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: LocationUpdateSuccessNotification, object: nil, queue: nil, using: locationUpdateDidSucceed(_:))
        self.loadShelters()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Loading
    
    func loadShelters() {
        if let zip = ZipManager.shared.zip {
            self.shelterList = ShelterList()
            self.loadingView?.dismissWith(animation: false)
            self.loadingView = LoadingView.displayIn(parentView: self.view, animated: true)
            self.shelterList.loadSheltersFor(zip: zip, completion: { (shelters, error) in
                DispatchQueue.main.async {
                    if error == nil && shelters.count > 0 {
                        self.loadingView?.dismissWith(animation: true)
                        self.shelterTable.reloadData()
                    } else {
                        let alert = UIAlertController(title: "Sorry About That!", message: "An error occurred while trying to load shelters.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    // MARK: Notifications
    
    func locationUpdateDidSucceed(_ notification: Notification) {
        self.loadShelters()
    }
    
}

extension ShelterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shelterList.shelters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShelterCellId, for: indexPath) as! ShelterCell
        let shelter = self.shelterList.shelters[indexPath.row]
        cell.layoutFor(shelter: shelter)
        return cell
    }
}

extension ShelterListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shelterVC = ShelterDetailViewController.createController()
        let shelter = self.shelterList.shelters[indexPath.row]
        shelterVC.shelter = shelter
        self.navigationController?.pushViewController(shelterVC, animated: true)
    }
    
}
