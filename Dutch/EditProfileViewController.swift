//
//  EditProfileViewController.swift
//  Dutch
//
//  Created by Apple on 29/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import Alamofire
import SwiftyJSON
import SCLAlertView


fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"

class EditProfileViewController: FormViewController {
   
    var user:User = User(name:"name", email:"email")
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(EditProfileViewController.goBack(_:)))
        navigationItem.leftBarButtonItem = backButton
        
        let postButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(EditProfileViewController.saveProfile(_:)))
        navigationItem.rightBarButtonItem = postButton
        
        self.view.backgroundColor = UIColor.flatWhite
        tableView?.backgroundColor = UIColor.flatWhite
        
        form
            +++ Section()
            <<< TextRow() {
                $0.title = "Name"
                $0.placeholder = "Your Name"
                $0.value = user.name //default user name
                $0.onChange({ [unowned self] row in
                    self.user.name = row.value!
                    print("name edited")
                })
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = UIColor.flatRed
                    }
                }
            }
            
            <<< PhoneRow() {
                $0.title = "Phone"
                $0.placeholder = "Your Phone"
                $0.value = user.phone //default user name
                $0.onChange({ [unowned self] row in
                    self.user.name = row.value!
                    print("phone edited")
                })
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = UIColor.flatRed
                    }
                }
            }
            
            <<< ImageRow() {
                $0.title = "Change Photo"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera] //1
                $0.clearAction = .yes(style: .destructive) //3
                $0.onChange { [unowned self] row in //4
                    self.image = row.value!
                    print("required image attached \(self.image)")
                }
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.backgroundColor = UIColor.flatRed
                    }
                }
            }
        
        
        
    }
    
    func goBack(_ sender: UIBarButtonItem!) {
        print("returned")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func saveProfile(_ sender: UIBarButtonItem!) {
        if form.validate().isEmpty {
            print("edited")
            _ = self.navigationController?.popViewController(animated: true)
            
//            SCLAlertView().showSuccess("Congrats!", subTitle: "Your ad was successfully posted")
            //            _ = self.navigationController?.popViewController(animated: true)
        } else {
            SCLAlertView().showError("Oops!", subTitle: "Please fill in the required fields")
        }
    }
    
    
}
