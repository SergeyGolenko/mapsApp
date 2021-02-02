//
//  ViewController.swift
//  mapsApp
//
//  Created by Сергей Голенко on 01.02.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    fileprivate let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = CLLocationAccuracy(90)
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = true
        
    }


}


extension ViewController : CLLocationManagerDelegate {
    
    
}


extension ViewController : MKMapViewDelegate {
    
    
}
