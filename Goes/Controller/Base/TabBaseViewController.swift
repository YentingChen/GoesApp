//
//  TabBaseViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/2.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

private enum Tab {

    case lobby

    case friend

    case profile

    case order

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .lobby: controller = UIStoryboard.lobby.instantiateInitialViewController()!

        case .friend: controller = UIStoryboard.friend.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        case .order: controller = UIStoryboard.order.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .lobby:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_24px_Home_Normal),
                selectedImage: UIImage.asset(.Icons_24px_Home_Selected)
            )

        case .friend:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_24px_Friend_Normal),
                selectedImage: UIImage.asset(.Icons_24px_Friend_Selected)
            )

        case .order:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_24px_Order_Normal),
                selectedImage: UIImage.asset(.Icons_24px_Order_Selected)
            )

        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_24px_Profile_Normal),
                selectedImage: UIImage.asset(.Icons_24px_Profile_Selected)
            )
        }
    }
}

class GoTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let userDefaults = UserDefaults.standard
   
    private let tabs: [Tab] = [.lobby, .order, .friend, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        delegate = self
        self.tabBar.backgroundColor = .clear
    
        
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController)
    -> Bool {
        
        let navVC = viewController as? UINavigationController
        
        if navVC?.viewControllers.first as? ProfileMainViewController == nil
        && navVC?.viewControllers.first as? FriendHomeViewController == nil
        && navVC?.viewControllers.first as? OrderMainViewController == nil {
            return true
        }
        
        guard let uid = userDefaults.value(forKey: UserdefaultKey.memberUid.rawValue) as? String, uid != "" else {
            
            if let viewController = UIStoryboard.auth.instantiateInitialViewController() {
                
                viewController.modalPresentationStyle = .overCurrentContext
                
                present(viewController, animated: false, completion: nil)
            }
            return false
        }
        
        return true
    }
}
