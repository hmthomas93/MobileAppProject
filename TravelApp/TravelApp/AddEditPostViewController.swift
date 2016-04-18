//
//  AddEditPostViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/19/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AddEditPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var attractionField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var commentTextArea: UITextView!
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var currentPost:MainPost? = nil
    
    var lon:Double = 0
    var lat:Double = 0
    
    weak var updatePostDelegate:UpdatePostInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.attractionField.delegate = self
        self.cityField.delegate = self
        self.stateField.delegate = self
        self.commentTextArea.delegate = self
        
        self.commentTextArea.layer.borderWidth = 1
        self.commentTextArea.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        if currentPost != nil {
            if currentPost?.placePhoto != nil {
                placePhoto.image = UIImage(data: (currentPost?.placePhoto)! as NSData)
            }
            
            attractionField.text = currentPost?.attraction
            cityField.text = currentPost?.city
            stateField.text = currentPost?.state
            commentTextArea.text = currentPost?.commentText
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.view.frame.origin.y == 0.0 {
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame.origin.y = self.view.frame.origin.y - 200
            })
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if self.view.frame.origin.y == 0.0 {
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame.origin.y = self.view.frame.origin.y - 200
            })
        }
    }
    
    //make the keyboard disappear with the return key (for the name field only)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.attractionField.resignFirstResponder()
        self.cityField.resignFirstResponder()
        self.stateField.resignFirstResponder()
        
        if self.view.frame.origin.y != 0.0 {
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame.origin.y = self.view.frame.origin.y + 200
            })
        }
        
        return true
    }
    
    func dismissKeyboard(){
        if self.view.frame.origin.y != 0.0 {
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame.origin.y = self.view.frame.origin.y + 200
            })
        }
        
        view.endEditing(true)
    }
    
    @IBAction func selectPhoto(sender: UIButton) {
        var picker = UIImagePickerController ()
        picker.delegate = self
        
        
        let alert = UIAlertController(title: "Select a Photo", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            picker.allowsEditing = false
            picker.sourceType = .PhotoLibrary
            picker.modalPresentationStyle = .Popover
            self.presentViewController(picker, animated: true, completion: nil)
        }
        alert.addAction(libButton)
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (alert) -> Void in
                picker.allowsEditing = false
                picker.sourceType = .Camera
                picker.modalPresentationStyle = .Popover
                self.presentViewController(picker, animated: true, completion: nil)
            }
            alert.addAction(cameraButton)
        }
        else {
            print("Camera not available")
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            
        }
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        placePhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func savePost(sender: UIButton) {
        //error checking - attraction is optional
        if (cityField == "" || stateField == "" || placePhoto.image == nil){
            let alert = UIAlertController(title: "Error!", message: "Please enter all information", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            //geocode the given location
            var location = ""
            if attractionField.text != nil {
                location += attractionField.text!
            }
            location += " " + cityField.text! + " " + stateField.text!
            print(location)
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString (location as String, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark? {
                    if(placemark != nil) {
                        self.lat = Double(placemark!.location!.coordinate.latitude)
                        self.lon = Double(placemark!.location!.coordinate.longitude)
                        
                        self.finishSaving()
                    }
                    else {
                        self.lat = 1000
                        self.lon = 1000
                        
                        let alert = UIAlertController(title: "Location Not Found", message: "Do you still wish to save this post? Without a valid location, View on Map will be unavailable and this place will not appear in My Places.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction) in
                            dispatch_async(dispatch_get_main_queue(), {
                                self.finishSaving()
                            })
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func finishSaving() {
        if self.currentPost == nil
        {
            let context = self.context
            let ent = NSEntityDescription.entityForName("MainPost", inManagedObjectContext: context)
            
            let nItem = MainPost(entity: ent!, insertIntoManagedObjectContext: context)
            nItem.poster = MasterData.sharedInstance.currentUserProfile
            nItem.attraction = self.attractionField.text!
            nItem.city = self.cityField.text!
            nItem.state = self.stateField.text!
            nItem.commentText = self.commentTextArea.text!
            
            if self.placePhoto.image != nil {
                nItem.placePhoto = UIImagePNGRepresentation(self.placePhoto.image!)
            }
            else {
                nItem.placePhoto = nil
            }
            
            nItem.latitude = self.lat
            nItem.longitude = self.lon
            
            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            let stringDate = dateFormatter.stringFromDate(currentDate)
            
            nItem.postDate = stringDate
            
            do {
                try context.save()
            } catch _ {
            }
        }else
        {
            self.currentPost!.attraction = self.attractionField.text!
            self.currentPost!.city = self.cityField.text!
            self.currentPost!.state = self.stateField.text!
            self.currentPost!.commentText = self.commentTextArea.text!
            
            if self.placePhoto.image != nil {
                self.currentPost!.placePhoto = UIImagePNGRepresentation(self.placePhoto.image!)
            }
            else {
                self.currentPost!.placePhoto = nil
            }
            
            self.currentPost!.latitude = self.lat
            self.currentPost!.longitude = self.lon
            
            do {
                try self.context.save()
            } catch _ {
            }
            
            //send updated post back to MainPost screen
            self.updatePostDelegate?.sendPostToMainPost(self.currentPost!)
        }
        
        self.navigationController!.popViewControllerAnimated(true)
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
protocol UpdatePostInfo: class {
    func sendPostToMainPost(updatedPost: MainPost)
}
