//
//  LocationViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let LocationViewId = "LocationViewId"

class LocationViewController: BaseViewController {

    // MARK: Properties
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var zipTextField: UITextField!
    @IBOutlet var curLocationButton: UIButton!
    @IBOutlet var zipButton: UIButton!
    
    var loadingView: LoadingView?
    var canShowCloseButton = true
    
    // MARK: Init
    
    class func createController() -> LocationViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: LocationViewController = storyboard.instantiateViewController(withIdentifier: LocationViewId) as! LocationViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.canShowCloseButton {
            self.closeButton.isHidden = false
            self.titleLabel.text = "Your Location"
            self.descriptionLabel.text = "Enter your zip code or let us find your location."
        } else {
            self.closeButton.isHidden = true
            self.titleLabel.text = "Let's Get Started"
            self.descriptionLabel.text = "Enter your zip code or let us find your location. We'll find furry friends near you!"
        }
        
        if let zip = ZipManager.shared.zip {
            self.zipTextField.text = zip
        }
        
        self.curLocationButton.layer.cornerRadius = ButtonCornerRadius
        self.zipButton.layer.cornerRadius = ButtonCornerRadius
        
        NotificationCenter.default.addObserver(forName: LocationUpdateSuccessNotification, object: nil, queue: nil, using: locationUpdateDidSucceed(_:))
        NotificationCenter.default.addObserver(forName: LocationUpdateFailNotification, object: nil, queue: nil, using: locationUpdateDidFail(_:))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Actions
    
    @IBAction func closeTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func zipTapped(_ sender: AnyObject) {
        if let zip = self.zipTextField.text, LocationManager.isValidZip(zip) {
            LocationManager.shared.isUsingCurrentLocation = false
            ZipManager.shared.zip = zip
        } else {
            let alert = UIAlertController(title: "Invalid Zip Code", message: "The Zip Code you entered is invalid. Please enter a valid zip code.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func curLocationTapped(_ sender: AnyObject) {
        self.loadingView?.dismissWith(animation: false)
        self.loadingView = LoadingView.displayIn(parentView: self.view, animated: true)
        LocationManager.shared.updateLocation()
    }
    
    // MARK: Notifications
    
    @objc func locationUpdateDidSucceed(_ notification: Notification) {
        self.loadingView?.dismissWith(animation: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func locationUpdateDidFail(_ notification: Notification) {
        self.loadingView?.dismissWith(animation: true)
        let alert = UIAlertController(title: "Location Not Found", message: "We had an issue finding your current location. This could either be because Location Services are turned off. Please check Location Services for Paw Paw in iOS Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
