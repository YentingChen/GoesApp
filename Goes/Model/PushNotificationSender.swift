//
//  PushNotificationSender.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/3.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class PushNotificationSender {
    
    func sendPushNotification(to token: String, title: String, body: String) {
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        
        let url = NSURL(string: urlString)!
        
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=AAAABfcYn1g:APA91bH2wKrrTX_PLQMs6yMpsr5F0MaPDyPp4d3z_OZHBfa5Lq1PJqXM6qubLAVOltDf5H1FB5xzw7Abn-YWGTJxlQd6sf51OV7aqra5p2qEDCTxpYDB0ddd7YsD3InpbYVmBpRFh-Vt",
                     forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                 if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
