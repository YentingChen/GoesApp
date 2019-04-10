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

    @IBOutlet weak var adressTxtField: UITextField!
    @IBOutlet weak var adressSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBAction func adressModeChosen(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            adressTxtField.text = "我家"
        }
    }
   
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        present(LobbyViewController(), animated: true, completion: nil)
    }
    
    @IBAction func mylocationBtn(_ sender: Any) {
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
            let lng = self.mapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 16)
        self.mapView.animate(to: camera)
    }

    private let locationManager = CLLocationManager()

    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {

        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, _ in
            self.adressTxtField.unlock()
            guard let address = response?.firstResult(), let lines = address.lines else { return }

            self.adressTxtField.text = lines.joined(separator: "\n")

            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
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

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        locationManager.stopUpdatingLocation()
    }
}

// MARK: - GMSMapViewDelegate
extension LobbyMapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0,
                                            bottom: 85, right: 0)
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        adressTxtField.text = ""
        self.adressSegmentedControl.selectedSegmentIndex = 0
        adressTxtField.lock()
    }

}
