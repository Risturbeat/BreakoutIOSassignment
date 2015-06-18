
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Daniel Pollmann on 24-04-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet?{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var hashTagColour = UIColor.redColor()
    var urlColour = UIColor.blueColor()
    var mentionColour = UIColor.magentaColor()

    func updateUI(){
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            
            //Resource: http://makeapppie.com/2014/10/20/swift-swift-using-attributed-strings-in-swift/
            var tweetText = tweet.text
            var colouredText = NSMutableAttributedString(string: tweetText)
            
            var hashTags = tweet.hashtags
            for hashTag in hashTags{
                colouredText.addAttribute(NSForegroundColorAttributeName, value: hashTagColour, range: hashTag.nsrange)
            }
            
            var urls = tweet.urls
            for url in urls{
                colouredText.addAttribute(NSForegroundColorAttributeName, value: urlColour, range: url.nsrange)
            }
            
            var userMentions = tweet.userMentions
            for mention in userMentions{
                colouredText.addAttribute(NSForegroundColorAttributeName, value: mentionColour, range: mention.nsrange)
            }
            
//            colouredText.appendAttributedString(<#attrString: NSAttributedString#>)
            
            //tweetTextLabel?.text cannot be used since the colouredText is not a normal string, but an attributed string
            
tweetTextLabel?.attributedText = colouredText
//            tweetTextLabel?.text = tweet.text
            if tweetTextLabel.attributedText != nil{
                for _ in tweet.media {
                    colouredText.appendAttributedString(NSAttributedString(string: " 📷"))
                }
            }
            tweetTextLabel?.attributedText = colouredText
            
           
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                        self.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }
}
