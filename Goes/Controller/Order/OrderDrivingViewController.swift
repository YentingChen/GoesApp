//
//  OrderDrivingViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/22.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class OrderDrivingViewController: MapViewController {
    
    var timer: Timer?

    var orderRequestVC: OrderRequestViewController?
    
    var updateLat: Double?
    
    var updateLag: Double?
    
    var startDrivingTime: Int?
    
    var driverStartLocation: CLLocationCoordinate2D?
    
    var isSettingOff = false
    
    var firstLocation: CLLocationCoordinate2D?
    
    var secondStartLocation: CLLocationCoordinate2D?
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let isSetOff = order?.setOff, isSetOff == 1 {
            
            orderDrivingView.grayView.isHidden = true
            
            self.isSettingOff = true
            
            locationManager.startUpdatingLocation()
            
        } else {
            
            orderDrivingView.grayView.isHidden = false
            
            self.isSettingOff = false
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        orderDrivingView.delegate = self
        
        guard let rider = self.rider else { return }
        
        if rider.avatar != "" {
            
            orderDrivingView.showAvatar(url: rider.avatar)
        }
        
        checkLocationAuth()
        
        if isSettingOff {
            
            if UIApplication.shared.applicationState != .active {
                
                if isSettingOff {
                    
                    updateDriverLocation()
                }
            }
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        orderDrivingView.arrivingAddressLabel.text = self.order?.locationFormattedAddress
        
        orderDrivingView.riderName.text = self.rider?.userName
        
        updateDriverLocation()
        
        FireBaseManager.share.listenDriverLocation(orderID: (self.order?.orderID)!) { (order) in
            
            if let order = order, order.setOff == 2 {
                
                self.timer?.invalidate()
                
                AlertManager.share.showAlert(
                    
                    title: "接送成功",
                    message: "您已成功接到對方",
                    viewController: self, typeOfAction: 1, okHandler: {
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        self.dismiss(animated: true, completion: nil)
                        
                }, cancelHandler: nil)
                
            }
        }
    }
    
    fileprivate func pushNotificationAction(_ friendFcmToken: String, _ myself: MyProfile) {
        
        let sender = PushNotificationSender()
        
        sender.sendPushNotification(
            to: friendFcmToken,
            title: Title.driverSetOff.rawValue,
            body: "\(myself.userName)\(NotificationMessage.driverSetOff.rawValue)")
    }
    
    fileprivate func startDriveSetting() {
        
        guard let order = self.order else { return }
        
        let destination = Point(x: order.selectedLat, y: order.selectedLng)
        
        orderDrivingView.grayView.isHidden = true
        
        self.isSettingOff = true
        
        locationManager.startUpdatingLocation()
        
        self.startDrivingTime = nowTimeStamp()
        
        orderDrivingView.mapView.clear()
        
        GoogleMapManager.share.setRiderMarker(position: destination, viewController: self)
    }
    
    @IBAction func startDriving(_ sender: Any) {
        
        startDriveSetting()
        
        guard let myUid = self.myProfile?.userID,
            let friendUid = self.rider?.userID,
            let orderID = self.order?.orderID,
            let friendFcmToken = self.rider?.fcmToken,
            let myself = self.myProfile else { return }
        
        pushNotificationAction(friendFcmToken, myself)
        
        FireBaseManager.share.orderSetOff(
            
        myUid: myUid,
        
        friendUid: friendUid,
        
        orderID: orderID,
        
        driverStartAt: self.startDrivingTime!,
        
        startLat: Double((driverStartLocation?.latitude)!),
        
        startLag: Double((driverStartLocation?.longitude)!)) {
            
            self.updateLat = self.driverStartLocation?.latitude
            
            self.updateLag = self.driverStartLocation?.longitude
            
            if self.updateLat != nil, self.updateLag != nil {
                
                FireBaseManager.share.updateDriverLocation(
                    
                    orderID: (self.order?.orderID)!,
                    
                    lat: self.updateLat!,
                    
                    lag: self.updateLag!)
                
            }
        }
        
    }
    
    func nowTimeStamp() -> Int {
        
        let now = Date()
        
        return Int(now.timeIntervalSince1970)

    }
    
    fileprivate func updatePositionToDB() {
        
        if self.updateLat != nil, self.updateLag != nil {
            
            FireBaseManager.share.updateDriverLocation(
                orderID: (self.order?.orderID)!,
                lat: self.updateLat!,
                lag: self.updateLag!)
            
        }
    }
    
    func updateDriverLocation() {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (_) in
            
            if self.updateLat != nil, self.updateLag != nil {
                
                let origin = CLLocationCoordinate2D(latitude: self.updateLat!, longitude: self.updateLag!)
                
                self.getTime(location: origin)
                
               FireBaseManager.share.updateDriverLocation(
                    orderID: (self.order?.orderID)!,
                    lat: self.updateLat!,
                    lag: self.updateLag!)
                
            }
        })
    }
    
    func setCamera(origin: Point) {
        
        guard let order = self.order else { return }
        
        let edgeInsets = UIEdgeInsets(top: 50, left: 100, bottom: 50, right: 100)
    
        let destination = Point(x: order.selectedLat, y: order.selectedLng)
    
        GoogleMapManager.share.setCamera(
            origin: origin,
            destination: destination,
            insets: edgeInsets,
            viewController: self)
    }
    
    func getTime(location: CLLocationCoordinate2D) {
        
        guard let order = self.order else { return }
        
        let origin = Point(x: location.latitude, y: location.longitude)
        
        let destination = Point(x: order.selectedLat, y: order.selectedLng)
        
        let url = "\(URL.googleMapDirection(origin: origin, destination: destination))"
        
        GoogleMapManager.share.getEstmatedTime(url: url, viewController: self) { (showTime) in
            self.orderDrivingView.estimatedTime.text = showTime
        }
    
    }

    func drawPath(location: CLLocationCoordinate2D) {
        
        guard let order = self.order else { return }
        
        let destination = Point(x: order.selectedLat, y: order.selectedLng)
        
        let origin = Point(x: location.latitude, y: location.longitude)
        
        GoogleMapManager.share.setRiderMarker(position: destination, viewController: self)
        
        let url = "\(URL.googleMapDirection(origin: origin, destination: destination))"
        
        GoogleMapManager.share.drawPath(url: url, viewController: self)
        
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        guard let order = self.order else { return }
        
        let destination = Point(x: order.selectedLat, y: order.selectedLng)
        
        if isSettingOff {
            
            orderDrivingView.mapView.clear()
        
            GoogleMapManager.share.setRiderMarker(position: destination, viewController: self)
            
            if order.driverStartLat == 0.0, order.driverStartLag == 0.0 {
                
                if self.driverStartLocation == nil {
                    
                    self.driverStartLocation = location.coordinate
                    
                    guard let driverStartLocation = self.driverStartLocation else { return }
                    
                    let origin = Point(x: driverStartLocation.latitude, y: driverStartLocation.longitude)
                    
                    setCamera(origin: origin)
                    
                }
                
            }
            
            if self.driverStartLocation != nil {
                
                self.updateLat = Double(location.coordinate.latitude)
                
                self.updateLag = Double(location.coordinate.longitude)
                
            } else {
                
                if self.secondStartLocation == nil {
                    
                    self.secondStartLocation = location.coordinate
                    
                    guard let secondStartLocation = self.secondStartLocation else {
                        return
                    }
                    
                    let origin = Point(x: secondStartLocation.latitude, y: secondStartLocation.longitude)
                    
                    setCamera(origin: origin)
                    
                    getTime(location: self.secondStartLocation!)
                    
                }
                
            }
            
            self.updateLat = Double(location.coordinate.latitude)
            
            self.updateLag = Double(location.coordinate.longitude)
            
        } else {
            
            if firstLocation == nil {
                
                self.firstLocation = location.coordinate
                
                guard let origin = self.firstLocation else { return }
                
                let originPoint = Point(x: origin.latitude, y: origin.longitude)
                
                setCamera(origin: originPoint)
                
                drawPath(location: location.coordinate)
                
                getTime(location: location.coordinate)
                
            }
            
            self.driverStartLocation = location.coordinate
        }
    }

}

extension OrderDrivingViewController: OrderDrivingViewDelegate {
    
    func setOffAction(_ view: OrderDrivingView, didTapButton button: UIButton) {
        
        self.isSettingOff = true
        
    }
    
    func callAction(_ view: OrderDrivingView, didTapButton button: UIButton) {
        
        guard let riderPhone = rider?.phoneNumber else { return }
        
        guard let number = URL.callPhone(phoneNumber: riderPhone) else { return }
        
        UIApplication.shared.open(number)
        
    }
    
}
