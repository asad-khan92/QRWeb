//
//  URLRequestExtension.swift
//  QRWebView
//
//  Created by Asad Khan on 12/19/17.
//  Copyright © 2017 Asad Khan. All rights reserved.
//

import Foundation

//extension NSMutableURLRequest {
//    
//    /// Percent escape
//    ///
//    /// Percent escape in conformance with W3C HTML spec:
//    ///
//    /// See http://www.w3.org/TR/html5/forms.html#application/x-www-form-urlencoded-encoding-algorithm
//    ///
//    /// - parameter string:   The string to be percent escaped.
//    /// - returns:            Returns percent-escaped string.
//    
//    private func percentEscapeString(string: String) -> String {
//        let characterSet = NSCharacterSet.alphanumerics as! NSMutableCharacterSet
//        characterSet.addCharacters(in: "-._* ")
//        
//        return string.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)!.replacingOccurrences(of: " ", with: "+")
//    }
//    
//    /// Encode the parameters for `application/x-www-form-urlencoded` request
//    ///
//    /// - parameter parameters:   A dictionary of string values to be encoded in POST request
//    
//    func encodeParameters(parameters: [String : String]) {
//        httpMethod = "POST"
//        
//        let parameterArray = parameters.map { (arg) -> String in
//            
//            let (key, value) = arg
//            return "\(key)=\(self.percentEscapeString(string: value))"
//        }
//        
//        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
//    }
//}
//
//let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//config.HTTPAdditionalHeaders = [
//    "Accept" : "application/json",
//    "Content-Type" : "application/x-www-form-urlencoded"
//]
//
//let session = NSURLSession(configuration: config)
//
//let request = NSMutableURLRequest(URL: NSURL(string:"https://XXXXX.com/mobile-helper.jsp")!)
//request.encodeParameters(["name" : "user.name@not.local", "passwd":"Passwd123"])
//
//let task = session.dataTaskWithRequest(request) { data, response, error in
//    guard error == nil && data != nil else {
//        print(error)
//        return
//    }
//    print(JSON(data:data!))
//}
//task.resume()

