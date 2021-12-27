//
//  SingleStoryViewController.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 26.12.2021..
//

import Foundation
import UIKit
import WebKit
class SingleStoryViewController: UIViewController, WKUIDelegate {
    
    let webView: WKWebView = {
        let wView = WKWebView()
        return wView
    }()
    
    let viewModel: SingleStoryViewModel
    
    init(viewModel: SingleStoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebView()
        viewModel.loadWeb(webView)
    }
}

private extension SingleStoryViewController {
    
    func setupUI(){
        view.backgroundColor = .white
    }
    
    func setupWebView(){
        webView.frame = .zero
        webView.uiDelegate = self
    }
}
