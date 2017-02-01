//
//  ContactDetailViewModel.swift
//  ContactManagementApp
//
//  Created by Archita Bansal on 1/25/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import UIKit
import MessageUI
import AFNetworking

public protocol ContactDetailViewModelDelegate: class {
    func getContactDataSuccess()
    func getContactDataFailure(message:String)
}

class ContactDetailViewModel: NSObject {

    public var selectedContact: Contact?
    public var title = "Detail"
    public var delegate: ContactDetailViewModelDelegate?

    // new initializer
    public init(delegate: ContactDetailViewModelDelegate) {
        self.delegate = delegate
        super.init()
        
    }
    
    //call get contact details if mobile or email is not present for selected contact
    public func getSelectedContactData(){
        if selectedContact?.mobileNumber == nil || selectedContact?.email == nil{
            self.getContactDetails()
        }
    }
    
    //get contact detail API call
    private func getContactDetails(){
        let manager = AFHTTPSessionManager()
        manager.get(self.selectedContact!.contactUrl!,parameters: nil,
        success:
            {(operation, responseObject) in
                print(responseObject as! NSDictionary)
                self.saveContactDataToDB(contactData: responseObject as! NSDictionary)
                DispatchQueue.main.async {
                    self.delegate?.getContactDataSuccess()
            }
        },
        failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
                self.delegate?.getContactDataFailure(message: "Not able to connect to Server")
        })
    }

    //Save Contact detail got from server to DB
    private func saveContactDataToDB(contactData:NSDictionary){
        ContactAdapter.contactAdapterSharedInstance.saveContactDataById(id: contactData.value(forKey: "id") as! Int, mobile: contactData.value(forKey: "phone_number") as! String, email: contactData.value(forKey: "email") as! String)
        
    }

    
    //handle call action
    public func onCall(){
        if selectedContact?.mobileNumber != nil{
            if let phoneCallURL:NSURL = NSURL(string: "tel://\(selectedContact!.mobileNumber!)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL as URL)) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(phoneCallURL as URL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(phoneCallURL as URL)
                    }
                }
            }
        }
        
    }
    
    //handle send email action
    public func onSendEmail(viewController:UIViewController){
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.setSubject("Contact")
            if selectedContact?.email != nil{
                composeVC.setToRecipients([self.selectedContact!.email!])
            }
            
            
            // Present the view controller modally.

            viewController.present(composeVC, animated: true, completion: nil)
        }

    }
    
}
extension ContactDetailViewModel:MFMailComposeViewControllerDelegate{
    //MFMAILCOMPOSE DELEGATES
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
