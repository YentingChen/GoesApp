//
//  ProfileMainViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Fusuma
import Firebase
import FirebaseCore
import Kingfisher

class ProfileMainViewController: UIViewController {
    
    var profilePersonalVC: ProfilePersonalDataViewController?
    let personalDataManager = PersonalDataManager.share
    let firebaseManager = FireBaseManager()
    let storage = Storage.storage()
    var myInfo: MyProfile?
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.roundCorners(50)
        }
    }
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func cameraBtn(_ sender: Any) {
       
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.availableModes = [FusumaMode.library, FusumaMode.camera] // Add .video capturing mode to the default .library and .camera modes
        fusuma.cropHeightRatio = 1 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = false  // You can select multiple photos from the camera roll. The default value is false.
        self.present(fusuma, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        segmentedControl.addUnderlineForSelectedSegment()

        segmentedControl.removeBorder()

        profilePersonalVC?.handler = { (myInfo) in
            
            self.userName.text = myInfo?.userName
            self.myInfo = myInfo
            guard let myself = self.myInfo else { return }
            if myself.avatar != "" {
                let url = URL(string: myself.avatar)
                self.avatarImageView.kf.setImage(with: url)
                self.avatarImageView.roundCorners(self.avatarImageView.frame.width/2)
                self.avatarImageView.clipsToBounds = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPersonalPage" {
        
            if let destination = segue.destination as? ProfilePersonalDataViewController {

                self.profilePersonalVC = destination
            }
        
        }
    }
   
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        if FireAuthManager.share.getCurrentUser()?.id != nil {
        
            do {
                try FireAuthManager.share.auth.signOut()
                let alert = UIAlertController(title: "", message: "你已經成功登出", preferredStyle: .alert)
                let action = UIAlertAction(title: "確定", style: .default) { (action) in
                    guard let uid = self.myInfo?.userID else { return }
                    self.firebaseManager.updateFcmToken(myUid: uid, fcmToken: "")
                    self.tabBarController?.dismiss(animated: true, completion: {
                        let tabStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabViewController = tabStoryboard.instantiateViewController(withIdentifier: "Goes") as? GoTabBarViewController

                        self.present(tabViewController!, animated: false, completion: nil)
                        
                        FireAuthManager.share.deleteListener()
                        FireAuthManager.share.deleteListener()
                        FireAuthManager.share.deleteListener()
                        FireAuthManager.share.deleteListener()
                    
                    })
                    
                    
                }
                
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func changeBtnView() {
        if scrollView.contentOffset.x == 0 {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.changeUnderlinePosition()

        }
        if scrollView.contentOffset.x == scrollView.frame.size.width {
            segmentedControl.selectedSegmentIndex = 1
            segmentedControl.changeUnderlinePosition()

        }

        if scrollView.contentOffset.x == scrollView.frame.size.width*2 {
            segmentedControl.selectedSegmentIndex = 2
            segmentedControl.changeUnderlinePosition()

        }

    }

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        segmentedControl.changeUnderlinePosition()
        if sender.selectedSegmentIndex == 0 {
            scrollView.contentOffset.x = 0
        }

        if sender.selectedSegmentIndex == 1 {
            scrollView.contentOffset.x = scrollView.frame.size.width
        }

        if sender.selectedSegmentIndex == 2 {
            scrollView.contentOffset.x = scrollView.frame.size.width*2
        }
    }

}

extension ProfileMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeBtnView()
    }

}

extension ProfileMainViewController: FusumaDelegate {
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        switch source {
        case .camera:
            print("Image captured from Camera")
            avatarImageView.image = image
            
            avatarImageView.roundCorners(50)
            avatarImageView.clipsToBounds = true
            avatarImageView.image = fixOrientation(img: avatarImageView.image!)
             NotificationCenter.default.post(name: Notification.Name.avatarValue, object: nil, userInfo: ["avatar": avatarImageView.image])

        case .library:
            print("Image selected from Camera Roll")
            avatarImageView.image = image
            avatarImageView.roundCorners(50)
            avatarImageView.clipsToBounds = true
            NotificationCenter.default.post(name: Notification.Name.avatarValue, object: nil, userInfo: ["avatar": avatarImageView.image])
            
        default:
            print("Image selected")
        }
        
        test()
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }

    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
    }

    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) -> Void in
        })
        
        guard let viewController =  UIApplication.shared.delegate?.window??.rootViewController,
            let presented = viewController.presentedViewController else {
            return
        }
        
        presented.present(alert, animated: true, completion: nil)
    }
    
    func test() {
        guard let myself = self.myInfo else {
            return
        }
        let imageStorageRef = Storage.storage().reference().child("photos").child("\(myself.userID).jpg")
        
        if let imageData = self.avatarImageView.image?.pngData() {
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            _ = imageStorageRef.putData(imageData, metadata: metadata) { (storageMetaData, err) in
                print("ok")
                imageStorageRef.downloadURL { (url, _) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    print(downloadURL)
                    guard let myInfo = self.myInfo else { return }
                    self.firebaseManager.updateAvatar(myUid: myInfo.userID, avatarUrl: "\(downloadURL)")
                    
                }
            }
        }
        
    }

    
}
