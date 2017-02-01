//
//  AddContactViewController.swift
//  ContactManagementApp
//
//  Created by Archita Bansal on 1/25/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class AddContactViewController: BaseClassViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var postActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var outletSaveBtn: UIButton!
    
    var viewModel : AddContactViewModel!
    var profilePicUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        //Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @IBAction func onSave(_ sender: UIButton) {
        let contact = ContactModel()
        contact.first_name = self.txtFirstName.text
        contact.last_name = self.txtLastName.text
        contact.profile_pic = self.profilePicUrl
        contact.phone_number = self.txtMobileNumber.text
        contact.email = self.txtEmailAddress.text
        self.handlePostCall()
        self.viewModel.saveContact(contactModel: contact)
    }
    

   
    //UI Setup
    func configureUI(){
     
        self.view.backgroundColor = Constants.Color.lightGreyBgColor
        self.navigationItem.title = self.viewModel.title
        
        self.profileImageView.backgroundColor = Constants.Color.profileImageViewBgColor
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.layer.cornerRadius = 40.0
        self.profileImageView.layer.masksToBounds = true
        
        self.txtFirstName.backgroundColor = UIColor.clear
        self.txtLastName.backgroundColor = UIColor.clear
        self.txtEmailAddress.backgroundColor = UIColor.clear
        self.txtMobileNumber.backgroundColor = UIColor.clear
        
        self.outletSaveBtn.backgroundColor = Constants.Color.darkGreenBtn
        self.outletSaveBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.postActivityIndicator.hidesWhenStopped = true
        self.postActivityIndicator.stopAnimating()
        
        self.contentView.backgroundColor = Constants.Color.lightGreyBgColor
        self.scrollView.backgroundColor = Constants.Color.lightGreyBgColor
        
        //scrollview contentinset initially set to zero
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
        
        //set textfield delegates
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmailAddress.delegate = self
        self.txtMobileNumber.delegate = self
        
        //imageview tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(createActionSheet))
        tap.numberOfTapsRequired = 1
        self.profileImageView.addGestureRecognizer(tap)
        
        //view tap gesture
        let tapBg: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesture))
        tapBg.delegate = self
        
        self.view.addGestureRecognizer(tapBg)
        
    }
    
    //MARK: KEYBOARD METHODS
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }

    /**
     After post call disable UI User Interaction and start activity indicator
   */
    func handlePostCall(){
        
        self.postActivityIndicator.startAnimating()
        self.outletSaveBtn.isUserInteractionEnabled = false
        self.outletSaveBtn.setTitleColor(UIColor.white.withAlphaComponent(0.40), for: .normal)
        self.txtMobileNumber.isUserInteractionEnabled = false
        self.txtFirstName.isUserInteractionEnabled = false
        self.txtLastName.isUserInteractionEnabled = false
        self.txtEmailAddress.isUserInteractionEnabled = false
        
    }
    
    /**
     After post call completion enable UI User Interaction and stop activity indicator
     */
    
    func handlePostCallCompletion(){
        
        self.postActivityIndicator.stopAnimating()
        self.outletSaveBtn.isUserInteractionEnabled = true
        self.outletSaveBtn.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        self.txtMobileNumber.isUserInteractionEnabled = true
        self.txtFirstName.isUserInteractionEnabled = true
        self.txtLastName.isUserInteractionEnabled = true
        self.txtEmailAddress.isUserInteractionEnabled = true
        
    }
    

}
extension AddContactViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
}
extension AddContactViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate{
    
    // UIGESTURE METHODS
    
    func tapGesture(){
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !((touch.view?.isKind(of: UITextField.self))!)
    }
    
    
    // ACTION SHEET
    
    func createActionSheet(){
        self.view.endEditing(true)
        //  pickerCancelSelected()
        var alertControl = UIAlertController()

        alertControl = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("cancel")
        }
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (UIAlertAction) in
            print("takePH")
            self.cameraTapped()
        }
        
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { (UIAlertAction) in
            print("choosePH")
            self.galleryTapped()
        }
        
        alertControl.addAction(cancelButton)
        alertControl.addAction(takePhoto)
        alertControl.addAction(choosePhoto)
        
        self.present(alertControl, animated: true, completion: nil)
    }
    
    //If user selects Gallery from action sheet
    func galleryTapped(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing=true
        picker.sourceType=UIImagePickerControllerSourceType.photoLibrary
        self.present(picker,animated:true,completion: nil)
    }
    
    //If user selects camera from action sheet
    func cameraTapped(){
        
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let authStatus =  AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            
            switch authStatus{
            case AVAuthorizationStatus.authorized :
                //allowed access
                if UIImagePickerController.isSourceTypeAvailable(
                    UIImagePickerControllerSourceType.camera) {
                    setUpAndPresentCameraView()
                }
            case AVAuthorizationStatus.notDetermined :
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
                    result in
                    if result{
                        self.setUpAndPresentCameraView()
                    }else{
                        self.showCameraEnableMessage()
                    }
                })
            case .denied:
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
                    result in
                    if result{
                        self.setUpAndPresentCameraView()
                    }else{
                        self.showCameraEnableMessage()
                    }
                })
                
            default :
                self.showCameraEnableMessage()
                //ask to allow access
            }
        }
        else
        {
            //p("Camera Not Availble")
            showCameraEnableMessage()
        }
        
        
    }
    
    func showPhotosEnableMessage(){
        DispatchQueue.main.async{
             CommonUtility.showAlert("", message: "Enable Photos Access for this App in Settings->Privacy->Camera")
        }
    }
    
    func showCameraEnableMessage(){
        DispatchQueue.main.async(execute: {
            CommonUtility.showAlert("", message: "Enable Camera Access for this App in Settings->Privacy->Camera")
        })
    }
    
    
    func setUpAndPresentCameraView(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing=true
        picker.sourceType=UIImagePickerControllerSourceType.camera
        
        self.present(picker,animated:true,completion: nil)
    }
    
    //Delegate method for imagePicker when user selects image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // let uploadFileURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        //
        //        //getting actual image
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let data = UIImagePNGRepresentation(image)
        
        //     let imageName = uploadFileURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        
        // getting local path
        let localPath = (documentDirectory as NSString).appendingPathComponent("profile")
        
        
        try? data!.write(to: URL(fileURLWithPath: localPath), options: [.atomic])
        
        self.profilePicUrl = localPath
        
        DispatchQueue.main.async(execute: {
            
            self.profileImageView.image = UIImage(contentsOfFile: localPath)
            self.profileImageView.contentMode = .scaleAspectFit
            
        })
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
extension AddContactViewController:AddContactViewModelDelegate{
    
    //MARK: ADDCONTACTVIEWMODEL DELEGATE METHODS
    func saveContactDataSuccess() {
        self.handlePostCallCompletion()
        CommonUtility.showAlert("", message: "User successfully added")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func saveContactDataFailure(message: String) {
        self.handlePostCallCompletion()
        CommonUtility.showAlert("", message: message)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showInvalidName() {
        CommonUtility.showAlert("", message: "First name is not valid")
    }
    
    func showInvalidEmailAddress() {
       CommonUtility.showAlert("", message: "Email Address not valid")
    }
    
    func showInvalidMobile() {
       CommonUtility.showAlert("", message: "Mobile Phone Number not valid")
    }
}
