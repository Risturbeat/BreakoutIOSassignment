//
//  MentionsTableViewController.swift
//  SmashTag
//
//  Created by Student on 24-04-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    //We need a Tweet variable since the information needed to display is from a Tweet
    var tweet: Tweet?{
        didSet{
            title = tweet?.user.screenName //To show the user this tweet belongs to in the Title
            
            //There are 4 possible mentions : Images, URLs, HashTags and Users
            //To set the header for each section I need a "title" and the data, I stored these items in a struct
            if let images = tweet?.media {
                //source: https://www.weheartswift.com/higher-order-functions-map-filter-reduce-and-more/
                //Before I looped through the array of images myself and stored all the items as a MentionItem in a new array. Remembered from the classes there is a way to transform one array into another by using "map"
                if images.count > 0{
                    mentions.append(MentionInformation(title:"Images",
                    data: images.map({MentionItem.Image($0.url, $0.aspectRatio) })))
                }
            }
            if let urls =  tweet?.urls{
                if urls.count > 0{
                    mentions.append(MentionInformation(title:"URLs",
                    data: urls.map({MentionItem.Text($0.keyword) }))) //keyword is declared in Tweet.swift
                }
            }
            if let hashtags = tweet?.hashtags{
                if hashtags.count > 0{
                    mentions.append(MentionInformation(title: "HashTags",
                    data: hashtags.map({MentionItem.Text($0.keyword) })))
                }
            }
            if let users = tweet?.userMentions{
                if users.count > 0{
                    mentions.append(MentionInformation(title: "Users",
                    data: users.map({MentionItem.Text($0.keyword) })))
                }
            }
        }
    }
    
    //An array of MentionInformation (images, urls, hashtags and users)
    var mentions:[MentionInformation] = []
    
    struct MentionInformation{
        var title : String
        var data: [MentionItem] //There is the possibility of storing an image or storing text, hence why I made an enum
    }
    
    enum MentionItem : Printable{
        case Text(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Text(let textString): return textString
            case .Image(let url, _): return url.path!
            }
        }
    }
    
    private struct Storyboard{
        static let TextCellReuseIdentifier = "TextCell"
        static let ImageCellReuseIdentifier = "ImageCell"
        static let TextCellSelectedSegueIdentifier = "TextCell Selected"
        static let ImageCellSelectedSegueIdentifier = "ImageCell Selected"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Which kind of mention is it? An Image or Text?
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention{
        case .Text(let text):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = text
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellReuseIdentifier, forIndexPath: indexPath) as! MentionsTableViewImageCell
            cell.imageUrl = url
            return cell
        }
    }
    
    //The image has to be adapted to fit in the cell whilst holding into account the aspect ratio the image has, otherwise the image might get really distorted
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention{
        case .Image(_, let aspectRatio):
            return tableView.bounds.size.width / CGFloat(aspectRatio)
        default:
            return UITableViewAutomaticDimension //If it is text, let the height be calculated automatically
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return mentions[section].title
    }
     
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //     Get the new view controller using [segue destinationViewController].
        //     Pass the selected object to the new view controller.
        if let identifier = segue.identifier{
            if identifier == Storyboard.TextCellSelectedSegueIdentifier{
                if let destination = segue.destinationViewController as? TweetTableViewController{
                    if let selectedCell = sender as? UITableViewCell{
                        //Check whether or not the selected cell contains an URL : URL's all start with http. HashTags or Users never do
                        if let url = selectedCell.textLabel?.text{
                            if url.hasPrefix("http"){
                                UIApplication.sharedApplication().openURL(NSURL(string:url)!)
                            }else{
                                destination.searchText = selectedCell.textLabel?.text
                            }
                        }
                    }
                }
            }else if identifier == Storyboard.ImageCellSelectedSegueIdentifier{
                if let destination = segue.destinationViewController as? SmashtagImageController{
                    if let selectedCell = sender as? MentionsTableViewImageCell{
                        destination.image = selectedCell.tweetImage?.image
                    }
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

}
