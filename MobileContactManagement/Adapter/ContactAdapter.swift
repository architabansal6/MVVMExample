//
//  ContactAdapter.swift
//  MobileContactManagement
//
//  Created by Archita Bansal on 1/29/17.
//  Copyright © 2017 architabansal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ContactAdapter: NSObject {
    
    static let contactAdapterSharedInstance = ContactAdapter()

    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //Save Contact
    func insertContact(){
        let context = getContext()
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    //Save Contact Entity to DB
    func saveContact (id:Int,firstName:String, lastName: String,profilePic:String,url:String) {
        
        if self.getContactForId(id: id) != nil{
            print("contact with id \(id) already exist")
            return
        }
        
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Contact", in: context)
        
        let contact = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        contact.setValue(id, forKey: "contactId")
        contact.setValue(firstName, forKey: "firstName")
        contact.setValue(lastName, forKey: "lastName")
        contact.setValue(profilePic, forKey: "profilePic")
        contact.setValue(url, forKey: "contactUrl")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    //get contact be given id then save other data for it if found
    func saveContactDataById(id:Int,mobile:String,email:String){
        if let contact = self.getContactForId(id: id){
            contact.mobileNumber = mobile
            contact.email = email
            self.insertContact()
        }else{
            print("contact id not there")
        }
    }
    
    //returns contact for given id
    func getContactForId(id:Int)->Contact?{
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()

        let predicate_id:NSPredicate = NSPredicate(format: "contactId == \(id)")
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[predicate_id])
        
        fetchRequest.predicate = compound
        do{
            let syncDatas = try getContext().fetch(fetchRequest) as NSArray?
            
            if (syncDatas?.count)! > 0 {
                return syncDatas?.lastObject as? Contact
            }
        }
        catch{}
        return nil
    }
    
    //return array of contacts/all the contacts saved in DB
    func getContacts()->[Contact]?{
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest() 
        
        do {
            //get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            print ("num of results = \(searchResults.count)")
            if searchResults.count > 0{
                return searchResults
            }else{
                return nil
            }
        } catch {
            print("Error with request: \(error)")
            return nil
        }
    }
    
}
