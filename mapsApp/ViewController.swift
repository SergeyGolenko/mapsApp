//
//  ViewController.swift
//  mapsApp
//
//  Created by Сергей Голенко on 01.02.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var shag = 0
    
    fileprivate let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = CLLocationAccuracy(90)
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
    }


}


extension ViewController : CLLocationManagerDelegate {
    
    
}


extension ViewController : MKMapViewDelegate {
    
 
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let coordinate2d = userLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.005), longitudeDelta: CLLocationDegrees(0.005))
        mapView.setRegion(MKCoordinateRegion(center: coordinate2d, span: span), animated: true)
        print("шаг \(shag)")
        shag += 1
    }
}
