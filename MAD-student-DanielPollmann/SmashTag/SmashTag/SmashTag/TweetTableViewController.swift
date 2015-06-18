//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Daniel Pollmann on 24-04-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    var tweets = [[Tweet]]()
    var initialLoad: Bool = true
    var searchText: String? = "#stanford" {
        didSet{
            lastSuccesfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    var lastSuccesfulRequest : TwitterRequest?
    
    var nextRequestToAttempt : TwitterRequest?{
        if lastSuccesfulRequest == nil{
            if searchText != nil{
                return TwitterRequest(search: searchText!, count: 100)
            }else{
                return nil
            }
        }else{
            return lastSuccesfulRequest!.requestForNewer
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
        initialLoad = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if(!initialLoad){
            RecentSearches().addSearch(searchText!)
        }
        if let request = nextRequestToAttempt{
            request.fetchTweets{(newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0{
                        self.lastSuccesfulRequest = request
                        self.tweets.insert(newTweets, atIndex: 0)
                        self.tableView.reloadData()
                    }
                    sender?.endRefreshing()
                }
            }
        }else{
            sender?.endRefreshing()
        }
    }
    
    func refresh(){
        refreshControl?.beginRefreshing()
        refresh(refreshControl)
    }
    
    // MARK - Storyboard Connectivity
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField{
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    private struct Storyboard{
        static let CellReuseIdentifier = "Tweet"
    }
    // MARK: - UITableViewDataSource
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        
        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
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
    
    
    // MARK: - Navigation
    
    //     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //     Get the new view controller using [segue destinationViewController].
        //     Pass the selected object to the new view controller.
  
        if segue.identifier == "Show Details"{
            var destination = segue.destinationViewController as? MentionsTableViewController
            if let cellOfTweet = sender as? TweetTableViewCell{
                destination?.tweet = cellOfTweet.tweet
            }
        }
    }
    
//    @IBAction func prepareForUnwind(segue: UIStoryboardSegue, sender: AnyObject?){
//        let source = segue.sourceViewController as? MentionsTableViewController
//        let title = source?.mentions[0].title
//        var alert = UIAlertController(title: title, message: source?.mentions[0].data.description, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Working!!", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
//        if title == "Users" || title == "HashTags"{
//            searchText = source?.textOfSelectedItem
//        }
//    }
}