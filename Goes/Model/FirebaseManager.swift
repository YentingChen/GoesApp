//
//  FirebaseManager.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/16.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

struct YTUser {
    var id: String?
    var email: String?
    
}

class FireAuthManager: NSObject {
    
    static let share = FireAuthManager()
    
    private override init() {}
    
    let auth = Auth.auth()
    
    var addStateListener: AuthStateDidChangeListenerHandle?
    
    func addSignUpListener(listener: @escaping (Bool, User?) -> Void) {
        
       addStateListener = auth.addStateDidChangeListener { (_, user) in
            
            guard user != nil else {
                listener(false, nil)
                return
            }
            
            listener(true, user)
        }
    }
    
    func deleteListener() {
        
        if let listener = addStateListener {
            auth.removeStateDidChangeListener(listener)
            auth.removeStateDidChangeListener(listener)
            auth.removeStateDidChangeListener(listener)
            auth.removeStateDidChangeListener(listener)
            auth.removeStateDidChangeListener(listener)
        }
        
    }
    
    
    func getCurrentUser() -> YTUser? {
       let user = Auth.auth().currentUser
        
       var ytUser = YTUser()
        
       ytUser.email = user?.email
        ytUser.id = user?.uid
        
        return ytUser
    }
}

class FireBaseManager {
    
    var db = Firestore.firestore()
    var userProfile: MyProfile?
    var userOrder: OrderDetail?
    var address: Address?
   
