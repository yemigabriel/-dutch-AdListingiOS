//
//  ProfileViewController.swift
//  Dutch
//
//  Created by Apple on 27/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import AlamofireImage
import Kingfisher

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var redBg: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileCreatedAt: UILabel!
    @IBOutlet weak var profileTable: UITableView!
    var profileOptions = [/*"Edit Profile", "Reset Password", "My Ads", "Inbox", */"Logout"]
    let cellIdentifier = "optionsCell"
    var gravatar: Gravatar!
    var email = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        redBg.backgroundColor = UIColor.flatRed
        let profilePhoto = UIImage(named:"profile_placeholder")
        profileImage.image = profilePhoto?.af_imageRoundedIntoCircle()
        profileImage.contentMode = .scaleAspectFit
        
        let cornerRadius = profileImage.frame.width/2
        
//        profileImage.layer.cornerRadius = 50
        email = (UserDefaultsManager.userModel["email"] as! String?)!
        let avatar = UserDefaultsManager.userModel["avatar"] as! String?
        if !(avatar!.isEmpty) {
            
            var avatarUrl = URL(string: "http://dutch.ng/uploads/\(avatar)")!
            let index = avatar?.index((avatar?.startIndex)!, offsetBy: 4)
            if avatar?.substring(to: index!) == "http" {
               avatarUrl = URL(string: "\(avatar)")!
            }
            profileImage.kf.indicatorType = .activity
            let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
            profileImage.kf.setImage(with: avatarUrl, placeholder: #imageLiteral(resourceName: "profile_placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processor)])
            
        }
        else {
        //gravatar here...
            let gravatar = Gravatar(
                emailAddress: self.email,
                defaultImage: Gravatar.DefaultImage.mysteryMan,
                forceDefault: true
            )
            let avatarUrl = URL(string: "\(gravatar.url(size: 100.0).absoluteString)")!
            profileImage.kf.indicatorType = .activity
            let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
            profileImage.kf.setImage(with: avatarUrl, placeholder: #imageLiteral(resourceName: "profile_placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processor)])
            
            
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        
        
        profileName.text = UserDefaultsManager.userModel["name"] as! String?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss" //Your date format
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: UserDefaultsManager.userModel["createdAt"] as! String) //according to date format your date string
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let formattedDate = dateFormatter.string(from:date!)
        print(formattedDate)
        
        
        profileCreatedAt.text = "Joined \(formattedDate)"
    
        
        profileTable.delegate = self
        profileTable.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (profileOptions.count)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OptionsTableViewCell = profileTable.dequeueReusableCell(withIdentifier: cellIdentifier) as! OptionsTableViewCell
        
        cell.optionsLabel.text = profileOptions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        switch indexPath.row {
//        case 0:
//            editProfile()
//        case 1:
//            changePassword()
//        case 2:
//            myAds()
//        case 3:
//            myInbox()
//        case 4:
//            logOut()
//        default:
//            print("default")
//        }
        if indexPath.row == 0 {
            logOut()
        }
    }
    
    func editProfile() {
        print("edit")
        let editProfileController = EditProfileViewController()
        self.navigationController?.pushViewController(editProfileController, animated: true)
    }
    
    func changePassword() {
        print("change password")
    }
    
    func myAds() {
        
        print("my ads")
    }
    
    func myInbox() {
        
        print("my inbox")
    }
    
    func logOut() {
        
        let user = User(id: 0, name: "", email: "", phone: "", avatar: "", provider: "", providerId: "", createdAt: "2017-04-24 15:11:24", updatedAt: "2017-04-24 15:11:24")
        UserDefaultsManager.userModel = user.dictionaryRepresentation
        
//        dismiss(animated: true, completion: nil)
        self.tabBarController?.dismiss(animated: true, completion: nil)
        print("log out")
    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
////        let lyke = lykes[indexPath.row]
////        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsIdentifier") as? OptionsTableViewCell
//        
//        let cell = tab
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AdCollectionViewCell
//        cell?.textLabel?.text = profileOptions[indexPath.row]
////
////        cell?.lykeLabel.text = lyke.lyke
////        cell?.lykePhoto.image = lyke.photo
////        
//        //        Alamofire.request("\(photoBase)\(member.photo)").responseImage { response in
//        //
//        //            if let image = response.result.value {
//        //                print("image downloaded: \(image)")
//        //                cell?.memberPhoto.image = image.af_imageRoundedIntoCircle()
//        //            }
//        //        }
//        
//        return cell!
//        
//    }
    

}
