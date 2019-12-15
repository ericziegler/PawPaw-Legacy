//
//  ShelterDetailViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

// MARK: Constants

let ShelterDetailViewId = "ShelterDetailViewId"

class ShelterDetailViewController: BaseViewController {
    
    // MARK: Properties
    
    @IBOutlet var detailTable: UITableView!
    
    var shelter: Shelter!
    
    // MARK: Init
    
    class func createController() -> ShelterDetailViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ShelterDetailViewController = storyboard.instantiateViewController(withIdentifier: ShelterDetailViewId) as! ShelterDetailViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func backTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Convenience Methods
    
    func performGetDirections() {
        let alert = UIAlertController(title: "Would you like directions?", message: "This will show you directions to \(self.shelter.name) in the Maps app.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.shelter.coordinate, addressDictionary:nil))
            mapItem.name = self.shelter.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
        alert.addAction(UIAlertAction(title: "No Thanks", style: .cancel, handler: nil))
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func performCall() {
        if self.shelter.phone.count > 0 {
            if let url = URL(string: "tel://\(self.shelter.phone)"), UIApplication.shared.canOpenURL(url) {
                let alert = UIAlertController(title: "Would you like to call \(self.shelter.formattedPhone)?", message: "This will call \(self.shelter.name)", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                alert.addAction(UIAlertAction(title: "No Thanks", style: .cancel, handler: nil))
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Cannot Make Phone Call", message: "Either this device cannot make phone calls, or the phone number is invalid.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func performEmail() {
        if MFMailComposeViewController.canSendMail(), self.shelter.email.count > 0 {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([self.shelter.email])
            mailVC.setSubject("Interest in Pets at your Shelter")
            self.present(mailVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Cannot Send Mail", message: "This device is not able to send emails.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension ShelterDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelterMapCellId, for: indexPath) as! ShelterMapCell
            cell.layoutFor(shelter: self.shelter)
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelterPetsCellId, for: indexPath) as! ShelterPetsCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelterInfoCellId, for: indexPath) as! ShelterInfoCell
            if indexPath.row == 1 {
                cell.layoutFor(heading: "Address:", value: shelter.formattedAddress)
            }
            else if indexPath.row == 2 {
                cell.layoutFor(heading: "Phone:", value: shelter.formattedPhone)
            } else {
                cell.layoutFor(heading: "Email:", value: shelter.email)
            }
            return cell
        }
    }
    
}

extension ShelterDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return ShelterMapCellHeight
        }
        else if indexPath.row == 4 {
            return ShelterPetsCellHeight
        } else {
            return ShelterInfoCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.performGetDirections()
        }
        else if indexPath.row == 2 {
            self.performCall()
        }
        else if indexPath.row == 3 {
            self.performEmail()
        }
    }
    
}

extension ShelterDetailViewController: ShelterPetsCellDelegate {

    func petsButtonTappedFor(shelterPetsCell: ShelterPetsCell) {
        let petsVC = PetListViewController.createControllerFor(listType: .shelter)
        petsVC.showBackButton = true
        petsVC.titleString = "Shelter Pets"
        petsVC.shelter = self.shelter
        self.navigationController?.pushViewController(petsVC, animated: true)
    }
    
}

extension ShelterDetailViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
