//
//  URLViewController.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit
import WebKit

class URLViewController: UIViewController, WKNavigationDelegate {
    var contentWebView = WKWebView(frame: .zero)
    
    var url: URL?
    
    convenience init(withURL url: URL, largeTitle: String?) {
        self.init()
        self.url = URL(string: "https://files.fm/")! //url
        title = largeTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        contentWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentWebView)
        contentWebView.navigationDelegate = self
        // Do any additional setup after loading the view.
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUrl()
    }
    
    func addConstraints() {
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[webView]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["webView": contentWebView])
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[webView]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["webView": contentWebView])
        let allConstraints = verticalConstraint+horizontalConstraint
        
        view.addConstraints(allConstraints)
    }
    
    func loadUrl() {
        guard let urlToLoad = url else {
            return
        }
        let request = URLRequest(url: urlToLoad)
        contentWebView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
     
        decisionHandler(.allow)
    }
}
