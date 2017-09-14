//
//  CategoriesTableViewController.swift
//  Dutch
//
//  Created by Apple on 24/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import Alamofire
import SwiftyJSON
import SCLAlertView
import NVActivityIndicatorView

//var category1 = Category(id: 1, title: "category 1")

fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"


private let reuseIdentifier = "categoryCell"
var allCategories = [Category]()


class CategoriesTableViewController: UITableViewController {

    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect())
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(x: (self.view.frame.width/2) - 20.0, y: (self.view.frame.height/2) - 20.0, width: 40.0, height: 40.0)
        
        let activityIndicatorType = NVActivityIndicatorType(rawValue: 5)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: activityIndicatorType, color: UIColor.flatRed, padding: 0.0)
        self.view.addSubview(activityIndicatorView)
        if allCategories.isEmpty {
            activityIndicatorView.startAnimating()
        }
        
        getCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allCategories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoriesTableViewCell
        
        cell.categoryTitle.text = allCategories[indexPath.row].title
        cell.productCount.text = "( \(allCategories[indexPath.row].ad?.count ?? 0) )"
        

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            case "showCategory":
                let detailVC = segue.destination as! CategoryDetailCollectionViewController
                guard let selectedCell = sender as? CategoriesTableViewCell else {
                    fatalError("unexpected sender: \(sender)")
                }
                guard let indexPath = tableView?.indexPath(for: selectedCell) else {
                    fatalError("The selected cell is not being displayed by the table view")
                }
                let selectedCategory = allCategories[indexPath.row]
                detailVC.category = selectedCategory
            print("selected category is: \(selectedCategory.title) with first ad \(selectedCategory.ad?[0].title) ")
            
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
 
    
    func getCategoryIdByTitle(title: String) -> Int {
        var id:Int = 0
        for category in allCategories {
            if (title == category.title) {
                print("id is \(category.id)")
                id = category.id
            }
        }
        return id
    }
    
    private func getCategories() {
        let getCategories = "\(base)cat"
        let parameters:Parameters = ["user_id": 1]
        
        Alamofire.request(getCategories, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print("category is: \(json) ... ")
                for (_,jsonCat) in json {
                    
                    var category = Category(id: jsonCat["id"].intValue, title: jsonCat["title"].stringValue, alias: jsonCat["alias"].stringValue, parent_id: jsonCat["parent_id"].intValue, published: jsonCat["published"].intValue, ad: Ad.adsFromJSONArray(jsonArray:jsonCat["item"].arrayValue)
                    )
                    var ads = [Ad]()
                    let adJsonArray = jsonCat["item"].arrayValue
                    for adJson in adJsonArray {
                        var ad = Ad(id: adJson["id"].intValue, categoryId: adJson["category_id"].intValue, title: adJson["title"].stringValue, alias: adJson["alias"].stringValue, description: adJson["description"].stringValue, price: adJson["price"].doubleValue, address1: adJson["address1"].stringValue, address2: adJson["address2"].stringValue, address3: adJson["address3"].stringValue, phone: adJson["phone"].stringValue, views: adJson["views"].intValue, published: adJson["published"].intValue, userId: adJson["user_id"].intValue, image: adJson["image"].stringValue, createdAt: adJson["created_at"].stringValue, updatedAt: adJson["updated_at"].stringValue, user: User.userFromJSONData(jsonData: adJson["user"]), category: Category.categoryFromJSONData(jsonData: adJson["category"]), images: Image.imagesFromJSONArray(jsonArray: adJson["images"].arrayValue))
                        
                        let user = User(id: adJson["user"]["id"].intValue, name: adJson["user"]["name"].stringValue, email: adJson["user"]["email"].stringValue, phone: adJson["user"]["phone"].stringValue, avatar: adJson["user"]["avatar"].stringValue, provider: "", providerId: "", createdAt: adJson["user"]["created_at"].stringValue, updatedAt: adJson["user"]["updated_at"].stringValue)
                        
                        var imageArray = [Image]()
                        for(_, jsonImage) in adJson["images"] {
                            let image = Image(id: jsonImage["id"].intValue, image: jsonImage["image"].stringValue, itemId: jsonImage["item_id"].intValue, published: jsonImage["published"].intValue, s3key: jsonImage["s3key"].stringValue, createdAt: jsonImage["created_at"].stringValue, updatedAt: jsonImage["updated_at"].stringValue)
                            imageArray.append(image)
                        }
                        
                        ad.user = user
                        ad.images = imageArray
                        ads.append(ad)
                        
                    }
                    
                    category.ad = ads
                    
                    allCategories.append(category)
                    
                }
                self.tableView?.reloadData()
                self.activityIndicatorView.stopAnimating()
                
            case .failure(let error):
                print(error)
                
                SCLAlertView().showError("Network Error", subTitle: "\(error.localizedDescription) Please check your connection and try again")
            }
        }
        
    }
    

}
