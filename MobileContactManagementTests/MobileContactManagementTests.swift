//
//  MobileContactManagementTests.swift
//  MobileContactManagementTests
//
//  Created by Archita Bansal on 1/29/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import XCTest
@testable import MobileContactManagement

class MobileContactManagementTests: XCTestCase {
    var vc : AddContactViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in
        vc = UIStoryboard(name: "Contacts", bundle: nil).instantiateViewController(withIdentifier: "addContact") as! AddContactViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        
        
        // Initialize Profile View Model
        let addContactViewModel = AddContactViewModel(delegate: vc)
        
        XCTAssertNotNil(addContactViewModel, "The add contact view model should not be nil.")
    }
    
    func testValidPhoneNumber(){
     
        let controller = UIStoryboard(name: "Contacts", bundle: nil).instantiateViewController(withIdentifier: "addContact") as! AddContactViewController
        
        // Initialize Profile View Model
        let addContactViewModel = AddContactViewModel(delegate: controller)
        let isValid = addContactViewModel.isValidateEmail("abc@abc.com")
        XCTAssert(isValid == true)
    }
    
}
