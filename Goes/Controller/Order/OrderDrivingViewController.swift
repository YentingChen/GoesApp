//
//  OrderDrivingViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/22.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class OrderDrivingViewController: UIViewController {
    
    var timer: Timer?
    let locationManager = CLLocationManager()
    
    var orderRequestVC: OrderRequestViewController?
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    
    var myProfile: MyProfile?
    var order: OrderDetail?
    var rider: MyProfile?
    
    var updateLat: Double?
    var updateLag: Double?
    
    var startDrivingTime: Int?
    
    var driverStartLocation: CLLocationCoordinate2D?
    
    var isSettingOff = false
    
    var firstLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var estimateTime: UILabel!
    
    @IBOutlet weak var timeBackgroundView: UIView!{
        didSet {
            timeBackgroundView.roundCorners(25)
        }
    }
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var arrivingAddress: UILabel!
    
    @IBAction func startDriving(_ sender: Any) {
        
        self.grayView.isHidden = true
        self.isSettingOff = true
        locationManager.startUpdatingLocation()
        self.mapView.clear()
        
        guard let myUid = self.myProfile?.userID else { return }
        guard let friendUid = self.rider?.userID else { return }
        guard let orderID = self.order?.orderID else { return }
        
        nowTimeStamp()
        
        self.fireBaseManager.orderSetOff(
        myUid: myUid,
        friendUid: friendUid,
        orderID: orderID, driverStartAt: self.startDrivingTime!,
        startLat: Double((driverStartLocation?.latitude)!),
        startLag: Double((driverStartLocation?.longitude)!)) {
            print("i am driving")
            print(self.updateLag, self.updateLat)
            print(self.startDrivingTime)
        }
        
    }
    
    func nowTimeStamp() {
        let now = Date()
        self.startDrivingTime = Int(now.timeIntervalSince1970)

    }
    
    fileprivate func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "確定",
            style: .default,
            handler: { (action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Goes")
                self.present(vc, animated: true, completion: nil)
        })
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.arrivingAddress.text = self.order?.locationFormattedAddress
        self.riderName.text = self.rider?.userName
        
        updateDriverLocation()
        
        self.fireBaseManager.listenDriverLocation(orderID: (self.order?.orderID)!) { (order) in
            if let order = order, order.setOff == 2 {
                
                self.timer?.invalidate()
                
                self.showAlert(title: "接送成功", message: "您已成功接到對方")
                
            }
        }
    }
    
    func produceTime(orders:[OrderDetail], number: Int)
        -> String {
            
            let year = orders[number].selectTimeYear
            let month = { () -> String in
                if orders[number].selectTimeMonth < 10 {
                    return "0\(orders[number].selectTimeMonth)"
                } else {
                    return "\(orders[number].selectTimeMonth)"
                }
            }()
            let day = orders[number].selectTimeDay
            let time = orders[number].selectTimeTime
            return "\(year)/\(month)/\(day)   \(time)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let isSetOff = order?.setOff, isSetOff == 1 {
            self.grayView.isHidden = true
            self.isSettingOff = true
            locationManager.startUpdatingLocation()

        } else {
            self.grayView.isHidden = false
            self.isSettingOff = false
        }

    }
    
    func updateDriverLocation() {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            
            if self.updateLat != nil, self.updateLag != nil{
               
                    self.fireBaseManager.updateDriverLocation(
                        orderID: (self.order?.orderID)!,
                        lat: self.updateLat!,
                        lag: self.updateLag!)
                
            }
        })
    }

}

extension OrderDrivingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var region = GMSVisibleRegion()
        guard let location = locations.first else { return }
        guard let order = self.order else { return }
        
//        self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        if isSettingOff {
            
            self.mapView.clear()
            
            let position = CLLocationCoordinate2D(latitude: order.selectedLat, longitude: order.selectedLng)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "Images_60x_Rider_Normal")
            marker.map = self.mapView
            
            if self.order?.driverStartLat == 0.0, self.order?.driverStartLag == 0.0 {
                self.driverStartLocation = location.coordinate
            }
            
            guard let driverStartLocation = self.driverStartLocation else { return }
            getArrivingTime(location: driverStartLocation)
    
            region.nearLeft = CLLocationCoordinate2DMake(order.selectedLat, order.selectedLng)
            
            region.farRight = driverStartLocation
            
            let bounds = GMSCoordinateBounds(coordinate: region.nearLeft,coordinate: region.farRight)
            
            guard let camera = self.mapView.camera(
                for: bounds,
                insets:UIEdgeInsets(
                    top: 50, left: 100 , bottom: 50,  right: 100 )) else { return }
            
            self.mapView.camera = camera

            self.updateLat = Double(location.coordinate.latitude)
            self.updateLag = Double(location.coordinate.longitude)
        
        } else {
            
            
            if firstLocation == nil {
                
                self.firstLocation = location.coordinate
                self.mapView.camera = GMSCameraPosition(
                    target: firstLocation!, zoom: 15, bearing: 0, viewingAngle: 0)
                region.nearLeft = CLLocationCoordinate2DMake(order.selectedLat, order.selectedLng)
                
                region.farRight = location.coordinate
                
                let bounds = GMSCoordinateBounds(
                    coordinate: region.nearLeft,coordinate: region.farRight)
                
                guard let camera = mapView!.camera(
                    for: bounds,
                    insets:UIEdgeInsets(top: 36, left: 18 , bottom: 100,  right: 18 )) else { return }
                
                self.mapView.camera = camera
                
                drawPath(location: location.coordinate)
                
            }
            
            self.driverStartLocation = location.coordinate
            
           
        }
        
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
                    self.estimateTime.text = dformatter.string(from: date)
                    
                } else {
                    self.estimateTime.text = " -- : -- "
                }
                
            } catch {
                print("ERROR: not working")
            }
        }

        
    }
    
    func drawPath(location: CLLocationCoordinate2D) {
        
        guard let order = self.order else { return }
        
        let position = CLLocationCoordinate2D(
            latitude: order.selectedLat, longitude: order.selectedLng)
        
        let marker = GMSMarker(position: position)
        
        marker.icon = UIImage(named: "Images_60x_Rider_Normal")
        
        marker.map = self.mapView

        let origin = "\(order.selectedLat),\(order.selectedLng)"
        let destination = "\(location.latitude),\(location.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"

        Alamofire.request(url).responseJSON { response in

            do {
                
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                let timeTxt = json["routes"][0]["legs"][0]["duration"]["text"]
                let timeValue = json["routes"][0]["legs"][0]["duration"]["value"].rawValue as? Int
                if timeValue != nil {

                    let current = Int(Date().timeIntervalSince1970) + timeValue!
                    let dformatter = DateFormatter()
                    let date = Date(timeIntervalSince1970: TimeInterval(current))
                    dformatter.dateFormat = "HH:mm"
                    self.estimateTime.text = dformatter.string(from: date)

                } else {
                    self.estimateTime.text = " -- : -- "
                }

                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.map = self.mapView
                    polyline.strokeColor = #colorLiteral(red: 0.6509803922, green: 0.1490196078, blue: 0.2235294118, alpha: 1)
                    polyline.strokeWidth = 6
                }

            } catch {
                print("ERROR: not working")
            }
        }

    }
}

extension OrderDrivingViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
   
}
