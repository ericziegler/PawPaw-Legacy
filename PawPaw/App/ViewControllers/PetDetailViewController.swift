//
//  PetDetailViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

// MARK: Constants

let PetDetailViewId = "PetDetailViewId"

class PetDetailViewController: BaseViewController {
    
    // MARK: Properties
    
    @IBOutlet var petTable: UITableView!
    
    var pet: Pet!
    
    // MARK: Init
    
    class func createControllerFor(pet: Pet) -> PetDetailViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: PetDetailViewController = storyboard.instantiateViewController(withIdentifier: PetDetailViewId) as! PetDetailViewController
        viewController.pet = pet
        return viewController
    }
    
    // MARK: Actions
    
    @IBAction func backTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Convenience Methods
    
    func performCall() {
        if self.pet.shelterPhone.count > 0 {
            if let url = URL(string: "tel://\(self.pet.shelterPhone)"), UIApplication.shared.canOpenURL(url) {
                let alert = UIAlertController(title: "Would you like to call about \(self.pet.shelterFormattedPhone)?", message: "This will call about \(self.pet.name)", preferredStyle: .alert)
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
        if MFMailComposeViewController.canSendMail(), self.pet.shelterEmail.count > 0 {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([self.pet.shelterEmail])
            mailVC.setSubject("Interest in a Pet: \(self.pet.name)")
            self.present(mailVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Cannot Send Mail", message: "This device is not able to send emails.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension PetDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 2
        }
        else if section == 2 {
            return 8
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PetPhotoCellId, for: indexPath) as! PetPhotoCell
            cell.layoutFor(pet: self.pet)
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: PetContactHeaderCellId, for: indexPath) as! PetContactHeaderCell
                cell.headerLabel.text = "My Story"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PetStoryCellId, for: indexPath) as! PetStoryCell
                cell.layoutFor(story: self.pet.story)
                return cell
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: PetContactHeaderCellId, for: indexPath) as! PetContactHeaderCell
                cell.headerLabel.text = "More About Me"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PetDetailCellId, for: indexPath) as! PetDetailCell
                var value = "Unknown"
                if indexPath.row == 1 {
                    if self.pet.breed.count > 0 {
                        value = self.pet.breed
                    }
                    cell.layoutFor(infoType: "Breed", value: value)
                }
                else if indexPath.row == 2 {
                    cell.layoutFor(infoType: "Gender", value: self.pet.gender.formattedValue)
                }
                else if indexPath.row == 3 {
                    cell.layoutFor(infoType: "Size", value: self.pet.size.formattedValue)
                }
                else if indexPath.row == 4 {
                    if self.pet.petType == .dog {
                        cell.layoutFor(infoType: "Age", value: self.pet.age.formattedValueForDog)
                    } else {
                        cell.layoutFor(infoType: "Age", value: self.pet.age.formattedValueForCat)
                    }
                }
                else if indexPath.row == 5 {
                    if self.pet.hasShots {
                        value = "Yes"
                    }
                    cell.layoutFor(infoType: "Has Shots", value: value)
                }
                else if indexPath.row == 6 {
                    cell.layoutFor(infoType: pet.alteredDisplayText, value: value)
                } else {
                    if self.pet.isHouseTrained {
                        value = "Yes"
                    }
                    cell.layoutFor(infoType: "House Trained", value: value)
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelterInfoCellId, for: indexPath) as! ShelterInfoCell
            var contactInfo = "N/A"
            if indexPath.row == 0 {
                if self.pet.shelterFormattedPhone.count > 0 {
                    contactInfo = self.pet.shelterFormattedPhone
                }
                cell.layoutFor(heading: "Call about me", value: contactInfo)
            } else {
                if self.pet.shelterEmail.count > 0 {
                    contactInfo = self.pet.shelterEmail
                }
                cell.layoutFor(heading: "Email about me", value: contactInfo)
            }
            return cell
        }
    }
    
}

extension PetDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return PetPhotoCellHeight
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return PetContactHeaderCellHeight
            } else {
                return UITableView.automaticDimension
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return PetContactHeaderCellHeight
            } else {
                return PetDetailCellHeight
            }
        } else {
            return ShelterInfoCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                self.performCall()
            } else {
                self.performEmail()
            }
        }
    }
    
}

extension PetDetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PetDetailViewController: PetPhotoCellDelegate {

    func favoriteTappedFor(cell: PetPhotoCell, isFavorited: Bool) {
        self.pet.isFavorited = isFavorited
        let petList = PetList()
        petList.loadFavorites()
        
        if isFavorited {
            petList.addFavorite(pet: pet)
        } else {
            petList.removeFavorite(pet: pet)
        }
    }
    
    func photosTappedFor(cell: PetPhotoCell) {
        let photoVC = PhotoViewController.createControllerFor(photos: self.pet.photoURLs, title: self.pet.name)
        photoVC.modalPresentationStyle = .fullScreen
        self.present(photoVC, animated: true, completion: nil)
    }
    
}
