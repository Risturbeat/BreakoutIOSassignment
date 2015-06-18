//
//  MentionsTableViewCell.swift
//  SmashTag
//
//  Created by Student on 24-04-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit

class MentionsTableViewImageCell: UITableViewCell {
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    var imageUrl: NSURL? {
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        if let url = imageUrl{
            //Start a new thread to get the image, this may take a while
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if imageData == nil{
                        self.tweetImage?.image = nil
                    }else{
                        self.tweetImage?.image = UIImage(data:imageData!)
                    }
                }
            }
        }
    }
}
