//
//  MainPostViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/19/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit

class MainPostViewController: UIViewController {

    @IBOutlet weak var commentTextArea: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commentTextArea.layer.borderWidth = 1
        self.commentTextArea.layer.borderColor = UIColor.lightGrayColor().CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //let numberOfSections  = dataViewController.sections?.count
        //return numberOfSections!
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let numberOfRowsInSection = dataViewController.sections?[section].numberOfObjects
        //return numberOfRowsInSection!
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("comment", forIndexPath: indexPath) as! CommentTableViewCell
        /*let placeInfo = dataViewController.objectAtIndexPath(indexPath) as! Place
        let name = placeInfo.name
        let photo = placeInfo.photo
        
        cell.placeName.text = name
        if photo != nil {
        cell.placePhoto.image = UIImage(data: (photo)! as NSData)
        }
        else {
        cell.placePhoto.image = nil
        }*/
        //dummy data
        //cell.personPhoto.image = UIImage(named: "nophoto.png")
        //cell.placePhoto.image = UIImage(named: "home.png")
        if(cell.personName.text == "Poster Name") {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle:   UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        /*if (editingStyle == UITableViewCellEditingStyle.Delete) {
        let record = dataViewController.objectAtIndexPath(indexPath) as! Place
        context.deleteObject(record)
        do {
        try context.save()
        } catch _ {
        }
        
        }*/
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CommentTableViewCell
        if(cell.personName.text == "Poster Name") {
            performSegueWithIdentifier("editComment", sender: cell)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editPost" {
            var destinationController = segue.destinationViewController as! AddEditPostViewController
            destinationController.navigationItem.title = "Edit Post"
        }
    }

}
