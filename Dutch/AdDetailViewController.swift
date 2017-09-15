//
//  AdDetailViewController.swift
//  Dutch
//
//  Created by Apple on 26/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import Kingfisher
import ImageSlideshow



fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"


class AdDetailViewController: UIViewController {

//    var ad = Ad(categoryId: 0, title: "title", description: "description", price: 0.0, address1: "", address2: "", address3: "", phone: "", published: 0, userId: 0, image: "")
    var ad = Ad(id: 0, categoryId: 0, title: "title", alias: "alias", description: "description", price: 0.0, address1: "", address2: "", address3: "", phone: "", views: 0, published: 0, userId: 0, image: "", createdAt: "", updatedAt: "", user: nil, category: nil, images: nil)
    
//    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adPrice: UILabel!
    @IBOutlet weak var adDescription: UILabel!
    @IBOutlet weak var imageSlide: ImageSlideshow!
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
//        _ = self.navigationController?.popViewController(animated: true)
//        let isPresentingInAddMode = presentingViewController is UINavigationController
//        if isPresentingInAddMode {
//            dismiss(animated: true, completion: nil)
//        }
//        else if let owningNavigationController = navigationController {
//            owningNavigationController.popViewController(animated: true)
//        }
//        else {
//            fatalError("The MealViewController is not inside a navigation controller")
//        }
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let textItem = "Check out '\(self.ad.title)' on Dutch.ng"
        print("alias \(ad.alias)")
        let urlpath = "http://dutch.ng/uploads/\(ad.alias!)"
        let urlItem: URL = URL(string: urlpath)!
        // If you want to put an image
//        let image : UIImage = UIImage(named: "image.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [textItem, urlItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (imageSlide)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.title = self.ad.title
        navigationItem.title = self.ad.title
        
        
        imageSlide.backgroundColor = UIColor.white
        imageSlide.slideshowInterval = 5.0
        imageSlide.pageControlPosition = PageControlPosition.underScrollView
        imageSlide.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        imageSlide.pageControl.pageIndicatorTintColor = UIColor.black
        imageSlide.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
//        imageSlide.activityIndicator = DefaultActivityIndicator()
        imageSlide.currentPageChanged = { page in
//            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        
//        let kingfisherSource = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
        

//        imageSlide.setImageInputs(localSource as! [InputSource])
        var localSource = [InputSource]()
//        localSource.append(KingfisherSource(urlString: "\(photoBase)\(self.ad.image)")!)
        if !((self.ad.images?.isEmpty)!) {
            for image in self.ad.images! {
                if let kfSource = KingfisherSource(urlString: "\(photoBase)\(image.image)") {
                    localSource.append(kfSource)
                }
            }
            print("not empty images ... \(self.ad.images)")
        }
        print("size of input sources \(localSource.count)")
        imageSlide.setImageInputs(localSource)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlide.addGestureRecognizer(gestureRecognizer)
        
        // Do any additional setup after loading the view.
        adTitle.text = self.ad.title
        if self.ad.price == 0.0 {
            adPrice.text = "Contact for price"
        }
        else {
        adPrice.text =   "N\(String(format: "%.2f", arguments: [self.ad.price]))"
        }
        adTitle.numberOfLines = 0
        adTitle.lineBreakMode = .byWordWrapping
        adDescription.numberOfLines = 0
        adDescription.lineBreakMode = .byWordWrapping
        adDescription.text = "\(self.ad.description)"
        
        incrementView(adId: self.ad.id!)
        
        print("user is... \(ad.user?.name) ")
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        switch(segue.identifier ?? "") {
            
        case "showSeller":
            
            let sellerProfileVC = segue.destination as! SellerProfileViewController
            let seller = ad.user
            sellerProfileVC.seller = seller!
            print("seller is: \(seller?.name) ")
            
        case "showAd" : break
            
            
        default:
//            fatalError("Unexpected Segue Identifier \(segue.identifier)")
            print("noneya bidness lol")
        }
    }
 
    func incrementView(adId: Int) {
        let incrementView = "\(base)viewed"
        let parameters:Parameters = ["item": adId]
        Alamofire.request(incrementView, method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON is: \(json) ... ")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didTap() {
        imageSlide.presentFullScreenController(from: self)
    }

}
