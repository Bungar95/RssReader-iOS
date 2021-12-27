//
//  HomeViewModel.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 24.12.2021..
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeViewModel: AnyObject {
    
    var categories: [Category] {get}
    var loaderSubject: ReplaySubject<Bool> {get}
}

class HomeViewModelImpl: HomeViewModel {
    
    var categories: [Category]
    var loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    
    init(rssRepository: RssRepository) {
        self.categories = rssRepository.prepopulateCategories()
    }
    
}
