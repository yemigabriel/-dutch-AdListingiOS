//
//  SellerProfileViewController.swift
//  Dutch
//
//  Created by Apple on 27/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import AlamofireImage
import Kingfisher



class SellerProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePhone: UILabel!
    @IBOutlet weak var redBg: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileCreatedAt: UILabel!
    @IBOutlet weak var profileTable: UITableView!
    var profileOptions = ["Call Seller"/*, "Ads By Seller"*/]
    let cellIdentifier = "optionsCell"
    
    var seller = User(id: 0, name: "", email: "", phone: "", avatar: "", provider: "", providerId: "", createdAt: "", updatedAt: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.setNavigationBarHidden(true, animated: true)
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(SellerProfileViewController.goBack(_:)))
        navigationItem.leftBarButtonItem = backButton
        
        redBg.backgroundColor = UIColor.flatRed
        
        let profilePhoto = UIImage(named:"profile_placeholder")
        profileImage.image = profilePhoto?.af_imageRoundedIntoCircle()
        
        profileImage.contentMode = .scaleAspectFit
        
        let cornerRadius = profileImage.frame.width/2
        
        let avatar = seller.avatar!
        if !(seller.avatar?.isEmpty)! {
            var avatarUrl = URL(string: "http://dutch.ng/uploads/\(avatar)")!
            let index = avatar.index((avatar.startIndex), offsetBy: 4)
            if avatar.substring(to: index) == "http" {
                avatarUrl = URL(string: "\(avatar)")!
            }
            profileImage.kf.indicatorType = .activity
            let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
            profileImage.kf.setImage(with: avatarUrl, placeholder: #imageLiteral(resourceName: "profile_placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processor)])
        }
        else {
            //gravatar here...
            let gravatar = Gravatar(
                emailAddress: seller.email,
                defaultImage: Gravatar.DefaultImage.mysteryMan,
                forceDefault: true
            )
            let avatarUrl = URL(string: "\(gravatar.url(size: 100.0).absoluteString)")!
            profileImage.kf.indicatorType = .activity
            let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
            profileImage.kf.setImage(with: avatarUrl, placeholder: #imageLiteral(resourceName: "profile_placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processor)])
            
            
        }
        
        
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        
        
        profileName.text = seller.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss" //Your date format
        //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: seller.createdAt!) //according to date format your date string
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let formattedDate = dateFormatter.string(from:date!)
        print(formattedDate)
        
        
        profileCreatedAt.text = "Joined \(formattedDate)"
        profilePhone.text = seller.phone
        
        profileTable.delegate = self
        profileTable.dataSource = self
        
        
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
        
        switch indexPath.row {
        case 0:
            callSeller()
//        case 1:
//            sellerAds()
//        case 2:
//            myAds()
//        case 3:
//            myInbox()
//        case 4:
//            logOut()
        default:
            print("default")
        }
    }
    
    func callSeller() {
        let phone = seller.phone
        print("call \(phone) ")
//        open(scheme: "tel://\(phone)")
        guard let number = URL(string: "tel://" + phone!) else {
            print("error")
            return
        }
        UIApplication.shared.open(number)

    }
    
    func open(scheme: String) {
        
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
        
    }
    
    func sellerAds() {
        
    }
    
    func goBack(_ sender: UIBarButtonItem!) {
        print("returned")
        _ = self.navigationController?.popViewController(animated: true)
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
