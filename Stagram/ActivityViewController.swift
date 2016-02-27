//
//  ActivityViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import Parse

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var postedActivities: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UserMedia.fetchUserActivity { (objects, error) -> () in
            if error == nil{
                self.postedActivities = objects
                self.tableView.reloadData()
            }else{
                print("Terrible thing just happened here")
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let postedActivities = self.postedActivities{
            return postedActivities.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityViewCell
        let activityObject = postedActivities?[indexPath.row]
        let activityString = activityObject?.objectForKey("activity") as? String
        let timeString = getTimePastFromDate(activityObject!.createdAt!)
        
        cell.activityLabel.text = activityString!
        cell.timeLabel.text = timeString
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
