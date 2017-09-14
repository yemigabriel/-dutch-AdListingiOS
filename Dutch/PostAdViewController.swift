//
//  PostAdViewController.swift
//  Dutch
//
//  Created by Apple on 01/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//


import UIKit
import Eureka
import ImageRow
import Alamofire
import SwiftyJSON
import SCLAlertView
import NVActivityIndicatorView


//fileprivate

fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"

class PostAdViewController: FormViewController {
    
//    convenience init() {
//        self.init()
//        initialize()
//    }
//
    var ad = Ad(categoryId: 0, title: "", description: "", price: 0.0, address1: "", address2: "", address3: "", phone: "", published: 0, userId: 0, image: "")

    var categoryList = [Category]()
    var stateList = [String]()
    var imageList = [UIImage]()
    
    
    let currentUser = UserDefaultsManager.userModel
    var userId = Int()
    var userPhone = String()
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: (self.view.frame.width/2) - 20.0, y: (self.view.frame.height/2) - 20.0, width: 40.0, height: 40.0)
        
        let activityIndicatorType = NVActivityIndicatorType(rawValue: 5)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: activityIndicatorType, color: UIColor.flatRed, padding: 0.0)
        
        userId = currentUser["id"] as! Int
        userPhone = currentUser["phone"] as! String
        ad.phone = userPhone
        ad.userId = userId
        
        getCategories()
        getStates()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(PostAdViewController.goBack(_:)))
        navigationItem.leftBarButtonItem = backButton
        
        let postButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(PostAdViewController.postAd(_:)))
        navigationItem.rightBarButtonItem = postButton
        
        self.view.backgroundColor = UIColor.flatWhite
        tableView?.backgroundColor = UIColor.flatWhite
        form
            +++ Section()
            <<< TextRow("Title") {
                $0.title = "Title"
                $0.placeholder = "Give your ad a title"
//                $0.value = "" //initial value
                $0.onChange({ [unowned self] row in
                    if row.value != nil {
                        self.ad.title = row.value!
                        print("title added")
                    }
                })
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = UIColor.flatRed
                    }
                }
            }
            
            <<< LabelRow("DescriptionLabel") {
                $0.title = "Description"
            }
            <<< TextAreaRow("Description") {
                $0.title = "Description"
                $0.placeholder = "Give a clear description for your ad"
//                $0.value = "" //initial value
                $0.onChange({ [unowned self] row in
                    if row.value != nil {
                        self.ad.description = row.value!
                        print("description added \(self.ad.description)")
                    }
                })
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.backgroundColor = UIColor.flatRed
                    }
                }
            }
            
            <<< SearchablePushRow<Category>("Choose Category") { row in
                row.options = categoryList
                row.title = "Choose Category" //2
                row.onChange { [unowned self] row in //5
                    
                    if row.value != nil {
                        if let value = row.value {
                            //                        self.getCategories()
                            print(value.id)
                            self.ad.categoryId = value.id
                        }
                    }
                }
                row.add(rule: RuleRequired()) //1
                row.validationOptions = .validatesOnChange //2
                row.cellUpdate { (cell, row) in //3
                    row.options = self.categoryList
                    if !row.isValid {
                        cell.backgroundColor = UIColor.flatRed
                    }
                }
                
            }
        
        
            <<< DecimalRow("Price") {
                $0.title = "Price"
                $0.placeholder = "Price (Naira)"
                $0.value = 0.0 //initial value
                $0.onChange({ [unowned self] row in
                    if row.value != nil {
                        self.ad.price = row.value!
                        print("price added \(self.ad.price)")
                    }
                })
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = UIColor.flatRed
//                        cell.detailTextLabel?.text = "price is deffo required dude/dudette"
                    }
                }
            }
        
            +++ Section()
            <<< PhoneRow("Phone") {
                $0.title = "Phone"
                $0.placeholder = "Phone Number"
                $0.value = self.userPhone //user phone from stored
                $0.onChange({ [unowned self] row in
                    if row.value != nil {
                        self.ad.phone = row.value!
                        print("phone added \(self.ad.phone)")
                    }
                })
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.textLabel?.textColor = UIColor.flatRed
                    }
                }
            }
            
            <<< PushRow<String>("Choose State") { row in
                row.options = stateList 
                row.title = "Choose State"
                row.onChange { [unowned self] row in //5
                    
                    if row.value != nil {
                        self.ad.address1 = row.value!
                        print("state added \(self.ad.address1) ")
                    }
                }
                row.add(rule: RuleRequired()) //1
                row.validationOptions = .validatesOnChange //2
                row.cellUpdate { (cell, row) in //3
                    row.options = self.stateList
                    if !row.isValid {
                        cell.backgroundColor = UIColor.flatRed
                    }
                }
            }
            
            <<< LabelRow("AddressLabel") {
                $0.title = "Address"
            }
            <<< TextAreaRow("Address") {
                $0.title = "Address"
                $0.placeholder = "Address"
                //                $0.value = "" //initial value
                $0.onChange({ [unowned self] row in
                    if row.value != nil {
                        self.ad.address3 = row.value!
                        print("address added \(self.ad.address3)")
                    }
                })
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.backgroundColor = UIColor.flatRed
                    }
                }
            }
        
