//
//  APICaller.swift
//  QRWebView
//
//  Created by Asad Khan on 12/19/17.
//  Copyright © 2017 Asad Khan. All rights reserved.
//

import Foundation
import Contacts

enum Result<T> {
    case Success(T)
    case Failure(Error)
}
struct APICaller{
    
    
    func upload(contacts:[String], uuid:String)  {
        
        let arrayOfSubArray =  contacts.chunked(by: 200)
        for array in arrayOfSubArray{
            var dict = [String:String]()
            dict["contact_data"] = array.flatMap({$0}).joined(separator: ",")
           
                post(contacts:dict , url: Constants.URL.contactPostURL + uuid, completionHandler: { (result) in
                
                    switch result {
                        
                    case .Success(let success):
                        print(success)
                    case .Failure(let error):
                        print(error)
                    }
            })
        }
    }
    private func percentEscapeString(string: String) -> String {
        let characterSet = NSCharacterSet.alphanumerics as! NSMutableCharacterSet
        characterSet.addCharacters(in: "-._* ")
        
        return string.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)!.replacingOccurrences(of: " ", with: "+")
    }
    
    
    private func post(contacts : [String:String], url : String ,completionHandler: @escaping (Result<NSDictionary> ) -> Void) {
        
        var request = URLRequest.init(url: URL.init(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        
        
        let parameterArray = contacts.map { (arg) -> String in
            
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(string: value ))"
        }
        
        request.httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       let task = session.dataTask(with: request) { (data, response, error) in
        
        
        if let error = error as? NSError, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
            
            completionHandler(.Failure(error))
            return
        }
        
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                completionHandler(.Failure(error!))
                return
            }
        
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completionHandler(.Failure(error!))
                return
            }
        
        print("Response: \(String(describing: response))")
        let strData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print("Body: \(strData ?? "")")
            var json : NSDictionary?
        do {
                 json = try JSONSerialization.jsonObject(with: data, options: [.mutableLeaves]) as? NSDictionary
        }catch{
            print("Unable to parse json")
        }
            // JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(error != nil) {
                print(error!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: '\(String(describing: jsonStr))'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    let success = parseJSON["success"] as? Int
                     completionHandler(.Success(parseJSON))
                    print("Succes: \(String(describing: success))")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: \(String(describing: jsonStr))")
                }
       
            }
       
        }

        task.resume()
    }
}
