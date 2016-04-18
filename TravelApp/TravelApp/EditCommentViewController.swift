//
//  EditCommentViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/19/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit

class EditCommentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var commentTextArea: UITextView!
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var currentComment:Comment? = nil
    var currentCommentIndex = 0
    
    weak var updateCommentDelegate:UpdateCommentInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commentTextArea.delegate = self
        self.commentTextArea.layer.borderWidth = 1
        self.commentTextArea.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        if currentComment != nil {
            commentTextArea.text = currentComment?.commentText
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //make the keyboard disappear as user touches outside the text boxes
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.commentTextArea.resignFirstResponder()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }
    @IBAction func saveComment(sender: UIBarButtonItem) {
        if (self.commentTextArea.text == ""){
            let alert = UIAlertController(title: "Error!", message: "Please enter a comment to post.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.currentComment!.commentText = self.commentTextArea.text!
            
            do {
                try self.context.save()
            } catch _ {
            }
            
            self.updateCommentDelegate?.sendCommentToMainPost(self.currentComment!, index: self.currentCommentIndex)
            navigationController!.popViewControllerAnimated(true)
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

}

//protocol to pass data back to previous view controller
protocol UpdateCommentInfo: class {
    func sendCommentToMainPost(updatedComment: Comment, index: Int)
}