//            <<< AlertRow<String>() {
//                $0.title = "Reminder"
//                $0.selectorTitle = "Remind me"
//                $0.value = viewModel.reminder
//                $0.options = viewModel.reminderOptions
//                $0.onChange { [unowned self] row in
//                    if let value = row.value {
//                        self.viewModel.reminder = value
//                    }
//                }
//            }
            
            +++ Section("Add Photos")
            <<< ImageRow() {
                $0.title = "Add Photo (required)"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera] //1
                $0.clearAction = .yes(style: .destructive) //3
                $0.onChange { [unowned self] row in //4
                    if row.value != nil {
                        self.imageList.append(row.value!)
                        print("required image attached \(row.value)")
                    }
                }
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.backgroundColor = UIColor.flatRed
                    }
                }
            }
            <<< ImageRow() {
                $0.title = "Add more photos (optional)"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera] //1
                $0.clearAction = .yes(style: .destructive) //3
                $0.onChange { [unowned self] row in //4
                    if row.value != nil {
                        self.imageList.append(row.value!)
                        print("optional image attached \(row.value)")
                    }
                }
            }
            <<< ImageRow() {
                $0.title = "Add more photos (optional)"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera] //1
                $0.clearAction = .yes(style: .destructive) //3
                $0.onChange { [unowned self] row in //4
                    if row.value != nil {
                        self.imageList.append(row.value!)
                        print("optional image attached \(row.value)")
                    }
                }
            }
            <<< ImageRow() {
                $0.title = "Add more photos (optional)"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera] //1
                $0.clearAction = .yes(style: .destructive) //3
                $0.onChange { [unowned self] row in //4
                    if row.value != nil {
                        self.imageList.append(row.value!)
                        print("optional image attached \(row.value)")
                    }
                }
            }
            <<< ImageRow() {
                $0.title = "Add more photos (optional)"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera] //1
                $0.clearAction = .yes(style: .destructive) //3
                $0.onChange { [unowned self] row in //4
                    if row.value != nil {
                        self.imageList.append(row.value!)
                        print("optional image attached \(row.value)")
                    }
                }
            }
        
        
    }
    
    func goBack(_ sender: UIBarButtonItem!) {
        print("returned")
        //        _ = self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func postAd(_ sender: UIBarButtonItem!) {
        if form.validate().isEmpty {
            print("uploading photos")
            self.view.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.startAnimating()
            
            
            uploadPhotos()
//            SCLAlertView().showSuccess("Congrats!", subTitle: "Your ad was successfully posted")
//            _ = self.navigationController?.popViewController(animated: true)
        } else {
            SCLAlertView().showError("Oops!", subTitle: "Please fill in the required fields")
        }
    }
    
    func getCategoryIdByTitle(title: String) -> Int {
        var id:Int = 0
        for category in categoryList {
            if (title == category.title) {
                print("id is \(category.id)")
                id = category.id
            }
        }
        return id
    }
    
