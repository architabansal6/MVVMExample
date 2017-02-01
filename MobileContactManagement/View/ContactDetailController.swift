//
//  ContactDetailController.swift
//  ContactManagementApp
//
//  Created by Archita Bansal on 1/25/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import UIKit

class ContactDetailController: BaseClassViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var outletMobileNumberCallBtn: UIButton!
    @IBOutlet weak var outletEmailBtn: UIButton!
    
    var viewModel : ContactDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.viewModel.getSelectedContactData()
    }
    
    //Setup UI
    func configureUI(){
        
        self.view.backgroundColor = Constants.Color.lightGreyBgColor

        self.navigationItem.title = self.viewModel?.title
        self.imageView.layer.cornerRadius = 40.0
        self.imageView.layer.masksToBounds = true
        self.imageView.backgroundColor = UIColor.gray
        self.imageView.contentMode = .scaleAspectFit
        
        self.fullNameLabel.text = "\(self.viewModel.selectedContact!.firstName!) \(self.viewModel.selectedContact!.lastName!)"
        self.outletMobileNumberCallBtn.setTitle(self.viewModel.selectedContact?.mobileNumber, for: .normal)
        self.outletEmailBtn.setTitle(self.viewModel.selectedContact?.email, for: .normal)
        if let url = URL(string: (self.viewModel.selectedContact?.profilePic)!) {
            //if contact has profile pic url
            if let data = try? Data(contentsOf: url){
                self.imageView.image = UIImage(data: data)
                self.imageView.contentMode = UIViewContentMode.scaleAspectFit
            }else{
                self.imageView.image = UIImage(named: "UserDefaultIcon")
            }
        }
        
    }
    
    //set mobile number and email after getting from server
    func refresh(){
        self.outletMobileNumberCallBtn.setTitle(self.viewModel.selectedContact?.mobileNumber, for: .normal)
        self.outletEmailBtn.setTitle(self.viewModel.selectedContact?.email, for: .normal)
    }

    @IBAction func onCallMobileNumber(_ sender: UIButton) {
        self.viewModel.onCall()
    }
    
    
    @IBAction func onSendEmail(_ sender: UIButton) {
        self.viewModel.onSendEmail(viewController: self)
    }
    
}
extension ContactDetailController:ContactDetailViewModelDelegate{
    func getContactDataSuccess() {
        self.refresh()
    }
    
    func getContactDataFailure(message: String) {
        
    }
}
