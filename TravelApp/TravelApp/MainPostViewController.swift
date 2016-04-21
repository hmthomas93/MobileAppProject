//
//  MainPostViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/19/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit
import CoreData

class MainPostViewController: UIViewController, UITextViewDelegate, UpdatePostInfo, UpdateCommentInfo {

    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var personNameField: UILabel!
    @IBOutlet weak var placeNameField: UILabel!
    @IBOutlet weak var personPhoto: UIImageView!
    @IBOutlet weak var postDateField: UILabel!
    @IBOutlet weak var commentField: UILabel!
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var commentTextArea: UITextView!
    @IBOutlet weak var editPostButton: UIButton!
    @IBOutlet weak var postHeight: NSLayoutConstraint!
    
    var currentPost:MainPost? = nil
    var currentUserFName:String = String()
    var currentUserLName:String = String()
    var commentList = [Comment]()
    
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commentTextArea.delegate = self
        self.commentTextArea.layer.borderWidth = 1
        self.commentTextArea.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        if currentPost != nil {
            personNameField.text = (currentPost?.poster!.firstName)! + " " + (currentPost?.poster!.lastName)!
            var placeName = ""
            if currentPost?.attraction != "" {
                placeName += ((currentPost?.attraction)! + " in ")
            }
            placeName += (currentPost?.city)! + ", " + (currentPost?.state)!
            placeNameField.text = placeName
            
            if currentPost?.placePhoto != nil {
                placePhoto.image = UIImage(data: (currentPost?.placePhoto)! as NSData)
            }
            
            if currentPost?.poster!.photo != nil {
                personPhoto.image = UIImage(data: (currentPost?.poster!.photo)! as NSData)
            }
            
            postDateField.text = currentPost?.postDate
            commentField.text = currentPost?.commentText
            
            commentList = (currentPost?.comments?.allObjects)! as! [Comment]
            
            let currentAccount = MasterData.sharedInstance.currentUserProfile
            currentUserFName = currentAccount!.valueForKey("firstName") as! String
            currentUserLName = currentAccount!.valueForKey("lastName") as! String
            
            if currentPost?.poster?.firstName == currentUserFName && currentPost?.poster?.lastName == currentUserLName {
                editPostButton.enabled = true
                editPostButton.hidden = false
            }
            else {
                editPostButton.enabled = false
                editPostButton.hidden = true
            }
        }
        
        commentsTable.estimatedRowHeight = 100
        commentsTable.rowHeight = UITableViewAutomaticDimension
        
