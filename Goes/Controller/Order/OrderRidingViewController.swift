//
//  OrderRidingViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/23.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class OrderRidingViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    
    var orderMyRequestVC: OrderMyRequestViewController?
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var order: OrderDetail?
    var rider: MyProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.fireBaseManager.listenDriverLocation(orderID: (self.order?.orderID)!) { (order) in
            
            self.order = order
            
            self.mapView.isMyLocationEnabled = false
            
            let camera = GMSCameraPosition.camera(withLatitude:(order?.driverLat)!,
                                                  longitude: (order?.driverLag)!,
                                                  zoom: 16)
            let mapView = self.mapView
            mapView!.clear()
            let position = CLLocationCoordinate2D(latitude: (order?.driverLat)!, longitude: (order?.driverLag)!)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "Images_60x_Driver_Normal")
            marker.map = self.mapView
//            let driverLocation = GMSCameraPosition.camera(withLatitude: (self.order?.driverLat)!,longitude: (self.order?.driverLag)!,zoom: 15)
//            mapView!.camera = driverLocation
            
        }
        
    }
    
}

extension OrderRidingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else { return }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        var region:GMSVisibleRegion = GMSVisibleRegion()
        region.nearLeft = CLLocationCoordinate2DMake((self.order?.selectedLat)!, (self.order?.selectedLng)!)
        region.farRight = CLLocationCoordinate2DMake(self.order!.driverLat,self.order!.driverLag)
        let bounds = GMSCoordinateBounds(coordinate: region.nearLeft,coordinate: region.farRight)
        let camera = mapView.camera(for: bounds, insets:UIEdgeInsets.zero)
        mapView.camera = camera!
//        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
    }

}

extension OrderRidingViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
}
