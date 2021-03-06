//
//  MapViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/9.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var orderDrivingView: OrderDrivingView!
    
    
    var order: OrderDetail?
    
    var rider: MyProfile?
    
    var myProfile: MyProfile?
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self

    }
    
    func checkLocationAuth() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
        case .restricted, .denied, .authorizedWhenInUse:
            // Disable location features
            AlertManager.share.showAlert(
                title: "請先設定位置權限",
                message: "前往 設定/隱私權/定位服務/允許取用位置，選取 “永遠”，否則將無法使用該功能 ",
                viewController: self,
                typeOfAction: 1,
                okHandler: {
                    ToSettingPageManager.share.toSettingPage()
                    self.navigationController?.popViewController(animated: false)
            },
                cancelHandler: nil)
            
        case .authorizedAlways:
            return
        }
    
    }

}
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedAlways else {
            checkLocationAuth()
            return
        }
        
        locationManager.startUpdatingLocation()
        
        orderDrivingView.mapView.isMyLocationEnabled = true
        
        orderDrivingView.mapView.settings.myLocationButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
}
