//
//  ChangePasswordViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/17/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//





import UIKit

class ChangePassViewController: UIViewController {
    
    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var lblWarning: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblWarning.hidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
    
    @IBAction func btnSavePassClicked(sender: AnyObject) {
        let currentAccount = MasterData.sharedInstance.currentUserProfile
        let oldPass = currentAccount?.valueForKey("password") as! String
        
        if oldPass == txtOldPassword.text {
            if txtNewPassword.text == txtRePassword.text {
                lblWarning.hidden = true
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                let currentAccount = MasterData.sharedInstance.currentUserProfile
                currentAccount?.setValue(txtRePassword.text, forKey: "password")
                
                do {
                    try managedContext.save()
                    let alert = UIAlertController(title: "Password changed", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction) in print("E")}))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            else{
                lblWarning.hidden = false
            }
        }
        else{
            let alert = UIAlertController(title: "Incorrect password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction) in print("Error")}))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func savePassword(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
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