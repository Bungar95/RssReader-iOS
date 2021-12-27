//
//  RssRepository.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 24.12.2021..
//

import Foundation
import RxSwift
class RssRepositoryImpl: RssRepository {
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getNews(endpoint: String) -> Observable<RssResponse> {
        let url = "https://www.24sata.hr/feeds/\(endpoint).xml"
        let newsResponseObservable: Observable<RssResponse> = networkManager.getData(from: url)
        return newsResponseObservable
    }
    
    func prepopulateCategories() -> [Category] {
        return [
            Category(name: "Aktualno", urlExt: "aktualno"),
            Category(name: "Najnovije", urlExt: "najnovije"),
            Category(name: "News", urlExt: "news"),
            Category(name: "Show", urlExt: "show"),
            Category(name: "Sport", urlExt: "sport"),
            Category(name: "Lifestyle", urlExt: "lifestyle"),
            Category(name: "Tech", urlExt: "tech"),
            Category(name: "Viral", urlExt: "fun")
        ]
    }
    
    func saveStories(stories: [Item], category: String) {
        UserDefaults.standard.save(stories, category: category)
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "\(category)Date")
    }
    
    func loadStories(category: String) -> [Item] {
        return UserDefaults.standard.load(category: category)
    }
}

protocol RssRepository: AnyObject {
    func getNews(endpoint: String) -> Observable<RssResponse>
    func prepopulateCategories() -> [Category]
    func saveStories(stories: [Item], category: String)
    func loadStories(category: String) -> [Item]
}
