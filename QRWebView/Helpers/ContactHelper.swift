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


enum ContactResult {
    case Granted([CNContact])
    case Other(String)
}
class Contact {
    
    var completion : ((ContactResult) -> Void)?
    var contactStore : CNContactStore
    var authorizationStatus : CNAuthorizationStatus
    
    public init(){
         contactStore = CNContactStore()
         authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    }
    
  
    func getAllContacts(completionHandler:@escaping (ContactResult) -> Void)  {
        
         completion = completionHandler
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
            
        }
        
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
                    if contact.imageData != nil {
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
        completion?(.Granted(cnContacts))
        NSLog(">>>> Contact list:")
        for contact in cnContacts {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            NSLog("\(fullName): \(contact.phoneNumbers.description)")
        }
       // self.tableView.reloadData()
    }
}
