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
    
    //dictionary so identical places are not mapped twice
    var placeList = [String: [MainPost]]()
    
    //selected place
    var selectedPlace = [MainPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.placesMap.delegate = self
        self.placesMap.mapType = MKMapType.Standard
        
        let currentAccount = MasterData.sharedInstance.currentUserProfile
        let places = (currentAccount?.posts?.allObjects)! as! [MainPost]
        
        //checks if there are any places
        if places.count > 0 {
            //group identical places
            var placeKey = ""
            for place in places {
                if place.latitude != 1000 {
                    placeKey = ""
                    if place.attraction != "" {
                        placeKey = place.attraction! + " in "
                    }
                    placeKey += place.city! + ", " + place.state!
                    
                    if placeList[placeKey] == nil {
                        placeList[placeKey] = []
                    }
                    placeList[placeKey]?.append(place)
                }
            }
            
            showPlaces()
        }
        else {
            //if there aren't any places, show an error
            let alert = UIAlertController(title: "No Places", message: "You have not added any places yet.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
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
            self.placesMap.mapType = MKMapType.Standard
        }
        else if(mapTypeControl.selectedSegmentIndex == 1) {
            self.placesMap.mapType = MKMapType.Satellite
        }
    }
    
    //this puts the pins on the map
    func showPlaces() {
        let padding = 0.1
        var minLat:CLLocationDegrees = 1000
        var maxLat:CLLocationDegrees = -1000
        var minLon:CLLocationDegrees = 1000
        var maxLon:CLLocationDegrees = -1000
        
        //get map region bounds
        for (name, places) in placeList {
            if places.count > 0 {
                let place = places[0]
                if CLLocationDegrees(place.latitude!) < minLat {
                    minLat = CLLocationDegrees(place.latitude!)
                }
                if CLLocationDegrees(place.latitude!) > maxLat {
                    maxLat = CLLocationDegrees(place.latitude!)
                }
                
                if CLLocationDegrees(place.longitude!) < minLon {
                    minLon = CLLocationDegrees(place.longitude!)
                }
                if CLLocationDegrees(place.longitude!) > maxLon {
                    maxLon = CLLocationDegrees(place.longitude!)
                }
            }
        }
        
        //add padding to bounds
        minLat -= padding
        maxLat += padding
        minLon -= padding
        maxLon += padding
        
        let centerLat = (minLat + maxLat) / 2.0
        let centerLon = (minLon + maxLon) / 2.0
        
        let spanLat = maxLat - minLat
        let spanLon = maxLon - minLon
        
        //now set map bounds
        var coordinates = CLLocationCoordinate2DMake(centerLat, centerLon)
        
        let span = MKCoordinateSpanMake(spanLat, spanLon)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.placesMap.setRegion(region, animated: true)
        
        //now add the pins
        for (name, places) in placeList {
            if places.count > 0 {
                let place = places[0]
                coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(place.latitude!), CLLocationDegrees(place.longitude!))
                if place.attraction != "" {
                    let newAnnotation = PlaceAnnotation(t: place.attraction!, s: place.city! + ", " + place.state!, c: coordinates)
                    self.placesMap.addAnnotation(newAnnotation)
                }
                else {
                    let newAnnotation = PlaceAnnotation(t: place.city! + ", " + place.state!, s: "", c: coordinates)
                    self.placesMap.addAnnotation(newAnnotation)
                }
            }
        }
    }
    
    //this gets the custom map pins
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "PlaceAnnotation"
        
        if annotation.isKindOfClass(PlaceAnnotation.self) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let place = view.annotation as! PlaceAnnotation
        
        var placeName = place.title!
        if place.subtitle != "" {
            placeName += " in " + place.subtitle!
        }
        
        //this gets the place selected and goes to the next page
        selectedPlace = placeList[placeName]!
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
            //do nothing
        }
        else if(segue.identifier! == "showPhotoDetailSegue") {
            //pass the selectedPlace to the detail view
            var destinationController = segue.destinationViewController as! MyPhotosDetailViewController
            destinationController.postList = selectedPlace
        }
    }
    
}
