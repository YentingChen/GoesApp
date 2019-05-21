//
//  Message.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/15.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import Firebase

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

struct Member {
    
    let name: String
    let uid: String
    
    init(name: String, uid: String) {
        self.name = name
        self.uid = uid
    }
}

struct Message: MessageType {
    
    var sender: SenderType
    let id: String?
    let content: String
    let sentDate: Date
    
    var kind: MessageKind {
        
        return .text(content)
        
    }
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    init(user: Member, content: String) {
        sender = Sender(id: user.uid, displayName: user.name)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        
        let data = document.data()
        
        let timestamp = data["created"] as? Timestamp
        
        guard let timeValue = timestamp?.dateValue() else {
            return nil
        }

        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.sentDate = timeValue
        
        sender = Sender(senderId: senderID, displayName: senderName)
        
        if let content = data["content"] as? String {
            
            self.content = content
            
        } else {
            return nil
        }
    }
    
}

extension Message: DatabaseRepresentation {
    
    var representation: [ String : Any ] {
        let rep: [ String : Any ] = [
            
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName,
            "content": content
        ]
        
        return rep
    }
    
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}
