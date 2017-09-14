//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    @IBAction func signUpButton(_ sender: UIButton) {
        validate()
    }
    
    @IBOutlet weak var signUpBtnOutlet: UIButton!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailField.delegate = self
        passwordField.delegate = self
        nameField.delegate = self
        phoneField.delegate = self
//        inputViewContainer.layer.cornerRadius = 4
        
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
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordField {
            resignFirstResponder()
        }
        return true
    }

    func validate() {
        if ((emailField.text?.isEmpty)! || (phoneField.text?.isEmpty)!  || (nameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! ) {
            SCLAlertView().showError("Error", subTitle: "All fields are required")
        }
        else if !isValidEmail(testStr:emailField.text!) {
            SCLAlertView().showError("Error", subTitle: "Please enter a valid email address")
        }
        else {
            signUpBtnOutlet.setTitle("creating account...", for: .normal)
            createUser()
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
    func createUser() {
        
        let createUser = "\(base)user/create"
        let parameters:Parameters = ["name": nameField.text!, "email": emailField.text!, "phone": phoneField.text!, "password": passwordField.text! ]
        
        Alamofire.request(createUser, method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let userJson = json.dictionaryValue;
                print("my dicionary \(userJson)")
            
                let user = User(id: json["id"].intValue, name: json["name"].stringValue, email: json["email"].stringValue, phone: json["phone"].stringValue, avatar: json["avatar"].stringValue, provider: nil, providerId: nil, createdAt: json["created_at"].stringValue, updatedAt: json["updated_at"].stringValue)
                
                UserDefaultsManager.userModel = user.dictionaryRepresentation
                
                print("user created \(UserDefaultsManager.userModel)")
                
//                SCLAlertView().showSuccess("Welcome!", subTitle: "Welcome")
                
                self.signUpBtnOutlet.setTitle("Sign Up", for: .normal)
                
                self.performSegue(withIdentifier: "signUpIdentifier", sender: nil)
//                let segue = UIStoryboardSegue(identifier: <#T##String?#>, source: <#T##UIViewController#>, destination: <#T##UIViewController#>)
//                self.unwind(for: <#T##UIStoryboardSegue#>, towardsViewController: <#T##UIViewController#>)
                //TODO: do phone verification
                
            case .failure(let error):
                print("error: \(error)")
                SCLAlertView().showError("Oops!", subTitle: "\(error)")
                
                self.signUpBtnOutlet.setTitle("Sign Up", for: .normal)
            }
        }
    }
    

}
