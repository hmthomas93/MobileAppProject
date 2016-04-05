//
//  ViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/16/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//



import UIKit
import CoreData

var aryAccount : NSMutableArray!

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var isLogin : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aryAccount = NSMutableArray()
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        isLogin = false
        
        /************** Load Core Data ****************/
        print ("try to load CoreData")
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let results:NSArray = try context.executeFetchRequest(request)
            
            if (results.count > 0){
                aryAccount = NSMutableArray(array: results)
            }
            else{
                print("No results. Possible error.")
            }
            
        }
        catch let fetchError as NSError {
            print("getGalleryForItem error: \(fetchError.localizedDescription)")
        }
        /*********************************************/
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginClicked(sender: AnyObject) {
        let strEmail = txtEmail.text
        let strPassword = txtPassword.text
        for account in aryAccount {
            let email = account.valueForKey("email") as! String
            let password = account.valueForKey("password") as! String
            
            if  email == strEmail {
                if password == strPassword {
                    
                    print("login = true")
                    
                    isLogin = true
                    MasterData.sharedInstance.currentUserProfile = account as? User
                    
                    
                    //Segue Methods
                    
                    //****** Method 1: Works with pop-ups after segue (but no bottom nav bar)
                    //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    //let homeView = storyboard.instantiateViewControllerWithIdentifier("HomeViewController")
                    //self.navigationController?.pushViewController(homeView, animated: true)
                    
                    
                    //****** Method 2: Works, but no pop-ups after log-in
                    var segueName: NSString = ""
                    segueName = "test"
                    dispatch_async(dispatch_get_main_queue(), {});
                    self.performSegueWithIdentifier(segueName as String, sender: self)
                    
                }
                else{
                    let alert = UIAlertController(title: "incorrect password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                        UIAlertAction in
                        
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        //Pop-up notifications. Can get rid of these if wanted.
        if isLogin == true {
            print("account")
            let alert = UIAlertController(title: "Login Successful", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                UIAlertAction in
                
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            print("no account")
            let alert = UIAlertController(title: "No account found", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                UIAlertAction in
        
                })
            self.presentViewController(alert, animated: true, completion: nil)
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


