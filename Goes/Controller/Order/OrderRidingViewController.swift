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
import Lottie

class OrderRidingViewController: UIViewController {
    
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
   
    private let locationManager = CLLocationManager()
    
    var orderMyRequestVC: OrderMyRequestViewController?
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var order: OrderDetail?
    var rider: MyProfile?
    var driverFirstLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        let rPosition = CLLocationCoordinate2D(latitude: (order?.selectedLat)!, longitude: (order?.selectedLng)!)
        let rMarker = GMSMarker(position: rPosition)
        rMarker.icon = UIImage(named: "Images_60x_Rider_Normal")
        rMarker.map = self.mapView
        
        self.fireBaseManager.listenDriverLocation(orderID: (self.order?.orderID)!) { (order) in

            self.order = order
            self.mapView.clear()
            
            let position = CLLocationCoordinate2D(latitude: (order?.driverLat)!, longitude: (order?.driverLag)!)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "Images_60x_Driver_Normal")
            marker.map = self.mapView
            
            let rPosition = CLLocationCoordinate2D(latitude: (order?.selectedLat)!, longitude: (order?.selectedLng)!)
            let rMarker = GMSMarker(position: rPosition)
            rMarker.icon = UIImage(named: "Images_60x_Rider_Normal")
            rMarker.map = self.mapView

            if self.driverFirstLocation == nil {

                self.driverFirstLocation = CLLocationCoordinate2D(latitude: (order?.driverLat)!, longitude: (order?.driverLag)!)

                var region = GMSVisibleRegion()

                region.nearLeft = CLLocationCoordinate2DMake((self.order?.selectedLat)!, (self.order?.selectedLng)!)

                region.farRight = self.driverFirstLocation!

                let bounds = GMSCoordinateBounds(coordinate: region.nearLeft,coordinate: region.farRight)
                let camera = self.mapView.camera(for: bounds, insets:UIEdgeInsets(top: 100, left: 16, bottom: 100, right: 16))

                self.mapView.camera = camera!

            }
            
        }
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
    
        self.view.addGestureRecognizer(longPress)
       
    }
    

    @objc func longPressAction(_ sender: UIGestureRecognizer) {
        
        let animationView = LOTAnimationView(name: "5184-success")
        animationView.frame = CGRect(x: 0, y: 0, width: successImageView.frame.width, height:  successImageView.frame.height)
        animationView.contentMode = .scaleAspectFit
        
        animationView.animationSpeed = 2
        self.successImageView.addSubview(animationView)
        if sender.state == .ended {
           animationView.stop()
            print("ok")
        }
        
        
        if sender.state == .began {
           animationView.play()
           
            
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
        
        if let driverLat = order?.driverLat, let driverLag = order?.driverLag {
            
            var region = GMSVisibleRegion()
            
            region.nearLeft = CLLocationCoordinate2DMake((self.order?.selectedLat)!, (self.order?.selectedLng)!)
            
            region.farRight = CLLocationCoordinate2DMake(driverLat, driverLag)
            
            let bounds = GMSCoordinateBounds(coordinate: region.nearLeft,coordinate: region.farRight)
            
            let camera = self.mapView.camera(for: bounds, insets:UIEdgeInsets(top: 100, left: 16, bottom: 100, right: 16))
            
            self.mapView.camera = camera!
        } else {
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        
    }

}

extension OrderRidingViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 16)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
}
