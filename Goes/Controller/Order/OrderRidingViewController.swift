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
    @IBOutlet weak var estimateArrivingTime: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var greenView: UIView! {
        didSet{
            greenView.roundCorners(20)
        }
    }
    
    private let locationManager = CLLocationManager()
    
    var orderMyRequestVC: OrderMyRequestViewController?
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var order: OrderDetail?
    var driver: MyProfile?
    var driverFirstLocation: CLLocationCoordinate2D?
    var completeTime: Int?
    
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
        
        locationLabel.text = order?.locationFormattedAddress
        
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
                
                guard let driverFirstLocation = self.driverFirstLocation else { return }

                var region = GMSVisibleRegion()

                region.nearLeft = CLLocationCoordinate2DMake((self.order?.selectedLat)!, (self.order?.selectedLng)!)

                region.farRight = driverFirstLocation

                let bounds = GMSCoordinateBounds(coordinate: region.nearLeft,coordinate: region.farRight)
                
                guard let camera = self.mapView.camera(for: bounds, insets:UIEdgeInsets(top: 50, left: 100, bottom: 50, right: 100)) else { return }
                
                self.getArrivingTime(location: driverFirstLocation)

                self.mapView.camera = camera

            }
            
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
    
        self.view.addGestureRecognizer(longPress)
       
    }
    
    func getArrivingTime(location: CLLocationCoordinate2D) {
        
        guard let order = self.order else { return }
        
        let origin = "\(order.selectedLat),\(order.selectedLng)"
        let destination = "\(location.latitude),\(location.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
        Alamofire.request(url).responseJSON { response in
            
            do {
                
                let json = try JSON(data: response.data!)
                let timeValue = json["routes"][0]["legs"][0]["duration"]["value"].rawValue as? Int
                if timeValue != nil {
                    
                    let current = Int(Date().timeIntervalSince1970) + timeValue!
                    let dformatter = DateFormatter()
                    let date = Date(timeIntervalSince1970: TimeInterval(current))
                    dformatter.dateFormat = "HH:mm"
                    self.estimateArrivingTime.text = dformatter.string(from: date)
                    
                } else {
                    self.estimateArrivingTime.text = " -- : -- "
                }
                
            } catch {
                print("ERROR: not working")
            }
        }
        
        
    }
    
    func nowTimeStamp() {
        let now = Date()
        self.completeTime = Int(now.timeIntervalSince1970)
        
    }
    @IBAction func callBtn(_ sender: Any) {
        guard let riderPhone = driver?.phoneNumber else {
            return
        }
        guard let number = URL(string: "tel://" + "\(riderPhone)") else {
            return
        }
        UIApplication.shared.open(number)
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
            nowTimeStamp()
           
            self.fireBaseManager.orderComplete(
                myUid: self.myProfile?.userID ?? "" ,
                friendUid: self.driver?.userID ?? "",
                orderID: self.order?.orderID ?? "",
                completeTime: self.completeTime ?? 0,
                completionHandler: {
                
                    print("driver arrive")
                
                })
            
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
        
//        if let driverLat = order?.driverLat, let driverLag = order?.driverLag {
//
//            var region = GMSVisibleRegion()
//
//            region.nearLeft = CLLocationCoordinate2DMake((self.order?.selectedLat)!, (self.order?.selectedLng)!)
//
//            region.farRight = CLLocationCoordinate2DMake(driverLat, driverLag)
//
//            let bounds = GMSCoordinateBounds(coordinate: region.nearLeft,coordinate: region.farRight)
//
//            let camera = self.mapView.camera(for: bounds, insets:UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100))
//
//            self.mapView.camera = camera!
//        } else {
        
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//        }
        
    }

}

extension OrderRidingViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
}
