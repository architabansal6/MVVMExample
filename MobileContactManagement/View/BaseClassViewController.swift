//
//  BaseClassViewController.swift
//  MobileContactManagement
//
//  Created by Archita Bansal on 2/1/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import UIKit

class BaseClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        // Do any additional setup after loading the view.
    }

    //Configure Navigation Bar
    func configNavigationBar()
    {
        self.navigationController?.navigationBar.barTintColor = Constants.Color.navBarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        
    }

}
