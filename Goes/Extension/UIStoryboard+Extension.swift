//
//  UIStoryboard+Extension.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/2.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let lobby = "Lobby"
    
    static let friend = "Friend"
    
    static let trolley = "Trolley"
    
    static let profile = "Profile"
    
    static let auth = "Auth"
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }
    
    static var lobby: UIStoryboard { return stStoryboard(name: StoryboardCategory.lobby) }
    
    static var friend: UIStoryboard { return stStoryboard(name: StoryboardCategory.friend) }
    
    static var trolley: UIStoryboard { return stStoryboard(name: StoryboardCategory.trolley) }
    
    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }
    
    static var auth: UIStoryboard { return stStoryboard(name: StoryboardCategory.auth) }
    
    private static func stStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}

