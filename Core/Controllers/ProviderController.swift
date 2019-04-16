//
//  WebViewController.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class ProviderController: UINavigationController {
    
    var request: URLRequest!
    var redirectUri: String!
    var completion: WebRequestService.Completion!
    
    private let cancelButtonTitle = "Cancel"
    
    private var webView: UIWebView!
    private var webViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        configureWebViewController()
        
        pushViewController(webViewController, animated: false)
    }
    
    private func configureWebView() {
        webView = UIWebView(frame: view.bounds)
        webView.delegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.loadRequest(request)
    }
    
    private func configureWebViewController() {
        webViewController = UIViewController()
        webViewController.view.frame = view.bounds
        webViewController.title = title
        
        webViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: cancelButtonTitle,
                                                                             style: .plain,
                                                                             target: self,
                                                                             action: #selector(cancel))
        
        webViewController.view.addSubview(webView)
    }
    
    func complete(withUrl url: URL?, error: AuthorizeError?) {
        dismiss(animated: true)
        completion(url, error)
    }
    
    @objc func cancel() {
        complete(withUrl: nil, error: AuthorizeError.cancel)
    }
    
}

extension ProviderController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebView.NavigationType) -> Bool {
        
        guard let url = request.url, url.absoluteString.hasPrefix(redirectUri) else {
            return true
        }
        
        complete(withUrl: url, error: nil)
        return false
    }

}
