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

class MapViewController: UIViewController {
    
    var order: OrderDetail?
    
    var rider: MyProfile?
    
    var myProfile: MyProfile?
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var riderName: UILabel!
    
    @IBOutlet weak var estimateTime: UILabel!

    @IBOutlet weak var arrivingAddress: UILabel!
    
    @IBOutlet weak var timeBackgroundView: UIView! {
        
        didSet {
            
            timeBackgroundView.roundCorners(25)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        
        self.mapView.isMyLocationEnabled = true
        
        self.locationManager.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func checkLocationAuth() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied, .authorizedWhenInUse:
            // Disable location features
            
            AlertManager.share.showAlert(
                title: "請先設定位置權限",
                message: "前往 設定/隱私權/定位服務/允許取用位置，選取 “永遠”，否則將無法使用該功能 ",
                viewController: self,
                typeOfAction: 3,
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
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedAlways else {
            checkLocationAuth()
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        
        mapView.settings.myLocationButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

    }
    
}
