//
//  PhotoViewController.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/3/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let PhotoViewId = "PhotoViewId"

class PhotoViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    var titleString = ""
    var photos = [String]()
    
    // MARK: Init
    
    class func createControllerFor(photos: [String], title: String) -> PhotoViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: PhotoViewController = storyboard.instantiateViewController(withIdentifier: PhotoViewId) as! PhotoViewController
        viewController.photos = photos
        viewController.titleString = title
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.titleString
        
        if self.photos.count == 1 {
            self.countLabel.text = "(1 Photo)"
        } else {
            self.countLabel.text = "(\(self.photos.count) Photos)"
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update flow layout
        let layout = self.photoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: self.photoCollectionView.bounds.size.width, height: self.photoCollectionView.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
    // MARK: Actions
    
    @IBAction func closeTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellId, for: indexPath) as! PhotoCell
        cell.layoutFor(photoURL: self.photos[indexPath.row])
        return cell
    }
    
}
