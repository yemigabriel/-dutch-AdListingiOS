//
//  LoginViewController.swift
//  Dutch
//
//  Created by Apple on 31/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import SCLAlertView


fileprivate let base = "http://dutch.ng/doxa360/api/v1/"
fileprivate let photoBase = "http://dutch.ng/uploads/"

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBAction func loginButton(_ sender: UIButton) {
        validate()
    }
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordField {
            resignFirstResponder()
        }
        return true
    }

    func validate() {
        if ((emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)!) {
            SCLAlertView().showError("Error", subTitle: "All fields are required")
        }
        else if !isValidEmail(testStr:emailField.text!) {
            SCLAlertView().showError("Error", subTitle: "Please enter a valid email address")
        }
        else {
            loginBtnOutlet.setTitle("authenticating ... ", for: .normal)
            loginUser()
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,15}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }
    
    // MARK: - network calls
    private func loginUser() {
        
        let loginUser = "\(base)user/login"
        let parameters:Parameters = ["email": emailField.text!, "password": passwordField.text! ]
        
        Alamofire.request(loginUser, method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let userJson = json.dictionaryValue;
                print("my dicionary \(userJson)")
                
                let user = User(id: json["id"].intValue, name: json["name"].stringValue, email: json["email"].stringValue, phone: json["phone"].stringValue, avatar: json["avatar"].stringValue, provider: nil, providerId: nil, createdAt: json["created_at"].stringValue, updatedAt: json["updated_at"].stringValue)
                
                UserDefaultsManager.userModel = user.dictionaryRepresentation
                
                print("user logged in \(UserDefaultsManager.userModel)")
                
//                SCLAlertView().showSuccess("Success!", subTitle: "Welcome back")
                
                self.loginBtnOutlet.setTitle("Login", for: .normal)
                self.performSegue(withIdentifier: "loginIdentifier", sender: nil)
                //TODO: do phone verification
                
            case .failure(let error):
                print("error: \(error)")
                SCLAlertView().showError("Oops!", subTitle: "Login error: Wrong email or password. Please try again.")
                self.loginBtnOutlet.setTitle("Login", for: .normal)
                
            }
        }
    }
    
}
