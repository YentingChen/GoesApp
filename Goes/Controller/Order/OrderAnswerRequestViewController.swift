//
//  OrderAnswerRequestViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/9.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class OrderAnswerRequestViewController: UIViewController, MTSlideToOpenDelegate {
    
    @IBOutlet weak var timeBackgroundView: UIView!{
        didSet {
            self.timeBackgroundView.roundCorners(20)
        }
    }
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var estimateTimeLabel: UILabel!
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var arrivingTime: UILabel!
    
    @IBOutlet weak var slideButtonView: UIView!
    
    @IBAction func toChatRoom(_ sender: Any) {
        
        let member = Member(name: myProfile!.userName, uid: myProfile!.userID)
        
        let vc = ChatViewController(user: member, order: order!)
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func callBtn(_ sender: Any) {
        
        guard let riderPhone = rider?.phoneNumber else {
            return
        }
        guard let number = URL(string: "tel://" + "\(riderPhone)") else {
            return
        }
        UIApplication.shared.open(number)
    }
    
    private let locationManager = CLLocationManager()
    var orderRequestVC: OrderRequestViewController?
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    var order: OrderDetail?
    var rider: MyProfile?
    var myLocation: CLLocationCoordinate2D?

    @IBAction func cancelOrder(_ sender: Any) {
        
        guard let friendFcmToken = self.rider?.fcmToken else { return }
        guard let myself = self.myProfile else { return }
        let sender = PushNotificationSender()
        sender.sendPushNotification(
            to: friendFcmToken,
            title: "您的請求遭到拒絕",
            body: "\(myself.userName) 不同意您的請求，或許您可以再發送一次")
        
        self.fireBaseManager.orderCancel(
        myUid: (self.myProfile?.userID)!,
        friendUid: (self.rider?.userID)!,
        orderID: (self.order?.orderID)!) {
            
            self.orderRequestVC?.myOrdersS2 = []
            self.orderRequestVC?.ridersS2 = []
            self.orderRequestVC?.myOrdersS3 = []
            self.orderRequestVC?.ridersS3 = []
            self.orderRequestVC?.myOrdersS6 = []
            self.orderRequestVC?.ridersS6 = []
            
            self.orderRequestVC?.loadViewIfNeeded()
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        let alertController = UIAlertController(title: "", message: "Done!", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Okay", style: .default) { (_) in
        
            self.fireBaseManager.orderDeal(
                myUid: self.myProfile!.userID,
                friendUid: self.rider!.userID,
                orderID: (self.order?.orderID)!,
                completionHandler: {
                
                    self.orderRequestVC?.myOrdersS2 = []
                    self.orderRequestVC?.ridersS2 = []
                    self.orderRequestVC?.myOrdersS3 = []
                    self.orderRequestVC?.ridersS3 = []
                    self.orderRequestVC?.myOrdersS6 = []
                    self.orderRequestVC?.ridersS6 = []
               
                self.navigationController?.popViewController(animated: true)
            })
            
            guard let friendFcmToken = self.rider?.fcmToken else { return }
            guard let myself = self.myProfile else { return }
            let sender = PushNotificationSender()
            sender.sendPushNotification(to: friendFcmToken, title: "您收到一則請求", body: "\(myself.userName)已經回覆您的請求")
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    lazy var slideToOpen: MTSlideToOpenView = {

        let slide = MTSlideToOpenView(
            frame: CGRect(x: 0, y: 0,
                          width: self.slideButtonView.frame.width,
                          height: self.slideButtonView.frame.height))
        
        slide.sliderViewTopDistance = 0
        
        slide.sliderCornerRadious = 20
        
        slide.thumbnailViewLeadingDistance = 10
        
        slide.thumnailImageView.backgroundColor = UIColor(red: 109/255, green: 203/255, blue: 224/255, alpha: 1.0)
        slide.draggedView.backgroundColor = UIColor(red: 109/255, green: 203/255, blue: 224/255, alpha: 1.0)

        slide.delegate = self
        slide.thumnailImageView.image = UIImage(named: "Images_24x_Arrow_Normal")
        slide.defaultLabelText = "Accept"

        slide.sliderHolderView.backgroundColor = UIColor(red: 109/255, green: 203/255, blue: 224/255, alpha: 0.3)

        return slide
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuth()
        googleMap.isMyLocationEnabled = true
        googleMap.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        self.slideButtonView.addSubview(slideToOpen)
        self.riderName.text = self.rider?.userName
        
        guard let order = self.order else { return }
        self.arrivingTime.text = produceTime(orders: order)

        self.locationAddress.text = order.locationFormattedAddress
        guard let rider = self.rider else {
            return
        }
        
        if rider.avatar != "" {
            let url = URL(string: rider.avatar)
            avatar.kf.setImage(with: url)
            avatar.roundCorners(avatar.frame.width/2)
            avatar.clipsToBounds = true
        }
        
    }
    
        func produceTime(orders:OrderDetail)
            -> String {
    
                let year = orders.selectTimeYear
                let month = { () -> String in
                    if orders.selectTimeMonth < 10 {
                        return "0\(orders.selectTimeMonth)"
                    } else {
                        return "\(orders.selectTimeMonth)"
                    }
                }()
                let day = { () -> String in
                    if orders.selectTimeDay < 10 {
                        return "0\(orders.selectTimeDay)"
                    } else {
                        return "\(orders.selectTimeDay)"
                    }
                }()
         
                let time = orders.selectTimeTime
                return "\(year)/\(month)/\(day)   \(time)"
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
            
        case .restricted, .denied:
            // Disable location features
            
            showAlert(title: "請先設定位置權限",
                      message: "前往 設定/隱私權/定位服務/允許取用位置，選取 “永遠”或是 “使用 App 期間”，否則將無法使用該功能 ") {
                        self.toSettingPage()
                        self.navigationController?.popViewController(animated: false)
            }
            
        case .authorizedWhenInUse,.authorizedAlways:
            // Enable any of your app's location features
            return
            
        }
    }
    
    func drawPath(location: CLLocationCoordinate2D) {
        
        let origin = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        let destination = CLLocationCoordinate2D(latitude: self.order!.selectedLat, longitude: self.order!.selectedLng)
        
        var region = GMSVisibleRegion()
        
        region.nearLeft = destination
        
        region.farRight = origin
        
        let bounds = GMSCoordinateBounds(
            coordinate: region.nearLeft,
            coordinate: region.farRight)
        
        guard let camera = googleMap.camera(
            for: bounds,
            insets: UIEdgeInsets(top: 50, left: 100, bottom: 50, right: 100 )) else { return }
        
        self.googleMap.camera = camera
        
        let marker = GMSMarker(position: destination)
        marker.icon = UIImage(named: "Images_60x_Rider_Normal")
        marker.map = self.googleMap
        let originCoordinate = "\(origin.latitude),\(origin.longitude)"
        let destinationCoordinate = "\(destination.latitude),\(destination.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originCoordinate)&destination=\(destinationCoordinate)&mode=driving&key=AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
        
        Alamofire.request(url).responseJSON { response in
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                let timeTxt = json["routes"][0]["legs"][0]["duration"]["text"].stringValue
                self.estimateTimeLabel.text = "開車預計: \(timeTxt)"
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.map = self.googleMap
                    polyline.strokeColor = #colorLiteral(red: 0.6, green: 0.1960784314, blue: 0.2352941176, alpha: 1)
                    polyline.strokeWidth = 6
                }
                
            } catch {
                print("ERROR: not working")
            }
        }
        
    }

}

extension OrderAnswerRequestViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
         guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            checkLocationAuth()
            return }
        
        locationManager.startUpdatingLocation()
        
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    
        locationManager.stopUpdatingLocation()
        
        drawPath(location: location.coordinate)
        
    }
    
}

extension OrderAnswerRequestViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.googleMap.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        
        
    }
    
}
