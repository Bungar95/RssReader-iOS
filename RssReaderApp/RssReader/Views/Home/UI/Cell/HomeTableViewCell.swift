//
//  HomeTableViewCell.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 24.12.2021..
//

import Foundation
import SnapKit
import RxSwift
import UIKit
class HomeTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = R.font.quicksandBold(size: 28)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(name: String) {
        
        nameLabel.text = name
    }
}

private extension HomeTableViewCell {
    
    func setupUI() {
        contentView.backgroundColor = .white
        self.backgroundColor = .white
        self.selectionStyle = .none
        contentView.addSubviews(views: nameLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.trailing.bottom.equalToSuperview().offset(-5)
        }
    }
}
