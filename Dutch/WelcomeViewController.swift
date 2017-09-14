//
//  WelcomeViewController.swift
//  Dutch
//
//  Created by Apple on 01/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
//import SCAlertView

class WelcomeViewController: UIViewController /*, GIDSignInUIDelegate */ {

    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        var user = UserDefaultsManager.userModel
        if user.isEmpty {
            print("nil... no not logged in. stay")
        }
        else if user["id"] as! Int != 0 {
            print ("wlecome already logged in")
//            self.performSegue(withIdentifier: "welcomeIdentifier", sender: self)
//            performSegue(withIdentifier: "", sender: self)
            let vc = AdCollectionViewController()
            performSegue(withIdentifier: "welcomeIdentifier", sender: self)
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        } else {
            print("no not logged in. stay")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var user = UserDefaultsManager.userModel
        if user.isEmpty {
            print("nil... no not logged in. stay")
        }
        else if user["id"] as! Int != 0 {
            print ("wlecome did appear already logged in")
            //            self.performSegue(withIdentifier: "welcomeIdentifier", sender: self)
            //            performSegue(withIdentifier: "", sender: self)
            let vc = AdCollectionViewController()
            performSegue(withIdentifier: "welcomeIdentifier", sender: self)
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        } else {
            print("no not did appear logged in. stay")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    @IBAction func unwindToExploreVC(sender: UIStoryboardSegue) {
//        print("unwound")
//    }
    
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        // ...
//        if let error = error {
//            // ...
//            
//            print("\(error.localizedDescription)")
//            return
//        }
//        
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        // ...
//        
//        Auth.auth().signIn(with: credential) { (user, error) in
//            if let error = error {
//                // ...
//                print("\(error.localizedDescription)")
//                return
//            }
//            // User is signed in
//            // ...
//            let user = Auth.auth().currentUser
////            if let user = user {
////                // The user's ID, unique to the Firebase project.
////                // Do NOT use this value to authenticate with your backend server,
////                // if you have one. Use getTokenWithCompletion:completion: instead.
////                let uid = user.uid
////                let email = user.email
////                let photoURL = user.photoURL
////                
////                // ...
////            }
//            
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            let photoURL = user.profile.photoURL
//            
////            let user = User(id: json["id"].intValue, name: json["name"].stringValue, email: json["email"].stringValue, phone: json["phone"].stringValue, avatar: json["avatar"].stringValue, provider: nil, providerId: nil, createdAt: json["created_at"].stringValue, updatedAt: json["updated_at"].stringValue)
////            
////            UserDefaultsManager.userModel = user.dictionaryRepresentation
//            
//            
//        }
//        
//        
//    
//        
//    }
//    
//    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
//                withError error: NSError!) {
//        if (error == nil) {
//            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            // ...
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }
    

}


