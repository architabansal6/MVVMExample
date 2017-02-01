//
//  ContactsListViewController.swift
//  ContactManagementApp
//
//  Created by Archita Bansal on 1/25/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import UIKit

class ContactsListViewController: BaseClassViewController {

    @IBOutlet weak var contactsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contactsTableView: UITableView!
    var viewModel : ContactsListViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.viewModel?.fetchContacts()
        //Set Delegates
        self.contactsTableView.dataSource = self
        self.contactsTableView.delegate = self
    }

    //Setup UI
    func configureUI(){
        self.view.backgroundColor = Constants.Color.lightGreyBgColor
        self.navigationItem.title = self.viewModel?.title
        self.navigationItem.rightBarButtonItem = self.viewModel?.addContactBarButton
        self.contactsTableView.rowHeight = 65.0
        self.contactsTableView.backgroundColor = Constants.Color.lightGreyBgColor
        self.contactsActivityIndicator.hidesWhenStopped = true

        if viewModel?.contacts.count == 0{
            //UI for fetching contacts
            self.contactsTableView.isHidden = true
            self.contactsActivityIndicator.startAnimating()
        }else{
            self.contactsTableView.isHidden = false
            self.contactsActivityIndicator.stopAnimating()
        }
       
    }
    
        
}
extension ContactsListViewController : ContactListViewModelDelegate{
   
    //MARK: CONTACTLISTMODEL DELEGATE METHODS
    func getContactsSuccess() {
        
        self.contactsActivityIndicator.stopAnimating()
        self.contactsTableView.isHidden = false
        self.viewModel?.fetchContacts()
        self.contactsTableView.reloadData()
        
    }
    
    func getContactsFailure(message: String) {
        
        self.contactsActivityIndicator.stopAnimating()
        CommonUtility.showAlert("", message: message)
        
    }
    
    func addContactPressed() {
        
        let controller = UIStoryboard(name: "Contacts", bundle: nil).instantiateViewController(withIdentifier: "addContact") as! AddContactViewController
        controller.viewModel = AddContactViewModel(delegate: controller)
        self.navigationController?.pushViewController(controller, animated: true)

        
    }
    
    
}
extension ContactsListViewController:UITableViewDataSource,UITableViewDelegate{
    
    //MARK: TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel?.contacts.count)!
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = Constants.Color.lightGreyBgColor
        cell.textLabel?.text = "\(self.viewModel!.contacts[indexPath.row].firstName!) \(self.viewModel!.contacts[indexPath.row].lastName!)"
        cell.indentationLevel = Int(7.0)
        
        //create imageview
        let imageView = UIImageView(frame: CGRect(x: 20, y: 14, width: 36, height: 36))
        imageView.layer.cornerRadius = 18.0
        imageView.backgroundColor = Constants.Color.profileImageViewBgColor
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "UserDefaultIcon")
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = UIStoryboard(name: "Contacts", bundle: nil).instantiateViewController(withIdentifier: "contactsDetail") as! ContactDetailController
        
        controller.viewModel = ContactDetailViewModel(delegate: controller)
        controller.viewModel.selectedContact = self.viewModel?.contacts[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
