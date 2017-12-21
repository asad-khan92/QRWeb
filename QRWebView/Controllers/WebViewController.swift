//
//  ViewController.swift
//  QRWebView
//
//  Created by Asad Khan on 12/13/17.
//  Copyright © 2017 Asad Khan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate,WKNavigationDelegate {

    @IBOutlet weak var errorView: UIView!
    
     var webView: WKWebView!
     var navigation : WKNavigation!
     var destController : QRScannerController!
     var userController : WKUserContentController!
     var currentURL : URL!
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrScanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        
        
        userController = WKUserContentController.init()
        let cookieScript = WKUserScript.init(source: "document.cookie = 'device_uuid=\(appDelegate.uniqueIdentifier!)';", injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userController.addUserScript(cookieScript)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
       
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        currentURL = URL(string: Constants.URL.initialURL)!
        loadRequest(url:currentURL)
        
        self.view.bringSubview(toFront: qrScanButton)
        self.view.bringSubview(toFront: qrImageView)
        // bring this view to front, it is hidden so won't show untill an error occured
        self.view.bringSubview(toFront: self.errorView)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.bounces = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         destController = segue.destination as! QRScannerController
         destController.delegate = self
    }
    
    func loadRequest(url:URL){
        
        let myRequest = NSMutableURLRequest.init(url: url)
        navigation = webView.load(myRequest as URLRequest)
    }
    @IBAction func refreshWebView(_ sender: Any) {
        loadRequest(url: currentURL)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        print(error.localizedDescription)
       self.errorView.isHidden = false
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        print(error.localizedDescription)
         self.errorView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if let urlResponse = navigationResponse.response as? HTTPURLResponse
        {
            if urlResponse.statusCode != 200{
                 self.errorView.isHidden = false
                decisionHandler(.cancel)
                return
            }else{
                 self.errorView.isHidden = true
                decisionHandler(.allow)
                return
            }
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let failingUrlStr = "\(navigationAction.request.url!)"
        
        let failingUrl = navigationAction.request.url!
        
        switch  failingUrl{
        // Needed to open Facebook
        case _ where failingUrlStr.starts(with: "fb:"):
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(failingUrl, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            } // Else: Do nothing, iOS 9 and earlier will handle this
            
        // Needed to open Mail-app
        case _ where failingUrlStr.starts(with: "mailto:"):
            if UIApplication.shared.canOpenURL(failingUrl) {
                UIApplication.shared.openURL(failingUrl)
                decisionHandler(.cancel)
            }
            
        // Needed to open Appstore-App
        case _ where failingUrlStr.starts(with: "itmss://itunes.apple.com/"):
            if UIApplication.shared.canOpenURL(failingUrl) {
                UIApplication.shared.openURL(failingUrl)
                decisionHandler(.cancel)
            }
            
        // Needed to open WhatsApp
        case _ where failingUrlStr.starts(with: "whatsapp:"):
            if UIApplication.shared.canOpenURL(failingUrl) {
                UIApplication.shared.openURL(failingUrl)
                decisionHandler(.cancel)
            }
        // Needed to open WhatsApp
        case _ where failingUrlStr.starts(with: "https://goo.gl/maps"):
            if UIApplication.shared.canOpenURL(failingUrl) {
                UIApplication.shared.openURL(failingUrl)
                decisionHandler(.cancel)
            }
            
        default:
            decisionHandler(.allow)
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

}

extension WebViewController : UIScrollViewDelegate{
    
    // Disable zooming in webView
    func viewForZooming(in: UIScrollView) -> UIView? {
        return nil;
    }
}

extension WebViewController :QRScannerProtocol{
    
    func loadQR(url: String) {
        destController.delegate = nil
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        let cookieScript = WKUserScript.init(source: "document.cookie = 'device_uuid=\(appDelegate.uniqueIdentifier!)';", injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userController.addUserScript(cookieScript)
        webView.stopLoading()
        webView.load(myRequest)
        currentURL = myURL
        print(url)

        
    }
}
