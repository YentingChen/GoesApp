//
//  GoogleMapManager.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/18.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GoogleMapManager {
    func getCoordinate(placeID: String, completionHandler: @escaping (Double, Double) -> Void) {
        
        let apiKey = "AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
        let url = "https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=\(placeID)&key=\(apiKey)"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let latitute = json["result"]["geometry"]["location"]["lat"].numberValue
                let longtitute = json["result"]["geometry"]["location"]["lng"].numberValue
                completionHandler(Double(truncating: latitute),Double(truncating: longtitute))
                
            } catch {
                print("ERROR: not working")
            }
        }
        
    }
}
