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
    
    @IBOutlet weak var avatar: UIImageView!
    var orderRequestVC: OrderRequestViewController?
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager.share
    
    var myProfile: MyProfile?
    var order: OrderDetail?
    var rider: MyProfile?
    
    var updateLat: Double?
    var updateLag: Double?
    
    var startDrivingTime: Int?
    
    var driverStartLocation: CLLocationCoordinate2D?
    
    var isSettingOff = false
    
    var firstLocation: CLLocationCoordinate2D?
    var secondStartLocation: CLLocationCoordinate2D?
    
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
    
    @IBAction func callBtn(_ sender: Any) {
        guard let riderPhone = rider?.phoneNumber else {
            return
        }
        guard let number = URL(string: "tel://" + "\(riderPhone)") else {
            return
        }
        
        UIApplication.shared.open(number)
    }
    
    @IBAction func startDriving(_ sender: Any) {
        
        self.grayView.isHidden = true
        self.isSettingOff = true
        locationManager.startUpdatingLocation()
        self.mapView.clear()
        
        guard let myUid = self.myProfile?.userID else { return }
        guard let friendUid = self.rider?.userID else { return }
        guard let orderID = self.order?.orderID else { return }
        
        nowTimeStamp()
        
        guard let friendFcmToken = self.rider?.fcmToken else { return }
        guard let myself = self.myProfile else { return }
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: friendFcmToken, title: "您收到一則請求", body: "\(myself.userName)已經出發！")
        
        self.fireBaseManager.orderSetOff(
        myUid: myUid,
        friendUid: friendUid,
        orderID: orderID, driverStartAt: self.startDrivingTime!,
        startLat: Double((driverStartLocation?.latitude)!),
        startLag: Double((driverStartLocation?.longitude)!)) {
            
            self.updateLat = self.driverStartLocation?.latitude
            self.updateLag = self.driverStartLocation?.longitude
            
            if self.updateLat != nil, self.updateLag != nil {
                
                self.fireBaseManager.updateDriverLocation(
                    orderID: (self.order?.orderID)!,
                    lat: self.updateLat!,
                    lag: self.updateLag!)
                
            }
        }
        
    }
    
    func toSettingPage() {
        let url = URL(string: UIApplication.openSettingsURLString)
        if let url = url, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func showAlert(title: String, message: String, completeionHandler: @escaping () ->Void) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                
                completeionHandler()
                
            })
           
            alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkLocationAuth() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied, .authorizedWhenInUse:
            // Disable location features
            
            showAlert(title: "請先設定位置權限",
                      message: "前往 設定/隱私權/定位服務/允許取用位置，選取 “永遠”，否則將無法使用該功能 ") {
                self.toSettingPage()
                self.navigationController?.popViewController(animated: false)
            }
    
        case .authorizedAlways:
            // Enable any of your app's location features
            return

        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rider = self.rider else {
            return
        }
        
        if rider.avatar != "" {
            let url = URL(string: rider.avatar)
            avatar.kf.setImage(with: url)
            avatar.roundCorners(avatar.frame.width/2)
            avatar.clipsToBounds = true
        }
        
        checkLocationAuth()
        
        
        if isSettingOff{
            if UIApplication.shared.applicationState != .active {
                if isSettingOff {
                    updateDriverLocation()
                }
        }
        
       
            
//            print("App is backgrounded. New location is %@", CLLocation.self)
        }

        
        locationManager.allowsBackgroundLocationUpdates = true
        
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
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
            let day = { () -> String in
                if orders[number].selectTimeDay < 10 {
                    return "0\(orders[number].selectTimeDay)"
                } else {
                    return "\(orders[number].selectTimeDay)"
                }
                
            }()

            let time = orders[number].selectTimeTime
            return "\(year)/\(month)/\(day)   \(time)"
    }
    
    fileprivate func updatePositionToDB() {
        if self.updateLat != nil, self.updateLag != nil {
            
            self.fireBaseManager.updateDriverLocation(
                orderID: (self.order?.orderID)!,
                lat: self.updateLat!,
                lag: self.updateLag!)
            
        }
    }
    
    func updateDriverLocation() {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            
            if self.updateLat != nil, self.updateLag != nil {
                
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
        
        guard status == .authorizedAlways else {
            checkLocationAuth()
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
            
//            if UIApplication.shared.applicationState != .active {
//                updateDriverLocation()
//                print("App is backgrounded. New location is %@", CLLocation.self)
//            }
            
            self.mapView.clear()
            
            let position = CLLocationCoordinate2D(latitude: order.selectedLat, longitude: order.selectedLng)
            
            let marker = GMSMarker(position: position)
            
            marker.icon = UIImage(named: "Images_60x_Rider_Normal")
            
            marker.map = self.mapView
            
            if self.order?.driverStartLat == 0.0, self.order?.driverStartLag == 0.0 {
                self.driverStartLocation = location.coordinate
            }
            
            if let driverStartLocation = self.driverStartLocation {
                
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
                
                if self.secondStartLocation == nil {
                    
                    self.secondStartLocation = location.coordinate
                    
                    region.nearLeft = CLLocationCoordinate2DMake(order.selectedLat, order.selectedLng)
                    
                    region.farRight = self.secondStartLocation!
                    
                    let bounds = GMSCoordinateBounds(coordinate: region.nearLeft,coordinate: region.farRight)
                    
                    guard let camera = self.mapView.camera(
                        for: bounds,
                        insets:UIEdgeInsets(
                            top: 50, left: 100 , bottom: 50,  right: 100 )) else { return }
                    
                    self.mapView.camera = camera
                    
                    getTime(location: self.secondStartLocation!)
                    
                }
                
            }
            
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
    
    func getTime(location: CLLocationCoordinate2D){
        
        guard let order = self.order else { return }
        
        let position = CLLocationCoordinate2D(
            latitude: order.selectedLat, longitude: order.selectedLng)
        
        let destination = "\(order.selectedLat),\(order.selectedLng)"
        let origin = "\(location.latitude),\(location.longitude)"
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
