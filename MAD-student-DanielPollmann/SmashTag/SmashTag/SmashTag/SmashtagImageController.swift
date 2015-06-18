//
//  SmashtagImageController.swift
//  SmashTag
//
//  Created by Student on 01-05-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit

class SmashtagImageController: UIViewController, UIScrollViewDelegate{
    
    var imageView  = UIImageView()
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scale()
        }
    }
    
        @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size // critical to set this!
            scrollView.delegate = self                    // required for zooming
            scrollView.minimumZoomScale = 0.3            // required for zooming
            scrollView.maximumZoomScale = 5.0             // required for zooming
        }
    }
    
    func scale(){
        //source: http://www.raywenderlich.com/76436/use-uiscrollview-scroll-zoom-content-swift
        if let scrollViewFrame = scrollView?.frame{
            let scaleWidth = scrollView.bounds.size.width / image!.size.width
            let scaleHeight = scrollView.bounds.size.height / image!.size.height
            scrollView.zoomScale = max(scaleWidth, scaleHeight)
            centerScrollViewContents()
        }
    }
   
    // UIScrollViewDelegate method
    // required for zooming
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // put our imageView into the view hierarchy
    // as a subview of the scrollView
    // (will install it into the content area of the scroll view)
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        scale()
    }
}
