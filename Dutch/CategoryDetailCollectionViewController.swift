//
//  AdCollectionViewController.swift
//  Dutch
//
//  Created by Apple on 28/06/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import AlamofireImage
import Kingfisher
import NVActivityIndicatorView

fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"
fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 2
//fileprivate var ads = [Ad]()
fileprivate var adImages = [UIImage]()

private let reuseIdentifier = "adCell"
var cellHeight:CGFloat = CGFloat()



class CategoryDetailCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var category = Category(id: 0, title: "", alias: "", parent_id: 0, published: 0, ad: nil)
    var ads = [Ad]()
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: (self.view.frame.width/2) - 20.0, y: (self.view.frame.height/2) - 20.0, width: 40.0, height: 40.0)
        
        let activityIndicatorType = NVActivityIndicatorType(rawValue: 5)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: activityIndicatorType, color: UIColor.flatRed, padding: 0.0)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = self.category.title
        getAds()
//
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func unwindToExploreVC(sender: UIStoryboardSegue) {
        print("unwound")
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showAd" {
            let navController = segue.destination as! UINavigationController
            let detailVC = navController.topViewController as! DetailViewController
            guard let selectedCell = sender as? AdCollectionViewCell else {
                fatalError("unexpected sender: \(sender)")
            }
            guard let indexPath = collectionView?.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table view")
            }
            let selectedAd = ads[indexPath.row]
            detailVC.ad = selectedAd
            print("explore selected ad user is: \(selectedAd.user?.name) ")
            
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        print( "ads count is \(ads.count) and \(ads[0].title) and \(ads[0].image)")
        return (ads.count)
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
        
//        cell.adPrice.text = "N\(String(format: "%.2f", arguments: [ad.price]))"
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
        print ("width is \(widthPerItem)")
        
        return CGSize(width: widthPerItem, height: widthPerItem+100)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    private func getAds() {
        let categoryId = self.category.id
        let getAdsByCategory = "\(base)adsByCategory"
        print("cat is \(categoryId) for \(getAdsByCategory)")
        let parameters:Parameters = ["category_id": categoryId]
        
//        Alamofire.request(getAdsByCategory, method: .get, parameters: parameters).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                
//                print("JSON is: \(json) ... ")
//                for (_,jsonAd) in json {
//                    //                    print("New* ad JSON is: \(ad) ... ")
//                    
//                    var ad = Ad(id: jsonAd["id"].intValue, categoryId: jsonAd["category_id"].intValue, title: jsonAd["title"].stringValue, alias: jsonAd["alias"].stringValue, description: jsonAd["description"].stringValue, price: jsonAd["price"].doubleValue, address1: jsonAd["address1"].stringValue, address2: jsonAd["address2"].stringValue, address3: jsonAd["address3"].stringValue, phone: jsonAd["phone"].stringValue, views: jsonAd["views"].intValue, published: jsonAd["published"].intValue, userId: jsonAd["user_id"].intValue, image: jsonAd["image"].stringValue, createdAt: jsonAd["created_at"].stringValue, updatedAt: jsonAd["updated_at"].stringValue, user: User.userFromJSONData(jsonData: jsonAd["user"]), category: Category.categoryFromJSONData(jsonData: jsonAd["category"]), images: Image.imagesFromJSONArray(jsonArray: jsonAd["images"].arrayValue))
//                    
//                    let category = Category(id: jsonAd["category_id"].intValue, title: jsonAd["category"]["title"].stringValue, alias: jsonAd["category"]["alias"].stringValue, parent_id: jsonAd["category"]["parent_id"].intValue, published: jsonAd["category"]["published"].intValue, ad: nil)
//                    //                    print("original cat: \(ad.category.title)")
//                    //                    print("new title: \(category.title)")
//                    ad.category = category
//                    ads.append(ad)
//                }
//                self.getImagesByUrl(ads: ads)
//                //                if (self.collectionView?.reloadData()) != nil {
//                //                    print("reloaded")
//                ////                    self.collectionViewLayout.prepare()
//                //                }
//                
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        ads = self.category.ad!
//        print("count is \(ads.count) and \(self.category.ad?[0].title) and \(self.category.ad?[0].image)")
        //
        
        self.ads = self.category.ad!
        self.collectionView?.reloadData()
    }
    
    private func getImagesByUrl(ads: [Ad]) {
        for ad in self.category.ad! {
            //            let ad = ads[i]
            let urlpath = "http://dutch.ng/uploads/\(ad.image)"
            let url = URL(string: urlpath)!
            print("get images url is \(url)")
            KingfisherManager.shared.downloader.downloadImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                print("kingfisher downloader")
                if image != nil && !ad.image.isEmpty {
                    adImages.append(image!)
                    print("adimages appended")
                } else {
                    adImages.append(#imageLiteral(resourceName: "error"))
                    print("adimages appended")
                }
                
                
                if (adImages.count == self.category.ad!.count) {
                    self.ads = self.category.ad!
                    self.collectionView?.collectionViewLayout.invalidateLayout()
                    self.collectionView?.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    print("ads: \(ads.count) and adimages: \(adImages.count)")
                    
                }
                
            })
            
            
        }
        
    }
    
    
    
    
    
    
    
    
}

//extension String {
//    func capitalizingFirstLetter() -> String {
//        let first = String(characters.prefix(1)).capitalized
//        let other = String(characters.dropFirst())
//        return first + other
//    }
//    
//    mutating func capitalizeFirstLetter() {
//        self = self.capitalizingFirstLetter()
//    }
//}
