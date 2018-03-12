//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Cao Xuyang on 2018/3/4.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import UIKit

class TweetTVCell: UITableViewCell {
  
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
}



class TweetsTVC: UITableViewController, UITextFieldDelegate {
    

    @IBOutlet weak var twitterQueryTextField: UITextField!
    enum StoryboardIdentifiers: String {
        case mentionsTV = "mentions"

        
        init?(_ segue: UIStoryboardSegue) {
            self.init(rawValue: segue.identifier!)
        }
    }
    
    var tweets = [[TwitterTweet]]()
    var twitterQueryText: String? = "#ucd"{
        didSet{
            refresh()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if let detailedTVC = (destinationVC as? DetailedTweetsTVC) {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            detailedTVC.passData(tweets[0][indexPath!.row])
            print("in here \(tweets[0][indexPath!.row].media.count)")
        }
        
        //passData(
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // what if I use self.tableView ??? whose tableview is that
        //self.tableView.estimatedRowHeight =
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        refresh()

        twitterQueryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //view.addGestureRecognizer(tap)

        

        //estimatedRowHeight
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //function for the textfield
    @objc private func textFieldDidChange(_ textField: UITextField){
        twitterQueryText = textField.text
    }
    
    private func refresh(){
        if twitterQueryText != nil{
            
            let tr = TwitterRequest.init(search: twitterQueryText!)
            tr.fetchTweets({(tweet) in
                self.tweets = []
                self.tweets.append(tweet)
                self.tableView.reloadData()
                //print(self.tweets[0])
            })
            
            
        }
    }
    // dismiss the keyboard and update the twitterQueryText property.

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // dafault use [0] !!!!
        if tweets.count > 0{
            return tweets[0].count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tweets.count == 0){
            let twitter = tweets[indexPath.row]
            let dequeued: AnyObject = tableView.dequeueReusableCell(withIdentifier: "tweets cell",for:indexPath)
            let cell = dequeued as! UITableViewCell
            cell.textLabel?.text = "\(twitter)"
            return cell
        }
        else{
            let twitter = tweets[0][indexPath.row]
            let dequeued: AnyObject = tableView.dequeueReusableCell(withIdentifier: "tweets cell",for:indexPath)
            let cell = dequeued as! TweetTVCell
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a"
            
            
            let url = twitter.user.profileImageURL
            // dispatchQueue will not block the UI
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if let myData = data{
                        cell.avatar.image = UIImage(data: myData)
                    }
                }
            }
            
            cell.userName?.text = "@\(twitter.user.screenName)(\(twitter.user.name))"
            cell.date?.text = dateFormatter.string(from: twitter.created)
            cell.tweetText?.text = twitter.text
            
            let attributedString = NSMutableAttributedString(string: (cell.tweetText?.text)!)
            
            let colorRed = UIColor.red
            let colorBlue = UIColor.blue
            let colorGreen = UIColor.green
            
            let urlColor = [NSAttributedStringKey.foregroundColor : colorRed]
            let hashtagColor = [NSAttributedStringKey.foregroundColor : colorBlue]
            let mentionsColor = [NSAttributedStringKey.foregroundColor : colorGreen]
            
            let mentions = twitter.userMentions
            for m in mentions{
                attributedString.addAttributes(mentionsColor, range: m.nsrange)
            }
            let urls = twitter.urls
            for u in urls {
                attributedString.addAttributes(urlColor, range: u.nsrange)
            }
            let hashtags = twitter.hashtags
            for h in hashtags {
                attributedString.addAttributes(hashtagColor, range: h.nsrange)
            }
            
            cell.tweetText?.attributedText = attributedString
            
            //print(twitter.text)
            
            return cell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

