//
//  MyPlacesViewController.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/17/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit
import MapKit

class MyPhotosViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var placesMap: MKMapView!
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.placesMap.delegate = self
        self.placesMap.mapType = MKMapType.Standard
        showPlaces()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapTypeSelected(sender: UISegmentedControl) {
        if(mapTypeControl.selectedSegmentIndex == 0) {
            self.placesMap.mapType = MKMapType.Standard
        }
        else if(mapTypeControl.selectedSegmentIndex == 1) {
            self.placesMap.mapType = MKMapType.Satellite
        }
    }
    func showPlaces() {
        let location = "Chandler, AZ"
        //let address = ( sender as! NSString)
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString (location as String, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark? {
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: placemark!.location!.coordinate, span: span)
                self.placesMap.setRegion(region, animated: true)
                
                let newAnnotation = PlaceAnnotation(t: "abc", s: "def", c: placemark!.location!.coordinate)
                self.placesMap.addAnnotation(newAnnotation)
            }
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "PlaceAnnotation"
        
        if annotation.isKindOfClass(PlaceAnnotation.self) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
                
                /*let img = UIImage(named: placePhotoName)
                let imgView = UIImageView(image: img)
                
                //compute image size
                let divider:Double = Double(max(imgView.frame.width, imgView.frame.height)) / 32.0
                let newWidth:Double = Double(imgView.frame.width) / divider
                let newHeight:Double = Double(imgView.frame.height) / divider
                let widthOffset:Double = (32.0 - newWidth)/2.0
                let heightOffset:Double = (32.0 - newHeight)/2.0
                imgView.frame = CGRect(x: widthOffset, y: heightOffset, width: newWidth , height: newHeight)
                annotationView!.leftCalloutAccessoryView = imgView*/
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let place = view.annotation as! PlaceAnnotation
        let placeName = place.title
        let placeInfo = place.subtitle
        
        //let ac = UIAlertController(title: "Hello", message: "I am me.", preferredStyle: .Alert)
        //ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        //presentViewController(ac, animated: true, completion: nil)
        performSegueWithIdentifier("showPhotoDetailSegue", sender: control)
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
        if signOutButton === sender {
            //delete all info
            
            
        }
        else if(segue.identifier! == "showPhotoDetailSegue") {
            
        }
    }
    
}
