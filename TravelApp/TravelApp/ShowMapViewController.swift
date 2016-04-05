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
    override func viewDidLoad() {
        super.viewDidLoad()

        placeMap.mapType = .Standard
        showPlace()
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
        let location = "Chandler, AZ"
        //let address = ( sender as! NSString)
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString (location as String, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark? {
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: placemark!.location!.coordinate, span: span)
                self.placeMap.setRegion(region, animated: true)
                
                let ani = MKPointAnnotation()
                ani.coordinate = placemark!.location!.coordinate
                ani.title = location
                self.placeMap.addAnnotation(ani)
            }
        })
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
