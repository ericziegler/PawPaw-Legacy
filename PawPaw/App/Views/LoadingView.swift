//
//  LoadingView.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

let LoadingViewAnimationDuration: TimeInterval = 0.3

class LoadingView: UIView {

    // MARK: Properties
    
    var loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    // MARK: Init
    
    class func displayIn(parentView: UIView, animated: Bool) -> LoadingView {
        let loadingView = LoadingView(frame: .zero)
        
        loadingView.alpha = 0
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(loadingView)
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view" : loadingView]))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view" : loadingView]))
        
        if animated {
            UIView.animate(withDuration: LoadingViewAnimationDuration, animations: {
                loadingView.alpha = 1
            })
        } else {
            loadingView.alpha = 1
        }
        
        return loadingView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
        
        self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.loadingIndicator)
        self.addConstraint(NSLayoutConstraint(item: self.loadingIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.loadingIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.loadingIndicator.startAnimating()
    }
    
    func dismissWith(animation animated: Bool) {
        DispatchQueue.main.async {
            if animated {
                UIView.animate(withDuration: LoadingViewAnimationDuration, animations: {
                    self.alpha = 0
                }, completion: { (success) in
                    self.removeFromSuperview()
                })
            } else {
                self.alpha = 0
                self.removeFromSuperview()
            }
        }
    }
    
}
