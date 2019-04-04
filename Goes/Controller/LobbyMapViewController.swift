//
//  LobbyMapViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/3.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LobbyMapViewController: UIViewController {

//    @IBOutlet weak var testtest: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pinLocationLabel: UILabel!
    
    func gotoMyLocationAction(sender: UIButton)
    {
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
            let lng = self.mapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 16)
        self.mapView.animate(to: camera)
    }
    
    private let locationManager = CLLocationManager()
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
        
            self.pinLocationLabel.text = lines.joined(separator: "\n")
      
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    @IBAction func ttt(_ sender: Any) {
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
            let lng = self.mapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 16)
        self.mapView.animate(to: camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        gotoMyLocationAction(sender: testtest)
        self.mapView.isMyLocationEnabled = true
        mapView.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
}

extension LobbyMapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
        
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
//        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        

        locationManager.stopUpdatingLocation()
    }
}

// MARK: - GMSMapViewDelegate
extension LobbyMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
       
    }
    
   
}


