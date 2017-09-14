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

fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"
fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 3
fileprivate var ads = [Ad]()
fileprivate var adImages = [UIImage]()

private let reuseIdentifier = "adCell"
//var cellHeight:CGFloat = CGFloat()



class AdCollectionViewControllerold: UICollectionViewController, StaggeredGridLayoutDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let postAdButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postAd(_:)))
////        let postAdButton = UIBarButtonItem(title: "Post Ad", style: .plain, target: self, action: #selector(postAd(_:)))
//        navigationItem.rightBarButtonItem = postAdButton
//    
        
        self.view.backgroundColor = UIColor.white
        
        if let layout = collectionView?.collectionViewLayout as? StaggeredGridLayout {
            layout.delegate = self
            print("delegate set to self")
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
        
        
//        let pastAdController
//        
//        switch(segue.identifier ?? "") {
//            
//        case "ShowGroup":
//            let navController = segue.destination as! UINavigationController
//            let groupDetailViewController = navController.topViewController as! GroupDetailViewController
//            
//            guard let selectedGroupCell = sender as? GroupCollectionViewCell else {
//                fatalError("unexpected sender: \(sender)")
//            }
//            
//            guard let indexPath = collectionView?.indexPath(for: selectedGroupCell) else {
//                fatalError("The selected cell is not being displayed by the collection view")
//            }
//            
//            let selectedGroup = groups[indexPath.row]
//            groupDetailViewController.group = selectedGroup
//            
//        case "AddGroup": break
//            
//        default:
//            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
//        }
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

    //MARK: StaggeredGridLayout
    
    func collectionView(_ collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let adImage = adImages[indexPath.item]
        var height:CGFloat = 0.0
        
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect:CGRect  = AVMakeRect(aspectRatio: adImage.size, insideRect: boundingRect)
        let aspectRatio = rect.size.width / width
        height = rect.size.height / aspectRatio
//        print("height \(height)")
        return height + 100.0
    }
    
//    func getImage(photoUrl:URL, width: CGFloat, completion: @escaping (CGFloat) -> ()) {
//        KingfisherManager.shared.downloader.downloadImage(with: photoUrl, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
//            
//            var height = CGFloat()
//            var adImage = UIImage()
//            if image != nil {
//                adImage = image!
//            } else {
//                adImage = #imageLiteral(resourceName: "error")
//            }
//            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
//            let rect:CGRect  = AVMakeRect(aspectRatio: adImage.size, insideRect: boundingRect)
//            let aspectRatio = rect.size.width / width
//            height = rect.size.height / aspectRatio
//            print("get image height is \(height)")
//            cellHeight = height
//            completion(height)//rect.size.height )
//        })
//        
//    }
//    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
//                let annotationPadding = CGFloat(4)
//                let annotationHeaderHeight = CGFloat(17)
////                let photo = lists[indexPath.item]
//                let font = UIFont(name: "AvenirNext-Regular", size: 10)!
////                let commentHeight = photo.heightForComment(font, width: width)
//        
//                /* You then add that height to a hard-coded annotationPadding value for the top and bottom, as well as a hard-coded annotationHeaderHeight that accounts for the size of the annotation title.
//                 */
//                let height = annotationPadding + annotationHeaderHeight + 100.0 + annotationPadding
        print("annotations here")
        return 100.0//height
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
                self.getImagesByUrl(ads: ads)
//                if (self.collectionView?.reloadData()) != nil {
//                    print("reloaded")
////                    self.collectionViewLayout.prepare()
//                }
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func getImagesByUrl(ads: [Ad]) {
        for ad in ads {
//            let ad = ads[i]
            let urlpath = "http://dutch.ng/uploads/\(ad.image)"
            let url = URL(string: urlpath)!
            print("url is \(url)")
//            ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
//                (image, error, url, data) in
//                print("Downloaded Image: \(image)")
//            }
            KingfisherManager.shared.downloader.downloadImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                if image != nil && !ad.image.isEmpty {
                    adImages.append(image!)
                } else {
                    adImages.append(#imageLiteral(resourceName: "error"))
                }
                
                if (adImages.count == ads.count) {
//                    print("ads: \(ads.count) and adimages: \(adImages.count)")
                    self.collectionView?.collectionViewLayout.invalidateLayout()
                    self.collectionView?.reloadData()
//                    self.collectionViewLayout.prepare()
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
