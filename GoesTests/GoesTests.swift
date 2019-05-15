//
//  GoesTests.swift
//  GoesTests
//
//  Created by Yenting Chen on 2019/5/10.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import XCTest
import Firebase
@testable import Goes

class GoesTest: XCTestCase {
    
    func produceOrderDetail(year: Int, month: Int, time: String, day: Int ) -> OrderDetail {
        
        let testOrderDetail = OrderDetail(
            driverUid: "123",
            riderUid: "456",
            locationFormattedAddress: "taipei Xinyi",
            selectedLat: 22.5,
            selectedLng: 112.2,
            locationName: "taipei",
            locationPlaceID: "taipeiXinyi180",
            selectTimeDate: 201111111,
            selectTimeDay: day,
            selectTimeYear: year,
            selectTimeMonth: month,
            selectTimeTime: time,
            orderID: "1111",
            driverLat: 22.3,
            driverLag: 112.3,
            riderLat: 22.4,
            riderLag: 112.5,
            setOff: 1,
            driverStartLat: 22.2,
            driverStartLag: 112.2,
            driverStartTime: 20111111,
            completeTime: 20111122)
        
        return testOrderDetail
    }
    
    
    func test_ProduceTime() {
        let order = produceOrderDetail(year: 2019, month: 13, time: "25:06", day: 30)
        let abc = String.produceTime(order: order )
        print(abc)
        
    }
    
    func test_produceTime_success() {
        
    }
    
}

//class MockFirestore: Firestore {
//
//    static var path: String = ""
//
//    override func collection(_ collectionPath: String) -> CollectionReference {
//
//        MockFirestore.path += (collectionPath + "/")
//
//        return super.collection(collectionPath)
//    }
//
//    override func document(_ documentPath: String) -> DocumentReference {
//
//        MockFirestore.path += (documentPath + "/")
//
//        return super.document(documentPath)
//    }
//}
//
//class MockCollectionReference: CollectionReference {
//
//    init(test: String) {
//
//    }
//
//    override func getDocuments(completion: @escaping FIRQuerySnapshotBlock) {
//
//    }
//}
//
//class MockDocumentReference: DocumentReference {
//
//    init(test: String) {
//
//    }
//}

//class GoesTests: XCTestCase {
//    
//    
//    override func setUp() {
//        
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//    
////    func test_queryUserInfo_pathShouldBeUserId() {
////
////        let mock = MockFirestore.firestore()
////        
////        let manager = FireBaseManager(db: mock)
////        
////        manager.queryUserInfo(userID: "12345") { (profile) in
////            
////        }
////        
////        print(mock.path)
////    }
//    
////    func getUserName() -> String {
////        let group = DispatchGroup()
////        var userName = ""
////        group.enter()
////        self.testFirebaseManager.queryUserInfo(userID: "4VHjH8RqDhMKOpjCIIFBHGue97h2") { (myProfile) in
////            userName = (myProfile?.userName)!
////            group.leave()
////        }
////
////        group.notify(queue: .main) {
////            return userName
////        }
////
////        return String()
////
////    }
//
////    func testExample() {
////        getUserName()
////        var realResult = getUserName()
////
////        let testResult = mockDB.queryData(userId: "4VHjH8RqDhMKOpjCIIFBHGue97h2")
////        XCTAssertTrue(testResult == realResult)
////
////    }
////
////    func testPerformanceExample() {
////        // This is an example of a performance test case.
////        self.measure {
////            // Put the code you want to measure the time of here.
////
////        }
////    }
//
//}

//class TestFireBaseManager: NSObject {
//
//    static let share = TestFireBaseManager()
//
//    private override init() {}
//
//    var db = Firestore.firestore()
//
//     var userProfile: MyProfile?
//
//    typealias CompletionHandler = (MyProfile?) -> Void
//
//    func queryUserInfo(userID: String, completion: @escaping CompletionHandler) {
//
//        let userProfile =  db.collection("users").document(userID)
//
//        userProfile.getDocument { (document, error) in
//
//            if let profile = document.flatMap({ $0.data().flatMap({ (data) in
//                return Profile(dictionary: data)
//            })
//            }) {
//                self.userProfile = MyProfile(
//                    email: profile.email,
//                    userID: profile.userID,
//                    userName: profile.userName,
//                    phoneNumber: profile.phoneNumber,
//                    avatar: profile.avatar,
//                    fcmToken: profile.fcmToken)
//
//                print("Profile: \(profile)")
//
//                completion(self.userProfile)
//
//            } else {
//                print("Document does not exist")
//            }
//
//        }
//    }
//}
//
//class MockFireBaseDataBase {
//
//    let userId = "12345"
//
//    func queryData(userId: String ) -> String? {
//
//        if userId == self.userId {
//
//
//            return "彥廷"
//
//        } else {
//
//            return nil
//        }
//
//    }
//}