        calculateCommentHeight()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "screenTouched:")
        view.addGestureRecognizer(tap)
        
        //move UI up or down as keyboard shows and hides
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // move the view upwards as keyboard appears
    func keyboardWillShow(sender: NSNotification) {
        if self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= 200
        }
    }
    
    // move the keyboard back as keyboard disapears
    func keyboardWillHide(sender: NSNotification) {
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y += 200
        }
    }
    
    func screenTouched(sender: UITapGestureRecognizer){
        //if the user tapped the table view, load the table view
        let touch = sender.locationInView(commentsTable)
        if let indexPath = commentsTable.indexPathForRowAtPoint(touch) {
            let cell = commentsTable.cellForRowAtIndexPath(indexPath) as! CommentTableViewCell
            if(cell.personName.text == currentUserFName + " " + currentUserLName) {
                performSegueWithIdentifier("editComment", sender: cell)
            }
        }
        
        view.endEditing(true)
    }
    
    //resize the height of the view based on comment length, since a comment can span multiple lines
    func calculateCommentHeight() {
        //the sizeToFit() method inaccurately resizes the label based on the text
        //create a fake text label with a modified width and calculate its size
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, commentField.frame.width * 13.5 / 20, CGFloat.max))
        //match all other properties of the comment field
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = commentField.font
        label.text = commentField.text
        
        label.sizeToFit()
        //now recalculate the UIView's height
        postHeight.constant += label.frame.height - 20 - 1/3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentPost?.comments!.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("comment", forIndexPath: indexPath) as! CommentTableViewCell
        
        let commentInfo = commentList[indexPath.row]
        cell.personName?.text = commentInfo.posterName
        cell.postDate?.text = commentInfo.postDate
        cell.comment?.text = commentInfo.commentText
        
        if commentInfo.posterPhoto != nil {
            cell.personPhoto.image = UIImage(data: (commentInfo.posterPhoto)! as NSData)
        }
        else {
            cell.personPhoto.image = UIImage(named: "nophoto.png")
        }
        
        if(cell.personName.text == currentUserFName + " " + currentUserLName) {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        let commentInfo = commentList[indexPath.row]
        //only allow a user to delete their own comments
        if(commentInfo.posterName == currentUserFName + " " + currentUserLName) {
            return true
        }
        else {
            return false
        }
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle:   UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let record = commentList[indexPath.row]
            context.deleteObject(record)
            do {
                try context.save()
            } catch _ {
            }
            commentsTable.reloadData()
        }
    }
    
    //This method doesn't work with the UITapGestureRecognizer
    //The code is now inside that method
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CommentTableViewCell
        if(cell.personName.text == currentUserFName + " " + currentUserLName) {
            performSegueWithIdentifier("editComment", sender: cell)
        }
    }*/
    
    @IBAction func addComment(sender: UIButton) {
        if (self.commentTextArea.text == ""){
            let alert = UIAlertController(title: "Error!", message: "Please enter a comment to post.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            let context = self.context
            let ent = NSEntityDescription.entityForName("Comment", inManagedObjectContext: context)
            
            let nItem = Comment(entity: ent!, insertIntoManagedObjectContext: context)
            
            let currentAccount = MasterData.sharedInstance.currentUserProfile
            let firstName = currentAccount!.valueForKey("firstName") as! String
            let lastName = currentAccount!.valueForKey("lastName") as! String
            let imageData = currentAccount!.valueForKey("photo") as! NSData
            
            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            let stringDate = dateFormatter.stringFromDate(currentDate)
            
            nItem.posterName = firstName + " " + lastName
            nItem.posterPhoto = imageData
            nItem.commentText = self.commentTextArea.text!
            nItem.postDate = stringDate
            nItem.post = currentPost
            
            do {
                try context.save()
            } catch _ {
            }
            
            //remove text from comment area after comment is posted
            self.commentTextArea.text = ""
            
            //add the comment to the list of comments
            commentList.append(nItem)
            commentsTable.reloadData()
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
            
            destinationController.currentPost = currentPost
            
            destinationController.updatePostDelegate = self
        }
        else if segue.identifier == "editComment"
        {
            let selectedIndex: NSIndexPath = self.commentsTable.indexPathForCell(sender as! UITableViewCell)!
            let row = commentList[selectedIndex.row]
            let dest: EditCommentViewController =  segue.destinationViewController as! EditCommentViewController
            dest.currentComment = row
            
            dest.updateCommentDelegate = self
        }
        else if segue.identifier == "showMap"
        {
            var destinationController = segue.destinationViewController as! ShowMapViewController
            destinationController.lat = Double((currentPost?.latitude)!)
            destinationController.lon = Double((currentPost?.longitude)!)
            
            if currentPost?.attraction != "" {
                destinationController.attractionName = (currentPost?.attraction)!
            }
            else {
                destinationController.attractionName = ""
            }
            destinationController.placeName = (currentPost?.city)! + ", " + (currentPost?.state)!
        }
    }

    //update the current post with data passed from editing a post
    func sendPostToMainPost(updatedPost: MainPost) {
        currentPost = updatedPost
        
        personNameField.text = (currentPost?.poster!.firstName)! + " " + (currentPost?.poster!.lastName)!
        var placeName = ""
        if currentPost?.attraction != "" {
            placeName += ((currentPost?.attraction)! + " in ")
        }
        placeName += (currentPost?.city)! + ", " + (currentPost?.state)!
        placeNameField.text = placeName
        
        if currentPost?.placePhoto != nil {
            placePhoto.image = UIImage(data: (currentPost?.placePhoto)! as NSData)
        }
        
        if currentPost?.poster!.photo != nil {
            personPhoto.image = UIImage(data: (currentPost?.poster!.photo)! as NSData)
        }
        
        postDateField.text = currentPost?.postDate
        commentField.text = currentPost?.commentText
    }
    
    func sendCommentToMainPost(updatedComment: Comment, index: Int) {
        commentList[index] = updatedComment
        commentsTable.reloadData()
        
        calculateCommentHeight()
    }
}
