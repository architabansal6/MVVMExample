//
//  Contact+CoreDataProperties.swift
//  MobileContactManagement
//
//  Created by Archita Bansal on 1/30/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact");
    }

    @NSManaged public var contactId: Int32
    @NSManaged public var contactUrl: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var profilePic: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var email: String?
    

}
