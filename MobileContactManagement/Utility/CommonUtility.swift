//
//  CommonUtility.swift
//  MobileContactManagement
//
//  Created by Archita Bansal on 1/31/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import Foundation
import UIKit

class CommonUtility:NSObject{
    
    //Show Alert with title and message and have default ok button
    class func showAlert(_ title:String,message:String) {
        (UIApplication.shared.delegate as! AppDelegate).window?.endEditing(true)
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
        
    }
}
