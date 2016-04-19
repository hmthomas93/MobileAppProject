//
//  AccountMainViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/17/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//




import UIKit
import CoreData

class AccountMainViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblWarning: UILabel!
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    

    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblWarning.hidden = true
        picker.delegate = self
        
        let currentAccount = MasterData.sharedInstance.currentUserProfile
        let email = currentAccount!.valueForKey("email") as! String
        let firstName = currentAccount!.valueForKey("firstName") as! String
        let lastName = currentAccount!.valueForKey("lastName") as! String
        let imageData = currentAccount!.valueForKey("photo") as! NSData
        imgProfile.image = UIImage(data: imageData)
        
        lblName.text = firstName + " " + lastName
        txtEmail.text = email
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.view.frame.origin.y == 0.0 {
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame.origin.y = self.view.frame.origin.y - 100
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if self.view.frame.origin.y == 0.0 {
            
        }
        else{
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame.origin.y = 0.0
            })
        }
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnEditClicked(sender: UIButton) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let currentAccount = MasterData.sharedInstance.currentUserProfile
        currentAccount?.setValue(txtEmail.text, forKey: "email")
        
        do {
            try managedContext.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    
    //TODO
    @IBAction func btnSignoutClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    @IBAction func btnSelectClicked(sender: UIButton) {
        
        let alert = UIAlertController(title: "Select a Photo", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.picker.modalPresentationStyle = .Popover
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        alert.addAction(libButton)
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (alert) -> Void in
                self.picker.allowsEditing = false
                self.picker.sourceType = .Camera
                self.picker.modalPresentationStyle = .Popover
                self.presentViewController(self.picker, animated: true, completion: nil)
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
  
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgProfile.image = chosenImage
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let currentAccount = MasterData.sharedInstance.currentUserProfile
        
        let dataImage : NSData = UIImageJPEGRepresentation(chosenImage, 0.3)!
        currentAccount!.setValue(dataImage, forKey: "photo")
        
        do {
            try managedContext.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //TODO
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if signOutButton === sender {
            //do nothing
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
