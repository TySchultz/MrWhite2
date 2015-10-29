//
//  LeaderboardTableViewController.swift
//  MrWhite2
//
//  Created by Ty Schultz on 10/26/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift

class LeaderboardTableViewController: UITableViewController {

    
    var topScores : NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        topScores = []
        
        print(Realm.Configuration.defaultConfiguration)
        let realm = try! Realm()
        let scores = realm.objects(Score).sorted("time")
        for score in scores{
            topScores.addObject(score)
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return topScores.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> LeaderBoardCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! LeaderBoardCell

        let score = topScores.objectAtIndex(indexPath.row) as! Score
        cell.time.text = timeText(score.time)
        cell.initials.text = score.initials
        cell.rank.text = "#\(indexPath.row+1)"
        // Configure the cell...

        return cell
    }

    func timeText (time : Int) -> String {
        if time < 10 {
            return  "0:0\(time)"
        }else if time < 60 {
            return "0:\(time)"
        }else if time < 600 {
            let tmp = time % 60
            let minutes = Int(floor(Double(time) / 60.0))
            if tmp < 10 {
                return "\(minutes):0\(tmp)"
            }else if tmp < 60 {
                return "\(minutes):\(tmp)"
            }
        }else{
            return "\(time)"
        }
        return "0:00"
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
