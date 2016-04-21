//
//  HomeViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/17/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainPostTable: UITableView!
    
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var dataViewController: NSFetchedResultsController = NSFetchedResultsController()
    
    var currentUserFName: String = String()
    var currentUserLName: String = String()
    
    func getFetchResultsController() -> NSFetchedResultsController {
        
        dataViewController = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return dataViewController
        
    }
    
    func listFetchRequest() -> NSFetchRequest {
        var searchText = searchBar.text!
        searchText = searchText.stringByReplacingOccurrencesOfString(",", withString: "")
        while searchText.rangeOfString("  ") != nil {
            searchText = searchText.stringByReplacingOccurrencesOfString("  ", withString: " ")
        }
        let words = searchText.componentsSeparatedByString(" ")
        
        let fetchRequest = NSFetchRequest(entityName: "MainPost")
        let sortDescripter = NSSortDescriptor(key: "postDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescripter]
        
        var predicates:[NSPredicate] = []
        
        for word in words {
            let attractionPredicate = NSPredicate(format: "attraction like[cd] %@", "*" + word + "*")
            let cityPredicate = NSPredicate(format: "city like[cd] %@", "*" + word + "*")
            let statePredicate = NSPredicate(format: "state like[cd] %@", "*" + word + "*")
            predicates.append(NSCompoundPredicate.init(orPredicateWithSubpredicates: [attractionPredicate, cityPredicate, statePredicate]))
        }
        
        let predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
        let newPredicate = NSCompoundPredicate.init()
        fetchRequest.predicate = predicate
        
        return fetchRequest
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        dataViewController = getFetchResultsController()
        
        dataViewController.delegate = self
        do {
            try dataViewController.performFetch()
        } catch _ {
        }
        
        mainPostTable.estimatedRowHeight = 256
        mainPostTable.rowHeight = UITableViewAutomaticDimension
        
        let currentAccount = MasterData.sharedInstance.currentUserProfile
        currentUserFName = currentAccount!.valueForKey("firstName") as! String
        currentUserLName = currentAccount!.valueForKey("lastName") as! String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        if searchBar.text == "" {
            //fetch the data again
            dataViewController = getFetchResultsController()
            dataViewController.delegate = self
            do {
                try dataViewController.performFetch()
            } catch _ {
            }
            
            mainPostTable.reloadData()
        }
        
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //fetch the data again
        dataViewController = getFetchResultsController()
        dataViewController.delegate = self
        do {
            try dataViewController.performFetch()
        } catch _ {
        }
        
        mainPostTable.reloadData()
        
        searchBar.resignFirstResponder()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.mainPostTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections  = dataViewController.sections?.count
        return numberOfSections!
        //return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = dataViewController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
        //return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainPost", forIndexPath: indexPath) as! MainPostTableViewCell
        let mainPostInfo = dataViewController.objectAtIndexPath(indexPath) as! MainPost
        cell.personName?.text = mainPostInfo.poster!.firstName! + " " + mainPostInfo.poster!.lastName!
        
        if mainPostInfo.poster!.photo != nil {
            cell.personPhoto.image = UIImage(data: (mainPostInfo.poster!.photo)! as NSData)
        }
        else {
            cell.personPhoto.image = UIImage(named: "nophoto.png")
        }
        
        var placeNameText = "";
        if mainPostInfo.attraction != "" {
            placeNameText = mainPostInfo.attraction! + " in "
        }
        placeNameText += mainPostInfo.city! + ", " + mainPostInfo.state!
        cell.placeName?.text = placeNameText
        
        if(mainPostInfo.placePhoto != nil) {
            cell.placePhoto.image = UIImage(data: (mainPostInfo.placePhoto)! as NSData)
        }
        else {
            cell.placePhoto.image = UIImage(named: "nophoto.png")
        }
        
        cell.postDate?.text = mainPostInfo.postDate
        cell.comment?.text = mainPostInfo.commentText
        
        return cell
        
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        let mainPostInfo = dataViewController.objectAtIndexPath(indexPath) as! MainPost
        //only allow a user to delete their own posts
        if(mainPostInfo.poster!.firstName == currentUserFName && mainPostInfo.poster!.lastName == currentUserLName) {
            return true
        }
        else {
            return false
        }
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle:   UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let record = dataViewController.objectAtIndexPath(indexPath) as! MainPost
            context.deleteObject(record)
            do {
                try context.save()
            } catch _ {
            }
            mainPostTable.reloadData()
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
        searchBar.endEditing(true)
        
        if signOutButton === sender {
            //do nothing
        }
        else if segue.identifier == "addPost" {
            var destinationController = segue.destinationViewController as! AddEditPostViewController
            destinationController.navigationItem.title = "Add Post"
        }
        else if segue.identifier == "showPost"
        {
            let cell = sender as! UITableViewCell
            let indexPath = self.mainPostTable.indexPathForCell(cell)
            let dest: MainPostViewController =  segue.destinationViewController as! MainPostViewController
            let row = dataViewController.objectAtIndexPath(indexPath!) as! MainPost
            dest.currentPost = row
            
        }
    }

}
