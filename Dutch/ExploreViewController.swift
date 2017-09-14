//
//  ExploreViewController.swift
//  Dutch
//
//  Created by Apple on 27/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import NVActivityIndicatorView
import SCLAlertView


fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"
fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 2

class ExploreViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var popularAdsCollectionView: UICollectionView!
    var query = String()
    
    var popularAds = [Ad]()
    let reuseIdentifier = "exploreCell"
    
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: (self.view.frame.width/2) - 20.0, y: (self.view.frame.height/2) - 20.0, width: 40.0, height: 40.0)
        
        let activityIndicatorType = NVActivityIndicatorType(rawValue: 5)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: activityIndicatorType, color: UIColor.flatRed, padding: 0.0)
        self.view.addSubview(activityIndicatorView)
        if popularAds.isEmpty {
            activityIndicatorView.startAnimating()
        }
        

//        popularAdsCollectionView.backgroundColor = UIColor.flatRed
        getPopularAds()
        
        popularAdsCollectionView.delegate = self
        popularAdsCollectionView.dataSource = self
        searchField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToExploreVC(sender: UIStoryboardSegue) {
        print("unwound")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil {
            query = searchField.text!
            self.performSegue(withIdentifier: "searchResults", sender: UITextField())
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showAd" {
            let navController = segue.destination as! UINavigationController
            let detailVC = navController.topViewController as! DetailViewController
            guard let selectedCell = sender as? ExploreCollectionViewCell else {
                fatalError("unexpected sender: \(sender)")
            }
            guard let indexPath = popularAdsCollectionView?.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table view")
            }
            let selectedAd = popularAds[indexPath.row]
            detailVC.ad = selectedAd
            print("explore selected ad user is: \(selectedAd.user?.name) ")
            
        }
        
        if segue.identifier == "searchResults" {
            let navController = segue.destination as! UINavigationController
            let detailVC = navController.topViewController as! SearchResultsViewController
            detailVC.query = self.searchField.text!
            print("search \(searchField.text) ")
            
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularAds.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExploreCollectionViewCell
        
        cell.prepareForReuse()
        print("explore dequed cell here... ")
        
        let ad = popularAds[indexPath.item]
        // Configure the cell
        
        let adImage = ad.image
        print("image is \(adImage)")
        let photoUrl = URL(string: "http://dutch.ng/uploads/\(adImage)")!
        
        cell.adImage.kf.indicatorType = .activity
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
    
    private func getPopularAds() {
        let userId = 1
        let getAds = "\(base)popular"
        let parameters:Parameters = ["user_id": userId]
        
        Alamofire.request(getAds, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for (_,jsonAd) in json {
                    
                    var ad = Ad(id: jsonAd["id"].intValue, categoryId: jsonAd["category_id"].intValue, title: jsonAd["title"].stringValue, alias: jsonAd["alias"].stringValue, description: jsonAd["description"].stringValue, price: jsonAd["price"].doubleValue, address1: jsonAd["address1"].stringValue, address2: jsonAd["address2"].stringValue, address3: jsonAd["address3"].stringValue, phone: jsonAd["phone"].stringValue, views: jsonAd["views"].intValue, published: jsonAd["published"].intValue, userId: jsonAd["user_id"].intValue, image: jsonAd["image"].stringValue, createdAt: jsonAd["created_at"].stringValue, updatedAt: jsonAd["updated_at"].stringValue, user: User.userFromJSONData(jsonData: jsonAd["user"]), category: Category.categoryFromJSONData(jsonData: jsonAd["category"]), images: Image.imagesFromJSONArray(jsonArray: jsonAd["images"].arrayValue))
                    
                    let category = Category(id: jsonAd["category_id"].intValue, title: jsonAd["category"]["title"].stringValue, alias: jsonAd["category"]["alias"].stringValue, parent_id: jsonAd["category"]["parent_id"].intValue, published: jsonAd["category"]["published"].intValue, ad: nil)
                    //                    print("original cat: \(ad.category.title)")
                    //                    print("new title: \(category.title)")
                    
                    let user = User(id: jsonAd["user_id"].intValue, name: jsonAd["user"]["name"].stringValue, email: jsonAd["user"]["email"].stringValue, phone: jsonAd["user"]["phone"].stringValue, avatar: jsonAd["user"]["avatar"].stringValue, provider: "", providerId: "", createdAt: jsonAd["user"]["created_at"].stringValue, updatedAt: jsonAd["user"]["updated_at"].stringValue)
                    
                    var imageArray = [Image]()
                    for(_, jsonImage) in jsonAd["images"] {
                        let image = Image(id: jsonImage["id"].intValue, image: jsonImage["image"].stringValue, itemId: jsonImage["item_id"].intValue, published: jsonImage["published"].intValue, s3key: jsonImage["s3key"].stringValue, createdAt: jsonImage["created_at"].stringValue, updatedAt: jsonImage["updated_at"].stringValue)
                        imageArray.append(image)
                    }
                    
                    ad.category = category
                    ad.user = user
                    ad.images = imageArray
                    
                    self.popularAds.append(ad)
                    print("explore \(ad.title)")
                }
                self.popularAdsCollectionView.collectionViewLayout.invalidateLayout()
                self.popularAdsCollectionView.reloadData()
                self.activityIndicatorView.stopAnimating()
                
            case .failure(let error):
                print(error)
                
                SCLAlertView().showError("Network Error", subTitle: "\(error.localizedDescription) Please check your connection and try again")
            }
        }
        
    }
    
    
    

}
