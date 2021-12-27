//
//  StoriesTableViewCell.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 26.12.2021..
//

import Foundation
import SnapKit
import RxSwift
import Kingfisher
class StoriesTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.quicksandMedium(size: 16)
        label.numberOfLines = 2
        return label
    }()
    
    let storyImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, image: String?) {
        
        titleLabel.text = title
        
        if let url = image {
            let imageUrl = URL(string: url)
            storyImageView.kf.setImage(with: imageUrl)
        }
        
    }
}

private extension StoriesTableViewCell {
    
    func setupUI() {
        contentView.backgroundColor = .white
        self.backgroundColor = .white
        self.selectionStyle = .none
        contentView.addSubviews(views: storyImageView, titleLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        storyImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.top.leading.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(storyImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