//    func getStateIdByName(name: String) -> Int {
//        var id:Int = 0
//        for state in stateList {
//            if (name == state.name as! String) {
//                print("state id is \(state.id as! Int)")
//                id = state.id as! Int
//            }
//        }
//        return id
//    }
    
    private func getCategories() {
        let getCategories = "\(base)simple_categories"
        let parameters:Parameters = ["user_id": 1]
        
        Alamofire.request(getCategories, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
//                print("category is: \(json) ... ")
                for (_,jsonCat) in json {
//                    
//                    let category = Category(id: jsonCat[""]["id"].intValue, title: jsonCat[""]["title"].stringValue, alias: jsonCat[""]["alias"].stringValue, parent_id: jsonCat[""]["parent_id"].intValue, published: jsonCat[""]["published"].intValue, ad: nil)
                    
                    let category = Category(id: jsonCat["id"].intValue, title: jsonCat["title"].stringValue)
                    
//                    print("title is \(jsonCat["title"].stringValue) ... \(category.title)")
                    
                    self.categoryList.append(category)
                    
                }
                if let catRow = self.form.rowBy(tag: "Choose Category") {
                    catRow.updateCell()
                    print("cat updated")
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func getStates() {
        let getStates = "\(base)states"
        let parameters:Parameters = ["user_id": 1]
        
        Alamofire.request(getStates, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for (_,jsonState) in json {
                    
//                    var state: [String: Any] {
//                        return [
//                            "id" : jsonState["state_id"].intValue,
//                            "name" : jsonState["state_name"].stringValue
//                        ]
//                    }
//                    print("title is \(jsonState["state_name"].stringValue) ...")
                    
                    self.stateList.append(jsonState["state_name"].stringValue)
                    
                }
                if let stateRow = self.form.rowBy(tag: "Choose State") {
                    stateRow.updateCell()
                    print("state updated")
                }
                
            case .failure(let error):
                print(error)
            }
        }

    }
    
    func uploadPhotos() {
        let parameters = [
//            "file_name": "image.jpg",
            "title": self.ad.title,
            "description": self.ad.description,
            "category_id": self.ad.categoryId,
            "price": self.ad.price,
            "address1": self.ad.address1!,
            "address3": self.ad.address3!,
            "phone": self.ad.phone!,
            "published": 1,
            "user_id": self.userId
            
        ] as [String : Any]
        
        var imageDataArray = [Data]()
        for image in self.imageList {
            print("image data to list")
            let resizedImage = self.resizeImage(image: image)
            let imageData = UIImageJPEGRepresentation(resizedImage, 0.7)
            imageDataArray.append(imageData!)
            print("imageData is \(imageData)")
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
//            multipartFormData.append((self.ad.userId as Int).data(, withName: key)
            for (key, value) in parameters {
                print("value is \(value)")
                print("alamo about to fire the params \(key) : \(value)")
                
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                print("alamo fired the params \(key) : \(value) : data: \(value).data(using: .utf8)!")
            }
            for imageData in imageDataArray {
                multipartFormData.append(imageData, withName: "file[]", fileName: "image.jpg", mimeType: "image/jpeg")
                print("alamo firing the images")
            }
        }, to:"\(base)media/upload")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progress: \(progress)")
                })
                
                upload.responseJSON { response in
                    print("request: \(response.request)")  // original URL request
                    print("url response: \(response.response)") // URL response
                    print("data: \(response.data)")     // server data // URL response
                    print("result: \(response.result)")
                    
                    print("response: \(response)")
                    
                    self.activityIndicatorView.stopAnimating()
                    SCLAlertView().showTitle(
                        "Congrats", // Title of view
                        subTitle: "Your ad was successfully posted", // String of view
                        style: .success, // Optional button value, default: ""
                        closeButtonTitle: "Okay",
                        colorStyle: UInt(UIColor.flatGreen.toHex!, radix: 16),
                        colorTextButton: 0xFFFFFF
                    )
                    print("successful ad post")
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            case .failure(let encodingError):
                SCLAlertView().showTitle(
                    "Oops!", // Title of view
                    subTitle: "Something went wrong. Please check your connection and try again", // String of view
                    style: .error, // Optional button value, default: ""
                    closeButtonTitle: "Okay",
                    colorStyle: UInt(UIColor.flatRed.toHex!, radix: 16),
                    colorTextButton: 0xFFFFFF
                )
                
                print("failed: \(encodingError)")
            }
        }
    }
    
    
    // MARK: - Actions
//    @objc fileprivate func saveButtonPressed(_ sender: UIBarButtonItem) {
//        _ = navigationController?.popViewController(animated: true)
//    }
//    
//    @objc fileprivate func deleteButtonPressed(_ sender: UIBarButtonItem) {
//        
//        // Uncomment these lines
//        //    let alert = UIAlertController(title: "Delete this item?", message: nil, preferredStyle: .alert)
//        //    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//        //    let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
//        //      self?.viewModel.delete()
//        //      _ = self?.navigationController?.popViewController(animated: true)
//        //    }
//        //
//        //    alert.addAction(delete)
//        //    alert.addAction(cancel)
//        //
//        //    navigationController?.present(alert, animated: true, completion: nil)
//        
//        // Delete this line
//        _ = navigationController?.popViewController(animated: true)
//    }

    
    func resizeImage(image:UIImage) -> UIImage
    {
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = 720.0 //your choose height
        let maxWidth:Float = 720.0  //your choose width
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth) , height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData = UIImageJPEGRepresentation(img, 7.0)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData as Data)!
    }
    
    
}

