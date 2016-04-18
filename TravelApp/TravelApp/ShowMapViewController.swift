//
//  ShowMapViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/19/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit
import MapKit

class ShowMapViewController: UIViewController {

    @IBOutlet weak var placeMap: MKMapView!
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    
    var attractionName = String()
    var placeName = String()
    var lon = Double()
    var lat = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeMap.mapType = .Standard
        
        if lon != 1000 {
            showPlace()
        }
        else {
            //no info
            let alert = UIAlertController(title: "No Location Data", message: "This is not a valid location.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction) in print("Bad location")}))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func mapTypeSelected(sender: UISegmentedControl) {
        if(mapTypeControl.selectedSegmentIndex == 0) {
            placeMap.mapType = .Standard
        }
        else if(mapTypeControl.selectedSegmentIndex == 1) {
            placeMap.mapType = .Satellite
        }
    }
    
    func showPlace() {
        let coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lon))
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.placeMap.setRegion(region, animated: true)
        
        let ani = MKPointAnnotation()
        ani.coordinate = coordinates
        
        if attractionName == "" {
            ani.title = placeName
        }
        else {
            ani.title = attractionName
            ani.subtitle = placeName
        }
        
        self.placeMap.addAnnotation(ani)
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
