//
//  DetailedTweetsTVC.swift
//  TweeterTags
//
//  Created by Cao Xuyang on 2018/3/9.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import UIKit

class imageCell: UITableViewCell {
    @IBOutlet weak var tweetsImage: UIImageView!
}
class tagTVCell: UITableViewCell {
    @IBOutlet weak var tweetLabel: UILabel!
}



class DetailedTweetsTVC: UITableViewController {
    private var tweet: TwitterTweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "go to second table" {
            let destinationVC = segue.destination
            if let secondTVC = (destinationVC as? SecondTVC) {
                if let cell = sender as? tagTVCell {
                    secondTVC.setText((cell.tweetLabel.text)!)
                }
            }
        }
        if segue.identifier == "go to image" {
            let destinationVC = segue.destination
            if let imageVC = (destinationVC as? ImageScrollVC) {
                imageVC.setImage(((sender as? imageCell)?.tweetsImage.image)!)
            }
        }
        //passData(
    }
    
    private func openInSafari(_ urlString: String){
            UIApplication.shared.open(URL(string : urlString)!, options: [:], completionHandler: { (status) in
                
                
            })
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "go to second table" {
                let cell = sender as? tagTVCell
                if var labelstring = cell?.tweetLabel.text {
                    let first: Character = labelstring.remove(at: labelstring.startIndex)
                    if(first == "#" || first == "@") {
                        return true;
                    }
                }
                openInSafari(cell!.tweetLabel.text!)
                return false;
            }
            
            if ident == "go to image" {
                return true
            }

        }
        
        
        return false
    }
    
    // MARK: - Table view data source

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tweet == nil {
            return 0
        }
        return 4
    }
    /*
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let titles = ["Images","Hashtags","Users","Urls"]
        return titles
    }
 */
    
    
    var cellsInSections = [0,0,0,0]
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            cellsInSections[0] = tweet!.media.count
            return tweet!.media.count;
        case 1:
            cellsInSections[1] = tweet!.hashtags.count
            return tweet!.hashtags.count
        case 2:
            cellsInSections[2] = tweet!.userMentions.count
            return tweet!.userMentions.count
        case 3:
            cellsInSections[3] = tweet!.urls.count
            return tweet!.urls.count
            
        default:
            return 0
        }
    }
    
    func passData(_ tweets: TwitterTweet){
        tweet = tweets
        self.tableView.reloadData()
    }
    let headers = ["Image","Hashtags","UserMentions","Urls"]
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if cellsInSections[section] == 0{
            return nil
        }
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
            case 0:
                let dequeued: AnyObject = tableView.dequeueReusableCell(withIdentifier: "image tweets", for: indexPath)
                let cell = dequeued as! imageCell
                let url = tweet?.media[indexPath.row].url
                // dispatchQueue will not block the UI
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        if let myData = data{
                            cell.tweetsImage.image = UIImage(data: myData)
                        }
                    }
                }
                return cell
            case 1:
                let dequeued: AnyObject = tableView.dequeueReusableCell(withIdentifier: "tag tweets", for: indexPath)
                let cell = dequeued as! tagTVCell
                cell.tweetLabel.text = tweet?.hashtags[indexPath.row].keyword
                return cell
            case 2:
                let dequeued: AnyObject = tableView.dequeueReusableCell(withIdentifier: "tag tweets", for: indexPath)
                let cell = dequeued as! tagTVCell
                cell.tweetLabel.text = tweet?.userMentions[indexPath.row].keyword
                return cell
            case 3:
                let dequeued: AnyObject = tableView.dequeueReusableCell(withIdentifier: "tag tweets", for: indexPath)
                let cell = dequeued as! tagTVCell
                cell.tweetLabel.text = tweet?.urls[indexPath.row].keyword
                return cell
            default:
                let dequeued: AnyObject = tableView.dequeueReusableCell(withIdentifier: "image tweets", for: indexPath)
                let cell = dequeued as! imageCell
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
