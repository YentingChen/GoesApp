//
//  FriendHomeViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/6.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class FriendHomeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var menuBtnIsSelected = [false, false, false, false ]
    
    var friendSearchViewController: FriendSearchViewController!
    
    var selectedViewController: UIViewController!

   
    lazy var friendSentViewController: FriendSentViewController = {
        
        guard let friendVC = self.storyboard!.instantiateViewController(withIdentifier: "friendSentViewController") as? FriendSentViewController else {
            return FriendSentViewController()
        }
        return friendVC
    }() 

    
    lazy var friendListViewController: FriendListViewController = {
        
        guard let friendVC = self.storyboard!.instantiateViewController(withIdentifier:  "friendListViewController") as? FriendListViewController else {
            return FriendListViewController()
        }
        return friendVC
    }()

    lazy var friendInviteViewController: FriendInviteViewController = {
        
        guard let friendVC = self.storyboard!.instantiateViewController(
            withIdentifier: "friendInviteViewController"
        ) as? FriendInviteViewController else {
            
            return FriendInviteViewController()
        }
        
        return friendVC
    }()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerViewSegue" {
            if let destination = segue.destination as? FriendSearchViewController {
                self.friendSearchViewController = destination
            }
        }
        
    }

    func changePage(to newViewController: UIViewController) {
        // 2. Remove previous viewController
        selectedViewController.willMove(toParent: nil)
        selectedViewController.view.removeFromSuperview()
        selectedViewController.removeFromParent()
        
        // 3. Add new viewController
        addChild(newViewController)
        self.containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.bounds
        newViewController.didMove(toParent: self)

        // 4.
        self.selectedViewController = newViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FriendMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "friendMenuCollectionViewCell")
        selectedViewController = friendSearchViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Auto Select First Item
        self.collectionView.performBatchUpdates(nil) { _ in
            self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [.centeredHorizontally])
            self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
    }

}

extension FriendHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .top)

        let cellImage = [
            UIImage.asset(.Icons_40px_FriendSearch_Normal),
            UIImage.asset(.Icons_40px_FriendInvite_Normal),
            UIImage.asset(.Icons_40px_FriendList_Normal),
            UIImage.asset(.Icons_40px_FriendSent_Normal)]

        let cellImageSelected = [
            UIImage.asset(.Icons_40px_FriendSearch_Selected),
            UIImage.asset(.Icons_40px_FriendInvite_Selected),
            UIImage.asset(.Icons_40px_FriendList_Selected),
            UIImage.asset(.Icons_40px_FriendSent_Selected)
        ]

        let cellTitle = ["搜尋好友", "好友邀請", "好友列表", "送出"]

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "friendMenuCollectionViewCell",
            for: indexPath) as? FriendMenuCollectionViewCell else { return UICollectionViewCell() }


        if menuBtnIsSelected[indexPath.row] == true {
            cell.menuImage.image = cellImageSelected[indexPath.row]
            cell.menuLabel.text = cellTitle[indexPath.row]
            cell.menuLabel.textColor = UIColor.hexStringToUIColor(hex: "61CDE2")

        } else {
            cell.menuImage.image = cellImage[indexPath.row]
            cell.menuLabel.text = cellTitle[indexPath.row]
            cell.menuLabel.textColor = .lightGray

        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
        return CGSize(width: 70, height: 70)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "friendMenuCollectionViewCell",
            for: indexPath) as? FriendMenuCollectionViewCell {
            
        if indexPath.row == 0 {
            
            changePage(to: friendSearchViewController)
            menuBtnIsSelected = [false, false, false, false ]
            menuBtnIsSelected[indexPath.row] = true

            collectionView.reloadData()

        }

        if indexPath.row == 1 {
            changePage(to: friendInviteViewController)
            
            friendInviteViewController.loadDataFromDB()
            friendInviteViewController.loadViewIfNeeded()
            menuBtnIsSelected = [false, false, false, false]
            menuBtnIsSelected[indexPath.row] = true
            collectionView.reloadData()
        }
            

        if indexPath.row == 2 {
            changePage(to: friendListViewController)
            
            friendListViewController.loadDataFromDB()
            friendListViewController.loadViewIfNeeded()
            menuBtnIsSelected = [false, false, false, false ]
            menuBtnIsSelected[indexPath.row] = true
            collectionView.reloadData()
        }

        if indexPath.row == 3 {
            changePage(to: friendSentViewController)
            
            friendSentViewController.dataLoadFromDB()
//            self.containerView.reloadInputViews()
            friendSentViewController.loadViewIfNeeded()
            
            menuBtnIsSelected = [false, false, false, false ]
            menuBtnIsSelected[indexPath.row] = true
            collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .top)
    }
    }

}
