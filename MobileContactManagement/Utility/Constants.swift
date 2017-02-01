//
//  Constants.swift
//  MobileContactManagement
//
//  Created by Archita Bansal on 2/1/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Url{
        static let baseURL = "http://gojek-contacts-app.herokuapp.com"
        static let getContacts = "/contacts.json"
        static let postContacts = "/contacts.json"
        
    }
    struct Color {
        static let lightGreyBgColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        static let navBarColor = UIColor(red: 77/255, green: 67/255, blue: 197/255, alpha: 1)
        static let profileImageViewBgColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        static let darkGreenBtn = UIColor(red: 1/255, green: 153/255, blue: 102/255, alpha: 1)
    }
}
