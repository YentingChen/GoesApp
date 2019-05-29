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


class MockFirestore: Firestore {

    static var path: String = ""

    override func collection(_ collectionPath: String) -> CollectionReference {

        MockFirestore.path += (collectionPath + "/")

        return super.collection(collectionPath)
    }

    override func document(_ documentPath: String) -> DocumentReference {

        MockFirestore.path += (documentPath + "/")

        return super.document(documentPath)
    }
}

class MockCollectionReference: CollectionReference {

    init(test: String) {

    }

    override func getDocuments(completion: @escaping FIRQuerySnapshotBlock) {

    }
}

class MockDocumentReference: DocumentReference {

    init(test: String) {

    }
}

class GoesTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_queryUserInfo_pathShouldBeUserId() {

        let mock = MockFirestore.firestore()

        let manager = FireBaseManager(db: mock)

        manager.queryUserInfo(userID: "12345") { (profile) in

        }

//        print(mock.path)
    }
    
    func getUserName() -> String {
        let testFirebaseManager = TestFireBaseManager.share
        let group = DispatchGroup()
        var userName = ""
        group.enter()
        testFirebaseManager.queryUserInfo(userID: "4VHjH8RqDhMKOpjCIIFBHGue97h2") { (myProfile) in
            userName = (myProfile?.userName)!
            group.leave()
        }

        group.notify(queue: .main) {
            return userName
        }

        return String()

    }

    func testExample() {
        getUserName()
        let mockDB = MockFireBaseDataBase()
        var realResult = getUserName()

        let testResult = mockDB.queryData(userId: "4VHjH8RqDhMKOpjCIIFBHGue97h2")
        XCTAssertTrue(testResult == realResult)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.

        }
    }

}

class TestFireBaseManager: NSObject {

    static let share = TestFireBaseManager()

    private override init() {}

    var db = Firestore.firestore()

     var userProfile: MyProfile?

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
}

class MockFireBaseDataBase {

    let userId = "12345"

    func queryData(userId: String ) -> String? {

        if userId == self.userId {

            return "彥廷"

        } else {

            return nil
        }

    }
}
