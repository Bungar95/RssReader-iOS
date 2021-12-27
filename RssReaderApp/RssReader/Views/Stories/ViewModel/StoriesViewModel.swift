//
//  StoriesViewModel.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 24.12.2021..
//

import Foundation
import RxCocoa
import RxSwift

protocol StoriesViewModel: AnyObject {
    
    var endpoint: String {get}
    
    var rssDataRelay: BehaviorRelay<[Item]> {get}
    var loaderSubject: ReplaySubject<Bool> {get}
    var loadRemoteRSSDataSubject: ReplaySubject<()> {get}
    
    func initializeViewModelObservables() -> [Disposable]
    func fetchData()
}

class StoriesViewModelImpl: StoriesViewModel {
    
    var rssDataRelay = BehaviorRelay<[Item]>.init(value: [])
    var loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var loadRemoteRSSDataSubject = ReplaySubject<()>.create(bufferSize: 1)
    var loadLocalRSSDataSubject = ReplaySubject<()>.create(bufferSize: 1)
    
    private let rssRepository: RssRepository
    var endpoint: String
    
    init(rssRepository: RssRepository, endpoint: String) {
        self.rssRepository = rssRepository
        self.endpoint = endpoint
    }
    
    func initializeViewModelObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeLoadRemoteNewsSubject(subject: loadRemoteRSSDataSubject))
        disposables.append(initializeLoadLocalNewsSubject(subject: loadLocalRSSDataSubject))
        return disposables
    }
    
    func fetchData() {
        if(self.rssRepository.loadStories(category: self.endpoint).isEmpty){
            self.loadRemoteRSSDataSubject.onNext(())
        } else {
            let savedTime = UserDefaults.standard.double(forKey: "\(self.endpoint)Date")
            let currentTime = Date().timeIntervalSince1970
            let timeDiff = currentTime - savedTime
            decideRequestType(time: timeDiff)
        }
    }
}

private extension StoriesViewModelImpl {
    
    func initializeLoadRemoteNewsSubject(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .flatMap{ [unowned self] (_) -> Observable<RssResponse> in
                self.loaderSubject.onNext(true)
                return self.rssRepository.getNews(endpoint: self.endpoint)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { (rssResponse) in
                let channel = rssResponse.channel
                self.rssRepository.saveStories(stories: channel.item, category: self.endpoint)
                self.rssDataRelay.accept(channel.item)
                self.loaderSubject.onNext(false)
            })
    }
    
    func initializeLoadLocalNewsSubject(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { _ in
                self.loaderSubject.onNext(true)
                let stories = self.rssRepository.loadStories(category: self.endpoint)
                self.rssDataRelay.accept(stories)
                self.loaderSubject.onNext(false)
            })
    }
    
    func decideRequestType(time: Double) {
        if(time > 300.0) {
            self.loadRemoteRSSDataSubject.onNext(())
        } else {
            self.loadLocalRSSDataSubject.onNext(())
        }
    }
}
