//
//  BaseMapViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/6/3.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import CoreLocation

class BaseMapViewController: UIViewController {
    
    var myProfile: MyProfile?
    
    var order: OrderDetail?
    
    var driver: MyProfile?
    
    @IBOutlet weak var orderRrivingView: OrderRidingView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        orderRrivingView.mapView.delegate = self
        orderRrivingView.mapView.isMyLocationEnabled = true
        
    }

}

extension BaseMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}

extension BaseMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
