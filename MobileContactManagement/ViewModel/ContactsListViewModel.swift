//
//  ContactsListViewModel.swift
//  ContactManagementApp
//
//  Created by Archita Bansal on 1/25/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import UIKit
import AFNetworking

public protocol ContactListViewModelDelegate: class {
    func getContactsSuccess()
    func getContactsFailure(message:String)
    func addContactPressed()
    
}
class ContactsListViewModel: NSObject {
    
    public var contacts = [Contact]()
    public var title = "Contact Book"
    public var addContactBarButton = UIBarButtonItem()
    public var delegate: ContactListViewModelDelegate?
    
    // new initializer
    public init(delegate: ContactListViewModelDelegate) {
        self.delegate = delegate
        super.init()
        self.addNavigationBarButton()
        getContacts()
        
    }
    
    //Add right navigation bar button
    func addNavigationBarButton(){
        self.addContactBarButton = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(self.onAddContact))
        addContactBarButton.setTitleTextAttributes( [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15)!], for: UIControlState.normal)
    }

    func onAddContact(){
        
        self.delegate?.addContactPressed()
        
    }
    
    //call get contacts API
    private func getContacts(){
        let manager = AFHTTPSessionManager()
        let url = "\(Constants.Url.baseURL)\(Constants.Url.getContacts)"
        
        manager.get(url,parameters: nil,
            success:
            {
                (operation, responseObject) in
                
                print(responseObject as! NSArray)
                self.saveContactsToDB(contactData: responseObject as! NSArray)
                DispatchQueue.main.async {
                    if (responseObject as! NSArray).count > 0{
                        self.delegate?.getContactsSuccess()
                    }else{
                        self.delegate?.getContactsFailure(message: "No contacts found")
                    }
                }
            },
            failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
                self.delegate?.getContactsFailure(message: "Not able to connect to Server")
        })
    }
    
    //save contacts response from server to CoreData
    private func saveContactsToDB(contactData:NSArray){
        if contactData.count > 0{
            for contDict in contactData{
                ContactAdapter.contactAdapterSharedInstance.saveContact(id: (contDict as! NSDictionary).value(forKey: "id") as! Int, firstName: (contDict as! NSDictionary).value(forKey: "first_name") as! String, lastName: (contDict as! NSDictionary).value(forKey: "last_name") as! String, profilePic: (contDict as! NSDictionary).value(forKey: "profile_pic") as! String, url: (contDict as! NSDictionary).value(forKey: "url") as! String)
            }
        }
    }
    
    //retrive contacts from DB and assign to contacts array in alphabeticaally order
    public func fetchContacts(){
        if let contacts = ContactAdapter.contactAdapterSharedInstance.getContacts(){
            self.contacts = contacts.sorted { $0.firstName! < $1.firstName! }
            
        }
    }
   
}
