//
//  AddEditPostViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/19/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit

class AddEditPostViewController: UIViewController {

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
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func savePost(sender: UIButton) {
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