    func queryUsers(email: String, completionHandler: @escaping (Bool, String) -> Void) {
        
        var isMember = false
        var friendUid : String?
        
        db.collection("users").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        guard let fireEmail = document.data()["email"] else { return }
                            if  email == fireEmail as? String {
                                friendUid = document.data()["userID"] as? String
                                isMember = true
                                break
                            } else {
                                isMember = false
                                
                        }
                               
                    }
                completionHandler(isMember, friendUid ?? "")
                
                
                }
                
            }
        }
    
    func queryFriendStatus(friendUid: String, myUid: String, completionHandler: @escaping (Int) -> Void) {
        db.collection("users").document(myUid).collection("friend").document(friendUid).getDocument { [weak self]  (document, err) in
            
            if document?.data() != nil {
                
                let status = document?.data()!["status"] as? Int
                guard let friendStatus = status else { return }
                completionHandler(friendStatus)
                
            } else {
                
                completionHandler(0)

            }
        }
    }
    
    func makeFriend(friendUid: String, myUid: String){
        db.collection("users").document(myUid).collection("friend").document(friendUid).setData(["status":1])
        db.collection("users").document(friendUid).collection("friend").document(myUid).setData(["status":2])
        
    }
    
    typealias CompletionHandler = (MyProfile?) -> Void
    
    func queryUserInfo(userID: String, completion: @escaping CompletionHandler) {
        
        let userProfile =  db.collection("users").document(userID)
        userProfile.getDocument { (document, error) in
            
            if let profile = document.flatMap({ $0.data().flatMap({ (data) in
                return Profile(dictionary: data)
            })
            }) {
                self.userProfile = MyProfile(
                    email: profile.email,
                    userID: profile.userID,
                    userName: profile.userName,
                    phoneNumber: profile.phoneNumber,
                    avatar: profile.avatar,
                    fcmToken: profile.fcmToken)
                
                print("Profile: \(profile)")
                
            completion(self.userProfile)
                
            } else {
                print("Document does not exist")
            }
            
        }
    }
    
    let group2 = DispatchGroup()
    
    func querymyFriends(myUid: String, status: Int , completionHandler: @escaping ([MyProfile]?) -> Void) {
        var friendList = [MyProfile]()
        db.collection("users").document(myUid).collection("friend").getDocuments
            { [weak self]  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if querySnapshot!.documents.count == 0 {
                        completionHandler(nil)
                        return
                    }
                    
                    
                    for document in querySnapshot!.documents {
                        if let fireStatus = document.data()["status"] as? Int {
                            
                            if  fireStatus == status {
                                
                                self?.group2.enter()
                                
                                self?.queryUserInfo(userID: document.documentID, completion: { (friendInfo) in
                                    friendList.append(friendInfo!)
                                    self?.group2.leave()
                                })
                              
                            }
                        }
                    }
                    
                    self?.group2.notify(queue: .main, execute: {
                        completionHandler(friendList)
                    })
                    
                    
                }
        }
    }
    
    func deleteFriend(myUid: String, friendUid: String, completionHandler: @escaping () -> Void ) {
        db.collection("users").document(myUid).collection("friend").document(friendUid).delete()
        db.collection("users").document(friendUid).collection("friend").document(myUid).delete()
        completionHandler()
    }
    
    func becomeFriend(myUid: String, friendUid: String, completionHandler: @escaping () -> Void ) {
        db.collection("users").document(myUid).collection("friend").document(friendUid).updateData(["status":3])
        db.collection("users").document(friendUid).collection("friend").document(myUid).updateData(["status":3])
        
        completionHandler()

    }
    
    func updateAvatar(myUid: String, avatarUrl: String) {
        db.collection("users").document(myUid).updateData(["avatar": avatarUrl])
    }
    
    func updateAdress(myUid: String,
                      category: String,
                      placeName: String,
                      placeLng: Double,
                      placeLat: Double,
                      placeID: String,
                      placeformattedAddress: String,
                      completionHandler: @escaping () -> Void) {
        db.collection("users").document(myUid).collection("address").document(category).setData([
            "placeName": placeName,
            "placeLat": placeLat,
            "placeLng": placeLng,
            "placeID": placeID,
            "placeformattedAddress": placeformattedAddress])
    }
    
    func queryAdress(myUid: String, category: String, completionHandler: @escaping (Address?) -> Void) {
        db.collection("users").document(myUid).collection("address").document(category).getDocument { [weak self]  (document, err) in
            
            if document?.data() != nil {
                if let addressInfo = document.flatMap({ $0.data().flatMap({ (data) in
                    return AddressFromDB(dictionary: data)
                })
                }) {
                    self?.address = Address(
                        placeID: addressInfo.placeID,
                        placeLat: addressInfo.placeLat,
                        placeLng: addressInfo.placeLng,
                        placeName: addressInfo.placeName,
                        placeformattedAddress: addressInfo.placeformattedAddress
                    )
                    completionHandler(self?.address)
                    
                } else {
                    print("Document does not exist")
                }
                
            } else {
                return
            }
            
        }
    }
    
    func upLoadOrder(
        orderID: String,
        selectedTime: DateAndTime,
        selectedFriend: MyProfile,
        selectedLocation: Address ,
        myInfo: MyProfile,
        completionHandler: @escaping ()
    -> Void) {
    db.collection("users").document(myInfo.userID).collection("orders").document(orderID).setData(["status":1])
        
    db.collection("users").document(selectedFriend.userID).collection("orders").document(orderID).setData(["status":2])
      
        db.collection("orders").document(orderID).setData([
            "driverUid": selectedFriend.userID,
            "order_ID": orderID,
            "riderUid": myInfo.userID,
            "location_formattedAddress": selectedLocation.placeformattedAddress,
            "selected_location_lat": selectedLocation.placeLat,
            "selected_location_lng": selectedLocation.placeLng,
            "selected_location_name": selectedLocation.placeName,
            "selected_location_placeID": selectedLocation.placeID,
            "selected_time_date": selectedTime.date,
            "selected_time_year": selectedTime.year,
            "selected_time_month": selectedTime.month,
            "selected_time_day": selectedTime.day,
            "selected_time_time": selectedTime.time])
        
        completionHandler()
        
    }
    
    let group = DispatchGroup()
    
    func queryMyOrders(myUid: String, status: Int, completionHandler: @escaping ([OrderDetail]) -> Void) {
        
        var myOrders = [OrderDetail]()
        
        db.collection("users").document(myUid).collection("orders").getDocuments { [weak self]  (querySnapshot, err) in
            
            if querySnapshot!.documents.count == 0 {
                completionHandler([])
                return
            }
            
            for document in querySnapshot!.documents {
                
                if let fireStatus = document.data()["status"] as? Int {
                    
                    if fireStatus == status {
                    
                        self?.group.enter()
                        
                        self?.queryOrderDetail(
                        
                            orderID: document.documentID,
                            
                            completionHandler: { (orderDetail) in
                                
                                myOrders.append(orderDetail!)
                                
                                self?.group.leave()
                                
                        })
                    }
                }
                
            }
            
            self?.group.notify(queue: .main, execute: {
                
                completionHandler(myOrders)
            })
        }
    }
    
    func queryOrderDetail(orderID: String, completionHandler: @escaping (OrderDetail?) -> Void) {
        
        let docRef = db.collection("orders").document(orderID)
        
        docRef.getDocument { [weak self]  (document, error) in
            if let order = document.flatMap({
                $0.data().flatMap({ (data) in
                    return OrderFromDB(dictionary: data)
                })
            }) {
                self?.userOrder = OrderDetail(
                    driverUid: order.driverUid,
                    riderUid: order.riderUid,
                    locationFormattedAddress: order.locationFormattedAddress,
                    selectedLat: order.selectedLat,
                    selectedLng: order.selectedLng,
                    locationName: order.locationName,
                    locationPlaceID: order.locationPlaceID,
                    selectTimeDate: order.selectTimeDate,
                    selectTimeDay: order.selectTimeDay,
                    selectTimeYear: order.selectTimeYear,
                    selectTimeMonth: order.selectTimeMonth,
                    selectTimeTime: order.selectTimeTime,
                    orderID: order.orderID,
                    driverLat: order.driverLat,
                    driverLag: order.driverLag,
                    riderLat: order.riderLat,
                    riderLag: order.riderLag,
                    setOff: order.setOff,
                    driverStartLat: order.driverStartLat,
                    driverStartLag: order.driverStartLag,
                    driverStartTime: order.driverStartTime,
                    completeTime: order.completeTime)
                
                completionHandler(self?.userOrder)
                
            } else {
                print("Document does not exist")
            }
        }

    }
    
    func orderDeal(myUid: String, friendUid: String, orderID: String, completionHandler: @escaping () -> Void ) {
        db.collection("users").document(myUid).collection("orders").document(orderID).updateData(["status": 3])
        db.collection("users").document(friendUid).collection("orders").document(orderID).updateData(["status": 4])
        
        completionHandler()
        
    }
    
    func orderSetOff(myUid: String,
                     friendUid: String,
                     orderID: String,
                     driverStartAt:Int,
                     startLat: Double,
                     startLag: Double,
                     completionHandler: @escaping ()
        -> Void ) {
        
    db.collection("users").document(myUid).collection("orders").document(orderID).updateData(["status": 6])
    db.collection("users").document(friendUid).collection("orders").document(orderID).updateData(["status": 5])
        
        db.collection("orders").document(orderID).updateData(["setOff": 1])
        
        db.collection("orders").document(orderID).updateData(["driver_start_time": driverStartAt])
        
        db.collection("orders").document(orderID).updateData(["driver_start_Lat":startLat, "driver_start_lag": startLag])
        db.collection("orders").document(orderID).updateData(["driverLat":startLat, "driverLag": startLag])
        
    }
    
    func orderCancel(myUid: String, friendUid: String, orderID: String, completionHandler: @escaping () -> Void ) {
        db.collection("users").document(myUid).collection("orders").document(orderID).updateData(["status": 0])
        db.collection("users").document(friendUid).collection("orders").document(orderID).updateData(["status": 0])
        
        completionHandler()
    }
    
    func orderComplete(myUid: String, friendUid: String, orderID: String, completeTime: Int, completionHandler: @escaping () -> Void) {
        
        db.collection("users").document(myUid).collection("orders").document(orderID).updateData(["status": 7])
        
        db.collection("users").document(friendUid).collection("orders").document(orderID).updateData(["status": 7])
        
        db.collection("orders").document(orderID).updateData(["setOff": 2])
        db.collection("orders").document(orderID).updateData(["complete_time": completeTime])
        
    }
    
    func updateDriverLocation(orderID: String, lat: Double, lag: Double) {
        
        db.collection("orders").document(orderID).updateData(["driverLat":lat, "driverLag": lag])
       
    }
    
    func listenDriverLocation(orderID: String,  completionHandler: @escaping (OrderDetail?) -> Void ) {
        
        db.collection("orders").document(orderID).addSnapshotListener { [weak self] documentSnapshot, error in
            
                guard let document = documentSnapshot else {
                    
                    print("Error fetching document: \(error!)")
                    return
                }
            
                guard let data = document.data() else {
                    
                    print("Document data was empty.")
                    return
                }
            
            if let order = documentSnapshot.flatMap({
                
                $0.data().flatMap({ (data) in
                    
                    return OrderFromDB(dictionary: data)
                    
                })
            }) {
                self?.userOrder = OrderDetail(
                    driverUid: order.driverUid,
                    riderUid: order.riderUid,
                    locationFormattedAddress: order.locationFormattedAddress,
                    selectedLat: order.selectedLat,
                    selectedLng: order.selectedLng,
                    locationName: order.locationName,
                    locationPlaceID: order.locationPlaceID,
                    selectTimeDate: order.selectTimeDate,
                    selectTimeDay: order.selectTimeDay,
                    selectTimeYear: order.selectTimeYear,
                    selectTimeMonth: order.selectTimeMonth,
                    selectTimeTime: order.selectTimeTime,
                    orderID: order.orderID,
                    driverLat: order.driverLat,
                    driverLag: order.driverLag,
                    riderLat: order.riderLat,
                    riderLag: order.riderLag,
                    setOff: order.setOff,
                    driverStartLat: order.driverStartLat,
                    driverStartLag: order.driverStartLag,
                    driverStartTime: order.driverStartTime,
                    completeTime: order.completeTime)
                
                completionHandler(self?.userOrder)
                
            } else {
                print("Document does not exist")
            }

        }
    }
    
}
