//
//  HomeViewController.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 23.12.2021..
//

import UIKit
import RxSwift
class HomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    let categoriesTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
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
        setupNavigationBar()
    }
    
}

private extension HomeViewController {
    
    func setupTableView() {
        registerCells()
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubviews(views: progressView, categoriesTableView)
        view.bringSubviewToFront(progressView)
        setupConstraints()
    }
    
    func setupConstraints(){
        
        progressView.snp.makeConstraints{ (make) -> Void in
            make.centerX.centerY.equalToSuperview()
        }
        
        categoriesTableView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func registerCells() {
        categoriesTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "homeTableViewCell")
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .red
        let attributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: R.font.quicksandBold(size: 20)
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.title = "24 SATA"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell", for: indexPath) as? HomeTableViewCell else {
            print("failed to dequeue the wanted cell")
            return UITableViewCell()
        }
        
        let items = viewModel.categories
        let item = items[indexPath.row]
        itemCell.configureCell(name: item.name)
        
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = viewModel.categories
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = viewModel.categories
        let item = items[indexPath.row]
        navigationController?.pushViewController(StoriesViewController(viewModel: StoriesViewModelImpl(rssRepository: RssRepositoryImpl(networkManager: NetworkManager()), endpoint: item.urlExt)), animated: true)
    }
}
