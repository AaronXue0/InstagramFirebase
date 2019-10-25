//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Aaron Xue on 2019/10/26.
//  Copyright © 2019 Aaron Xue. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
//        navigationItem.title = "User Profile"
        
        fectch()
    }
    
    fileprivate func fectch(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
            print(uid)
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {snapShot in
            print(snapShot.value ?? "")
            
            let dictionary = snapShot.value as? [String: Any]
            let username = dictionary?["username"] as? String
            self.navigationItem.title = username
            
        }) {(err) in
            print("Failed to fetch, ", err)
        }
    }
}


