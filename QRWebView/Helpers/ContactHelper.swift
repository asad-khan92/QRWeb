//
//  ContactHelper.swift
//  QRWebView
//
//  Created by Asad Khan on 12/14/17.
//  Copyright © 2017 Asad Khan. All rights reserved.
//

import Foundation
import AddressBook
import Contacts


struct Contact {
    
     var contactStore = CNContactStore()
     let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    
    
    func checkIfAllowed()-> Bool{
        
        
        switch authorizationStatus {
        case .denied, .restricted,.notDetermined:
            //1
            contactStore.requestAccess(for: .contacts) { (access, accessError) in
                
                if access {
                    //completionHandler(accessGranted: access)
                    self.retrieveContactsWithStore(store: self.contactStore)
                }
                else {
                    if self.authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async {
                           let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            
                            print(message)
                        }
                        
                    }
                }
                
            }
                
        case .authorized:
            //2
            print("Authorized")
            retrieveContactsWithStore(store: contactStore)
            return true
        }
        
        return false
    }
    func getAllContacts()  {
        
         let _ = checkIfAllowed()
        //retrieveContactsWithStore(store: contactStore)
        
    }
    
    func retrieveContactsWithStore(store: CNContactStore)
    {
        
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey,CNContactImageDataKey, CNContactEmailAddressesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        var cnContacts = [CNContact]()
        do {
            try store.enumerateContacts(with: request){
                (contact, cursor) -> Void in
                if (!contact.phoneNumbers.isEmpty) {
                }
                
                if contact.isKeyAvailable(CNContactImageDataKey) {
                    if let contactImageData = contact.imageData {
                      //  print(UIImage(data: contactImageData)) // Print the image set on the contact
                    }
                } else {
                    // No Image available
                    
                }
                if (!contact.emailAddresses.isEmpty) {
                }
                cnContacts.append(contact)
                //self.objects = cnContacts
            }
        } catch let error {
            NSLog("Fetch contact error: \(error)")
        }
        
        NSLog(">>>> Contact list:")
        for contact in cnContacts {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            NSLog("\(fullName): \(contact.phoneNumbers.description)")
        }
       // self.tableView.reloadData()
    }
}
