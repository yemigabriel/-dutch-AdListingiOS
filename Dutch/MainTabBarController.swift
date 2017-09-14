//
//  MainTabBarController.swift
//  Dutch
//
//  Created by Apple on 29/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit
import SCLAlertView

class MainTabBarController: UITabBarController {

    let button = UIButton.init(type: .custom)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let dummyUser = User(id: 0, name: "dummy", email: "dummy@email.com", phone: "08012345678", avatar: "sample.jpg", provider: "", providerId: "", createdAt: "2017-04-24 15:11:24", updatedAt: "2017-04-24 15:11:24")
//        UserDefaultsManager.userModel = dummyUser.dictionaryRepresentation
        
        
//        let tabBarControllerItems = self.tabBarController?.tabBar.items
//        
//        if let tabArray = tabBarControllerItems {
//            tabBarItem3 = tabArray[2]
//            
//            tabBarItem3.isEnabled = false
//            print("disabled tab bar index 2")
//        }
        
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            tabBarItem.isEnabled = false
            
            print("disabled tab bar index 2")
        }
        
        button.addTarget(self, action: #selector(postAd(_:)), for: .touchUpInside)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        
        button.backgroundColor = UIColor.flatGrayDark
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.flatWhite.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("disabled tab bar index 2 will appear")
//        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
//            tabBarItem.isEnabled = false
//            print("disabled tab bar index 2")
//        }
        if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            tabBarItem.isEnabled = false
            print("disabled tab bar index 2 will appear")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            tabBarItem.isEnabled = false
            print("disabled tab bar index 2 did appear")
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 44, width: 40, height: 40)
        
//        if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
//            tabBarItem.isEnabled = false
//            print("disabled tab bar index 2 layout")
//        }
    }
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("the selected index is : \(tabBar.items?.index(of: item))")
        if tabBar.items?.index(of: item) == 4 {
            //profile view
            print("we are here... profile")
            if (UserDefaultsManager.userModel["id"] as! Int == 0) {
                //return to welcome page
                
//                SCLAlertView().showInfo(" ", subTitle: "You need an account to view your profile. Create or log in to your account now")
                SCLAlertView().showTitle(
                    " ", // Title of view
                    subTitle: "You need an account to view your profile. Create or log in to your account now", // String of view
                    style: .warning, // Optional button value, default: ""
                    closeButtonTitle: "Okay",
                    colorStyle: UInt(UIColor.flatRed.toHex!, radix: 16),
                    colorTextButton: 0xFFFFFF
                )
                print("login/sign in")
                dismiss(animated: true, completion: nil)
            } else {
                print("proceed")
            }
        }
    }
    
    func postAd(_ button: UIButton!) {
        print("posting from middle button")
//        let postAdController = PostAdViewController()
//        self.navigationController?.pushViewController(postAdController, animated: true)
//        self.present(postAdController, animated: true, completion: nil)
//        self.tabBarController?.selectedIndex = 2
        if (UserDefaultsManager.userModel["id"] as! Int == 0) {
            //return to welcome page
            
//            SCLAlertView().showInfo(" ", subTitle: "You need an account to post an ad. Create or log in to your account now")
            SCLAlertView().showTitle(
                " ", // Title of view
                subTitle: "You need an account to post an ad. Create or log in to your account now", // String of view
                style: .warning, // Optional button value, default: ""
                closeButtonTitle: "Okay",
                colorStyle: UInt(UIColor.flatRed.toHex!, radix: 16),
                colorTextButton: 0xFFFFFF
            )
            print("login/sign in")
            dismiss(animated: true, completion: nil)
        } else {
            let postAdController = PostAdViewController()
            let navViewController: UINavigationController = UINavigationController(rootViewController: postAdController)
            self.present(navViewController, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor {
    
    // MARK: - Initialization
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.characters.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
        
        
    }
    
}
