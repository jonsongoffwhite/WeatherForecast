//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Jonny Goff-White on 28/01/2016.
//  Copyright © 2016 Jonny Goff-White. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let NUMBER_OF_DAYS = 10
    
    //WEATHER DATA
    var data: FullData?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var coordButton: UIButton!
    
    var handler: JSONHandler?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Show user location at start.
        mapView.showsUserLocation = true
        
        
        //set up JSONHandler
        handler = JSONHandler()
        
        let london = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1275), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        handler?.setUpRequest(london, count: 10)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //maybe insert relevant map overlay
    // store of save locations
    
    func setMapLocation(latitude lat: Double, longitude long: Double) {
        var region = MKCoordinateRegion()
        region.center.latitude = lat
        region.center.longitude = long
        region.span.latitudeDelta = 0.12
        region.span.longitudeDelta = 0.12
        
        mapView.setRegion(region, animated: true)
        
        
    }
    
    func getMapLocation() -> MKCoordinateRegion {
        return mapView.region
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toCoords" {
            let dest = segue.destinationViewController as! CoordViewController
            dest.mapControl = self
            dest.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        } else if segue.identifier == "toForecast" {
            let dest = segue.destinationViewController as! WeatherTableViewContoller
            dest.data = self.data
        }
    }
    
    @IBAction func coordButtonDown(sender: AnyObject) {
        
        self.performSegueWithIdentifier("toCoords", sender: sender)
    }
    
    @IBAction func meButtonDown(sender: AnyObject) {
        var userLoc = mapView.userLocation.location?.coordinate
        setMapLocation(latitude: (userLoc?.latitude)!, longitude: (userLoc?.longitude)!)
        
    }
    
    @IBAction func forecastButtonDown(sender: AnyObject) {
        
        var dataToSend: FullData
        
        //get forecast
        handler?.setUpRequest(getMapLocation(), count: NUMBER_OF_DAYS)
        dataToSend = (handler?.parseJSON())!
        
        data = dataToSend
        
        
        
        performSegueWithIdentifier("toForecast", sender: sender)
        
    }
    
    
    
    
    
    
    

}

