//
//  AdCollectionViewController.swift
//  Dutch
//
//  Created by Apple on 08/08/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import AlamofireImage
import Kingfisher
import NVActivityIndicatorView
import SCLAlertView

fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"
fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 2
fileprivate var ads = [Ad]()
fileprivate var adImages = [UIImage]()

private let reuseIdentifier = "adCell"
//var cellHeight:CGFloat = CGFloat()



class AdCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let frame = CGRect(x: (self.view.frame.width/2) - 20.0, y: (self.view.frame.height/2) - 20.0, width: 40.0, height: 40.0)
        
        let activityIndicatorType = NVActivityIndicatorType(rawValue: 5)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: activityIndicatorType, color: UIColor.flatRed, padding: 0.0)
        self.view.addSubview(activityIndicatorView)
        if ads.isEmpty {
            activityIndicatorView.startAnimating()
        }
        
        getAds()
        
    }
    
    func postAd(_ sender: UIBarButtonItem!) {
        print("post")
        let postAdController = PostAdViewController()
        self.navigationController?.pushViewController(postAdController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "showAd":
            
            let navController = segue.destination as! UINavigationController
            let detailVC = navController.topViewController as! AdDetailViewController
            guard let selectedCell = sender as? AdCollectionViewCell else {
                fatalError("unexpected sender: \(sender)")
            }
            guard let indexPath = collectionView?.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table view")
            }
            let selectedAd = ads[indexPath.row]
            detailVC.ad = selectedAd
            print("selected ad user is: \(selectedAd.user?.name) ")
            
        default:
            fatalError("Unexpected Segue Identifier \(segue.identifier)")
        }
        
    }
    
    @IBAction func unwindToAdCollection(sender: UIStoryboardSegue) {
        print("unwound")
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return ads.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AdCollectionViewCell
        
        cell.prepareForReuse()
        
        let ad = ads[indexPath.item]
        // Configure the cell
        
        let adImage = ad.image
        let photoUrl = URL(string: "http://dutch.ng/uploads/\(adImage)")!
        
        cell.adImage.kf.indicatorType = .activity
        //        cell.adImage.image = adImages[indexPath.item]
        cell.adImage.kf.setImage(with: photoUrl, placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(ImageTransition.fade(1))])
        cell.adTitle.text = ad.title.capitalized
        if ad.price == 0.0 {
            cell.adPrice.text = "Negotiable"
        }
        else {
            cell.adPrice.text = "N\(String(format: "%.2f", arguments: [ad.price]))"
        }
        cell.adCategory.text = ad.category?.title.uppercased()
        print(" category is \(ad.category?.title)" )
        
        if cell.contentView.frame.height == cell.adImage.frame.height {
            print("cell is same height as image \(cell.adImage.frame.height)")
        } else {
            print("cell vs image: \(cell.contentView.frame.height) vs \(cell.adImage.frame.height)")
        }
        print("annotations height minus padding is: \(cell.adTitle.frame.height + cell.adPrice.frame.height + cell.adCategory.frame.height)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem+100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    private func getAds() {
        let userId = 1
        let getAds = "\(base)home"
        let parameters:Parameters = ["user_id": userId]
        
        Alamofire.request(getAds, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print("JSON is: \(json) ... ")
                for (_,jsonAd) in json {
                    //                    print("New* ad JSON is: \(ad) ... ")
                    
                    var ad = Ad(id: jsonAd["id"].intValue, categoryId: jsonAd["category_id"].intValue, title: jsonAd["title"].stringValue, alias: jsonAd["alias"].stringValue, description: jsonAd["description"].stringValue, price: jsonAd["price"].doubleValue, address1: jsonAd["address1"].stringValue, address2: jsonAd["address2"].stringValue, address3: jsonAd["address3"].stringValue, phone: jsonAd["phone"].stringValue, views: jsonAd["views"].intValue, published: jsonAd["published"].intValue, userId: jsonAd["user_id"].intValue, image: jsonAd["image"].stringValue, createdAt: jsonAd["created_at"].stringValue, updatedAt: jsonAd["updated_at"].stringValue, user: User.userFromJSONData(jsonData: jsonAd["user"]), category: Category.categoryFromJSONData(jsonData: jsonAd["category"]), images: Image.imagesFromJSONArray(jsonArray: jsonAd["images"].arrayValue))
                    
                    let category = Category(id: jsonAd["category_id"].intValue, title: jsonAd["category"]["title"].stringValue, alias: jsonAd["category"]["alias"].stringValue, parent_id: jsonAd["category"]["parent_id"].intValue, published: jsonAd["category"]["published"].intValue, ad: nil)
                    let user = User(id: jsonAd["user_id"].intValue, name: jsonAd["user"]["name"].stringValue, email: jsonAd["user"]["email"].stringValue, phone: jsonAd["user"]["phone"].stringValue, avatar: jsonAd["user"]["avatar"].stringValue, provider: "", providerId: "", createdAt: jsonAd["user"]["created_at"].stringValue, updatedAt: jsonAd["user"]["updated_at"].stringValue)
                    var imageArray = [Image]()
                    for(_, jsonImage) in jsonAd["images"] {
                        let image = Image(id: jsonImage["id"].intValue, image: jsonImage["image"].stringValue, itemId: jsonImage["item_id"].intValue, published: jsonImage["published"].intValue, s3key: jsonImage["s3key"].stringValue, createdAt: jsonImage["created_at"].stringValue, updatedAt: jsonImage["updated_at"].stringValue)
                        imageArray.append(image)
                    }
                    ad.category = category
                    ad.user = user
                    ad.images = imageArray
                    ads.append(ad)
                }
                self.collectionView?.reloadData()
                self.activityIndicatorView.stopAnimating()
//                self.activityIndicatorView.remo
                
            case .failure(let error):
                print(error)
                
                SCLAlertView().showError("Network Error", subTitle: "\(error.localizedDescription) Please check your connection and try again")
//                SCLAlertView().showTitle(
//                    " ", // Title of view
//                    subTitle: "You need an account to post an ad. Create or log in to your account now", // String of view
//                    style: .warning, // Optional button value, default: ""
//                    closeButtonTitle: "Okay",
//                    colorStyle: UInt(UIColor.flatRed.toHex!, radix: 16),
//                    colorTextButton: 0xFFFFFF
//                )
                
            }
        }
        
    }
    
    
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
