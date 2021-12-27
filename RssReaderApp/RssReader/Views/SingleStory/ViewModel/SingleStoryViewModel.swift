//
//  SingleStoryViewModel.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 26.12.2021..
//

import Foundation
import WebKit
protocol SingleStoryViewModel: AnyObject {
    var url: String {get set}
    
    func loadWeb(_: WKWebView)
}

class SingleStoryViewModelImpl: SingleStoryViewModel {
    
    var url: String
    
    init(url: String) {
        self.url = url
    }
    
    func loadWeb(_ view: WKWebView) {
        if let webUrl = URL(string: self.url) {
            let request = URLRequest(url: webUrl)
            view.load(request)
        }
    }
}
