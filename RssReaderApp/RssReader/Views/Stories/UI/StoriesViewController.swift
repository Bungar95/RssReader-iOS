//
//  StoriesViewController.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 24.12.2021..
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
class StoriesViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    let storiesTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    let viewModel: StoriesViewModel
    
    init(viewModel: StoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        initializeVM()
        setupNavigationBar()
        viewModel.fetchData()
    }
}

private extension StoriesViewController {
    
    func setupTableView() {
        registerCells()
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
    }
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubviews(views: progressView, storiesTableView)
        view.bringSubviewToFront(progressView)
        setupConstraints()
    }
    
    func setupConstraints(){
        
        progressView.snp.makeConstraints{ (make) -> Void in
            make.centerX.centerY.equalToSuperview()
        }
        
        storiesTableView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func registerCells() {
        storiesTableView.register(StoriesTableViewCell.self, forCellReuseIdentifier: "storiesTableViewCell")
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "24 SATA - \(self.viewModel.endpoint)"
    }
    
}

private extension StoriesViewController {
    
    func initializeVM() {
        disposeBag.insert(viewModel.initializeViewModelObservables())
        
        initializeLoaderObservable(subject: viewModel.loaderSubject).disposed(by: disposeBag)
        initializeStoriesDataObservable(subject: viewModel.rssDataRelay).disposed(by: disposeBag)
    }
    
    func initializeLoaderObservable(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (status) in
                if status {
                    showLoader()
                } else {
                    hideLoader()
                }
            })
    }
    
    func initializeStoriesDataObservable(subject: BehaviorRelay<[Item]>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (stories) in
                if !stories.isEmpty {
                    storiesTableView.reloadData()
                }
            })
    }
}

extension StoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: "storiesTableViewCell", for: indexPath) as? StoriesTableViewCell else {
            print("failed to dequeue the wanted cell")
            return UITableViewCell()
        }
        
        let items = viewModel.rssDataRelay.value
        let item = items[indexPath.row]
        
        itemCell.configureCell(title: item.title, image: item.enclosure.url)
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = viewModel.rssDataRelay.value
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = viewModel.rssDataRelay.value
        let item = items[indexPath.row]
        navigationController?.pushViewController(SingleStoryViewController(viewModel: SingleStoryViewModelImpl(url: item.link)), animated: true)
    }
    
}

extension StoriesViewController {
    
    func showLoader() {
        progressView.isHidden = false
        progressView.startAnimating()
    }
    
    func hideLoader() {
        progressView.isHidden = true
        progressView.stopAnimating()
    }
}
