//
//  ShelterMapCell.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/2/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit
import MapKit

// MARK: Constants

let ShelterMapCellId = "ShelterMapCellId"
let ShelterMapCellHeight: CGFloat = 160.0

class ShelterMapCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var shelterLabel: UILabel!
    
    // MARK: Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.shelterLabel.text = nil
    }
    
    // MARK: Layout
    
    func layoutFor(shelter: Shelter) {
        self.shelterLabel.text = shelter.name
        self.map.centerCoordinate = shelter.coordinate
        let viewRegion = MKCoordinateRegion(center: shelter.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        let adjustedRegion = self.map.regionThatFits(viewRegion)
        self.map.region = adjustedRegion
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = shelter.coordinate
        annotation.title = ""
        self.map.addAnnotation(annotation)
    }
    
}
