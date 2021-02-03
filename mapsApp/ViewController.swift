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
    @IBOutlet weak var viewButtonAddAnnotation: UIButton!
    @IBOutlet weak var viewForSegmentControll: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func tappedAddAnnotationButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter Address", message:"We need your address for geocoding", preferredStyle:.alert)
            alertController.addTextField { (tf) in}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveButton = UIAlertAction(title: "Pin Adress", style: .default) { (action) in
            if let tf = alertController.textFields?.first {
                let addressText = tf.text!
                self.geocodeAndAnnotate(text: addressText)
            }
        }
    
        alertController.addAction(cancelAction)
        alertController.addAction(saveButton)
            present(alertController, animated: true, completion: nil)
       
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = CLLocationAccuracy(90)
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        viewForSegmentControll.layer.cornerRadius = 30
        viewButtonAddAnnotation.layer.cornerRadius = 5
        configureSegmentControll()
        
    }
    
    fileprivate func geocodeAndAnnotate(text:String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(text) { (placemarks, error) in
            if error != nil {
                print("Я БЫЛ БЫ РАД ЧТО БЫ ТАКОЕ МЕСТО БЫЛО,НО ЕГО НЕТ \(error?.localizedDescription)")
            }
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            let coordinates = placemark?.location?.coordinate
            let destinationInformation = MKPlacemark(coordinate: coordinates!)
            let mapItem = MKMapItem(placemark: destinationInformation)
//            let newAnnotation = MKPointAnnotation()
//            newAnnotation.coordinate = coordinates!
//            self.mapView.addAnnotation(newAnnotation)
            
            MKMapItem.openMaps(with: [mapItem], launchOptions:nil)

        }
    }
    
   private func configureSegmentControll(){
        segmentControl.addTarget(self, action: #selector(forSegment), for:.valueChanged)
    }
   
    @objc func forSegment(){
        switch segmentControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        default:
            break
        }
    }


}


extension ViewController : CLLocationManagerDelegate {
    
    
}


extension ViewController : MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        cluster.title = String(memberAnnotations.count)
        
        return cluster
    }
    
    fileprivate func setupMapSnapshot(annotation: MKAnnotationView){
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: 200, height: 200)
        options.mapType = .hybridFlyover
        let center = annotation.annotation?.coordinate ?? CLLocationCoordinate2D(latitude: 20, longitude: 20)
        options.camera = MKMapCamera(lookingAtCenter: center, fromDistance: 150, pitch: 60, heading: 0)
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { (snapshot, error) in
            if error != nil {
                print("error")
            }
            
            if let snapshot = snapshot {
                  let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                imageView.image = snapshot.image
                annotation.detailCalloutAccessoryView = imageView
                
            }
            
        }
    }
 
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let coordinate2d = userLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.005), longitudeDelta: CLLocationDegrees(0.005))
        mapView.setRegion(MKCoordinateRegion(center: coordinate2d, span: span), animated: true)
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate2d
        mapView.addAnnotation(pointAnnotation)
        print("шаг \(shag)")
        shag += 1
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {return nil}
        
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        marker.glyphText = "Coffee"
        marker.canShowCallout = true
        marker.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "chevron"))
        marker.rightCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        marker.clusteringIdentifier = "coffee"
        setupMapSnapshot(annotation:marker )
         
        return marker
    }
}
