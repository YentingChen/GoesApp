//
//  URL+.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/9.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

extension URL {
    
    static func callPhone(phoneNumber: String) -> URL? {
        
        return URL(string: "tel://" + "\(phoneNumber)")
        
    }
    
    static func googleMapDirection(origin: Point, destination: Point) -> URL {
        
        let host = "https://maps.googleapis.com/maps"
        
        let pathComponent = "/api/directions/json"
        
        let hostPath = host + pathComponent
        
        let key = "AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
        
        let mode = "mode=driving"
        
        let originPosition = origin.convertCoordinate()
        
        let destinationPosition = destination.convertCoordinate()
        
        return URL(
            string: "\(hostPath)?origin=\(originPosition)&destination=\(destinationPosition)&\(mode)&key=\(key)")!
    }
}

struct Point {
    
    // swiftlint:disable identifier_name
    
    let x: Double
    
    let y: Double
    
    init(x: Double, y: Double) {
        
        self.x = x
        
        self.y = y
    }
    
     func convertCoordinate() -> String {
        return "\(x),\(y)"
    }
    
    // swiftlint:enable identifier_name
}
