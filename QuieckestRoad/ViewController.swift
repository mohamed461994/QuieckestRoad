//
//  ViewController.swift
//  QuieckestRoad
//
//  Created by Mohamed Shaban on 9/12/18.
//  Copyright © 2018 Mohammed Shaban. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var locationUILable: UILabel!
    
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        chceckLocationService()
    }

    func setUpViews() {
        
    }
    
    func setupLocationManger() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()
    }
    
    func chceckLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManger()
            
        } else {
            
        }
    }
    
    @IBAction func pickLocation(_ sender: UIButton) {
        let location = getCenterLocation(map: mapKitView)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placeMakers, err) in
            if let error = err {
                // error
            }
            let streetNumber = placeMakers?.first?.subThoroughfare ?? ""
            let streetName = placeMakers?.first?.thoroughfare ?? ""
            self.locationUILable.text = "\(streetNumber)  \(streetName)"
        }
    }
    
    func centerViewToUserLocation() {
        if let currentLocation = locationManger.location?.coordinate {
            let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapKitView.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(map: MKMapView) -> CLLocation {
        let lat = map.centerCoordinate.latitude
        let lng = map.centerCoordinate.longitude
        
        return CLLocation(latitude: lat, longitude: lng)
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // this what we want
            mapKitView.showsUserLocation = true
            centerViewToUserLocation()
            
        case .authorizedAlways:
            // we wont ask for this
            break
        case .denied:
            // give us permission
            break
        case .notDetermined:
            // ask for permision
            locationManger.requestWhenInUseAuthorization()
            break
        case .restricted:
            //
            break
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       checkLocationAuthorization()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let newLocation = locations.last else {return}
//        let region = MKCoordinateRegion(center: newLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//        mapKitView.setRegion(region, animated: true)
//    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = getCenterLocation(map: mapView)
        locationUILable.text = "lat: " + String(location.coordinate.latitude)
    }
}
