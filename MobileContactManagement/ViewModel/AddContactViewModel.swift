//
//  AddContactViewModel.swift
//  ContactManagementApp
//
//  Created by Archita Bansal on 1/25/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import UIKit
import AFNetworking


public protocol AddContactViewModelDelegate: class {
    func saveContactDataSuccess()
    func saveContactDataFailure(message:String)
    func showInvalidName()
    func showInvalidMobile()
    func showInvalidEmailAddress()
}

//Contact Model to pass the contact data
class ContactModel: NSObject {
    var first_name: String?
    var last_name: String?
    var profile_pic: String?
    var email: String?
    var phone_number: String?
    var contact_vpa: String?
    var contact_is_address_book: Bool?
    var contact_citrus_uuid: String?
    var contact_is_invited: Bool?
}

class AddContactViewModel: NSObject {

    public var title = "Add Contact"
    public var delegate: AddContactViewModelDelegate?
    
    // new initializer
    public init(delegate: AddContactViewModelDelegate) {
        self.delegate = delegate
        super.init()
               
    }
    
    /**
    Description - checks field validation for name,mobile,email if valids then call post contact api and save contact data to server.
    */
    public func saveContact(contactModel:ContactModel){
        
        if contactModel.first_name == "" || (contactModel.first_name?.characters.count)! < 3{
            self.delegate?.showInvalidName()
            return
        }else if !self.isValidMobileNumber(phoneNum: contactModel.phone_number!){
            self.delegate?.showInvalidMobile()
            return
        }else if !self.isValidateEmail(contactModel.email!){
            self.delegate?.showInvalidEmailAddress()
            return
        }
        self.callPostContactAPI(contactModel: contactModel)
    }
    
    
    //call Post Contact API to save contact data to server
    private func callPostContactAPI(contactModel:ContactModel){
     
        let manager = AFHTTPSessionManager()
        
        let url = "\(Constants.Url.baseURL)\(Constants.Url.postContacts)"
        let parameters : [String:AnyObject] = ["id": 5 as AnyObject,
                                               "first_name": contactModel.first_name as AnyObject,
                                               "last_name": contactModel.last_name as AnyObject,
                                               "email": contactModel.email as AnyObject,
                                               "phone_number": contactModel.phone_number as AnyObject,
                                               "profile_pic": contactModel.profile_pic as AnyObject,
                                               "favorite": false as AnyObject,
                                               "created_at": "2016-05-29T10:10:10.995Z" as AnyObject,
                                               "updated_at": "2016-05-29T10:10:10.995Z" as AnyObject] as [String : AnyObject]
        print(parameters)
        
        let requestSerializer = AFJSONRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer = requestSerializer
        
        
        manager.post(url, parameters: parameters, progress: { (progress) in
            
        }, success: { (operation, response) in
            print(response)
            self.delegate?.saveContactDataSuccess()
        }) { (operation, error) in
            print(error.localizedDescription)
            self.delegate?.saveContactDataFailure(message: "")
        }

    }
    
    //check given number is valid or not
    public func isValidMobileNumber(phoneNum:String)->Bool{
        if phoneNum == ""{
            return false
        }
        let characterset = CharacterSet(charactersIn: "0123456789")
        if phoneNum.rangeOfCharacter(from: characterset) != nil {
            print(phoneNum)
            
            if phoneNum.characters.count > 10{
                if phoneNum.hasPrefix("099") || phoneNum.hasPrefix("99") || phoneNum.hasPrefix("+91"){
                    return true
                }else{
                    return false
                }
            }else{
                if phoneNum.characters.count == 10{
                    return true
                }else{
                    return false
                }
            }
            
        }else{
            return false
        }

    }
    
    //check given email id is valid or not
    public func isValidateEmail (_ email : String) -> (Bool){
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        if email == "" {
            return false
        }
        
        return (predicate.evaluate(with: email))
    }

    
}
