//
//  SignInViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/16/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    
    @IBOutlet weak var lblWarning: UILabel!
    
    let picker = UIImagePickerController()
    var isCreate : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblWarning.hidden = true
        picker.delegate = self
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtRePassword.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //move UI up or down as keyboard shows and hides
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        // Do any additional setup after loading the view.
    }
    
    // move the view upwards as keyboard appears
    func keyboardWillShow(sender: NSNotification) {
        if self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= 100
        }
    }
    
    // move the keyboard back as keyboard disapears
    func keyboardWillHide(sender: NSNotification) {
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y += 100
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func btnCreateClicked(sender: AnyObject) {
        let strFirstName = txtFirstName.text
        let strLastName = txtLastName.text
        let strEmail = txtEmail.text
        let strPassword = txtPassword.text
        let strRePassword = txtRePassword.text
        
        /*-------------------------------------- Save Data in Core Data -------------------------------------*/
        if (strFirstName == "" || strLastName == "" || strEmail == "" || strPassword == "" || strRePassword == "" || imgProfile.image == nil){
            let alert = UIAlertController(title: "Error!", message: "Please enter all information", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction) in print("All info needed")}))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            if strPassword == strRePassword {
                lblWarning.hidden = true
                
                isCreate = true
                for account in aryAccount {
                    let email = account.valueForKey("email") as! String
                    let firstName = account.valueForKey("firstName") as! String
                    let lastName = account.valueForKey("lastName") as! String
                    
                    if email == strEmail {
                        isCreate = false
                        let alert = UIAlertController(title: "Cannot create an account!", message: "Email exists", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                            UIAlertAction in
                            
                            })
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    if firstName == strFirstName && lastName == strLastName {
                        isCreate = false
                        let alert = UIAlertController(title: "Cannot create an account!", message: "Name exists", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                            UIAlertAction in
                            
                            })
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                
                if isCreate == true {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext
                    
                    let entity =  NSEntityDescription.entityForName("User", inManagedObjectContext:managedContext)
                    let account = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                    
                    account.setValue(strFirstName, forKey: "firstName")
                    account.setValue(strLastName, forKey: "lastName")
                    account.setValue(strEmail, forKey: "email")
                    account.setValue(strPassword, forKey: "password")
                    let img = imgProfile.image
                    let dataImage : NSData = UIImageJPEGRepresentation(img!, 0.3)!
                    account.setValue(dataImage, forKey: "photo")
                    
                    do {
                        try managedContext.save()
                        let alert = UIAlertController(title: "Success!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Account created.", style: UIAlertActionStyle.Default){
                            UIAlertAction in
                            self.navigationController?.popViewControllerAnimated(true)
                            })
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                    } catch let error as NSError  {
                        let alert = UIAlertController(title: "Failed!", message: "Could not save \(error), \(error.userInfo)", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction) in print("Error")}))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            else{
                lblWarning.hidden = false
            }
        }
        
        /*----------------------------------------------------------------------------------------------------*/
    }

    @IBAction func btnSelectClicked(sender: AnyObject) {
        
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
            //camera not available
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            
        }
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgProfile.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
