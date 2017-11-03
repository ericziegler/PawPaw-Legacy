//
//  GTZoomableImageView.swift
//  RareBeerFest
//
//  Created by Eric Ziegler on 10/27/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

public final class GTZoomableImageView: UIView {
    
    @IBInspectable public var image: UIImage? {
        didSet {
            imageView.image = image
            setup()
        }
    }
    
    @IBInspectable public var minimumZoomScale: CGFloat = 1.0
    @IBInspectable public var maximumZoomScale: CGFloat = 3.0
    
    internal let imageView = UIImageView()
    private let scrollImg = UIScrollView()
    
    public func setup(image: UIImage) {
        self.image = image
        setup()
    }
    
    override public func layoutSubviews() {
        if !isZoomed() {
            imageView.frame.size = self.frame.size
            scrollImg.frame.size = self.frame.size
        }
    }
    
    public func zoomIn(rect: CGRect, animated: Bool = false) {
        scrollImg.zoom(to: rect, animated: animated)
    }
    
    public func zoomIn(point: CGPoint, scale: CGFloat, animated: Bool = true) {
        let imageZoomRect = frame.size.width / scale
        zoomIn(rect: CGRect(x: point.x - imageZoomRect / 2, y: point.y - imageZoomRect / 2, width: imageZoomRect, height: imageZoomRect), animated: animated)
    }
    
    func zoomOut(animated: Bool = true) {
        self.scrollImg.setZoomScale(minimumZoomScale, animated: animated)
    }
    
    @objc func autoZoom(gesture: UITapGestureRecognizer) {
        if scrollImg.zoomScale > minimumZoomScale {
            zoomOut()
        } else {
            zoomIn(point: gesture.location(in: scrollImg), scale: maximumZoomScale)
        }
    }
    
    internal func setup() {
        contentMode = .scaleAspectFit
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = false
        imageView.image = image
        
        let vWidth = self.frame.width
        let vHeight = self.frame.height
        
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        scrollImg.backgroundColor = UIColor.clear
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = false
        scrollImg.showsHorizontalScrollIndicator = false
        scrollImg.flashScrollIndicators()
        scrollImg.minimumZoomScale = minimumZoomScale
        scrollImg.maximumZoomScale = maximumZoomScale
        scrollImg.clipsToBounds = false
        
        self.addSubview(scrollImg)
        
        scrollImg.addSubview(imageView)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(GTZoomableImageView.autoZoom(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTap)
        
    }
    
    internal func isZoomed() -> Bool {
        return scrollImg.zoomScale != scrollImg.minimumZoomScale
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
}

extension GTZoomableImageView: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

