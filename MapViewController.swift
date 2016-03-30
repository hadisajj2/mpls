//
//  MapViewController.swift
//  FindMe
//
//  Created by AnGie on 2/10/16.
//  Copyright © 2016 AnGie. All rights reserved.
//
/* View Controller that acts as main screen, presenting user's current location & accumulated path */

import UIKit
import MapKit
import CoreLocation

var myLocations: [CLLocation] = []
var myAddresses: [String] = []

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mymap: MKMapView!
 //  @IBOutlet weak var mylabel: UILabel!
  //  @IBOutlet weak var Menu: UIBarButtonItem!
    var manager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Location Manager:
        
        //Menu.target = self.revealViewController()
        ///Menu.action = Selector("revealToggle:")
       // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let userTrackingButton = MKUserTrackingBarButtonItem(mapView: self.mymap)
        self.navigationItem.rightBarButtonItem = userTrackingButton
        
        self.initializeLocationTracking()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        let isUserLoggedIn = prefs.boolForKey("isUserLoggedIn")
//        
//        if(!isUserLoggedIn){
//            self.performSegueWithIdentifier("loginView", sender: self)
//        }
//        else {
//           // username = prefs.valueForKey("username") as! NSString as String
//            
//        }
    }
    
    private func initializeLocationTracking(){
        manager = CLLocationManager()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()  // want location data even when app running in the background
        self.manager.desiredAccuracy = kCLLocationAccuracyBest // constantly updates w/GPS location updates
        self.manager.distanceFilter = 10.0 // limit updates to only occuring if change in location exceeds 10 meters
        // alternatively use ~ func startMonitoringSignificantLocationChanges when running in background
        self.manager.startUpdatingLocation()
        
        // Set up Map View
        
        mymap.delegate = self
        mymap.mapType = MKMapType.Standard
        mymap.showsUserLocation = true
        mymap.setUserTrackingMode(MKUserTrackingMode.Follow, animated: false)
        mymap.scrollEnabled = false
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // mylabel.text = "\(locations[0])"
        myLocations.append(locations[0])
        let this_location: CLLocationCoordinate2D = locations[0].coordinate
        getAddress(this_location.latitude, longitude: this_location.longitude) {
            (answer: String?) -> Void in myAddresses.append(answer!)
        }
        
        let spanX = 0.2
        let spanY = 0.2
        
        let newRegion = MKCoordinateRegion(center: mymap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mymap.setRegion(newRegion, animated: true)
        
        if(myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            mymap.addOverlay(polyline)
        }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline{
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAddress(latitude: Double, longitude: Double, completion: (answer: String?) -> Void){
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(coordinates, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                completion(answer: "")
            }
            else if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                var addressString: String = ""
                if pm.subThoroughfare != nil {
                    addressString = pm.subThoroughfare!
                }
                if pm.thoroughfare != nil {
                    addressString += " " + pm.thoroughfare!
                }
                if pm.locality != nil {
                    addressString += ", " + pm.locality!
                }
                if pm.administrativeArea != nil {
                    addressString += ", " + pm.administrativeArea!
                }
                
                if pm.postalCode != nil {
                    addressString += " " + pm.postalCode!
                }
                
                completion(answer: addressString)
            }
            else{
                completion(answer: "Location TBD")
            }
        })
    }
    
}