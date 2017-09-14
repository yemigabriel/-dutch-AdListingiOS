//
//  FirstViewController.swift
//  Dutch
//
//  Created by Apple on 28/06/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postAdController = PostAdViewController()
        self.navigationController?.pushViewController(postAdController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

