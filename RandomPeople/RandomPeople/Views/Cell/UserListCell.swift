//
//  UserListCell.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/31.
//

import UIKit
import Kingfisher

class UserListCell: UITableViewCell {
    static let identifier = "UserListCell"
    
    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    private let infoContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
    }
    
    // MARK: - setup
    private func setup() {
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        let infoViews = [
            userInfoLabel,
            ageLabel,
            addressLabel
        ]
        infoContainerView.addSubviews(infoViews)
        
        let views = [
            thumbnail,
            infoContainerView
        ]
        
        contentView.addSubviews(views)
        
        setConstraints()
    }
    
    // MARK: - constraints
    private func setConstraints() {
        thumbnail.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(64)
        }
        
        infoContainerView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnail.snp.trailing).offset(16)
            make.top.bottom.equalToSuperview()
        }
        
        userInfoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints { make in
            make.leading.equalTo(userInfoLabel.snp.trailing).offset(16)
            make.centerY.equalTo(userInfoLabel)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(userInfoLabel.snp.bottom).offset(2)
        }
        
    }
    
    func configure(with item: UserResult) {
        let thumbnailURL = URL(string: item.picture.thumbnail)
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        thumbnail.kf.setImage(
            with: thumbnailURL,
            placeholder: UIImage(systemName: "photo"),
            options: [.processor(processor)]
        )
        
        userInfoLabel.text = item.userInfo
        ageLabel.text = "age: \(item.age)"
        addressLabel.text = item.locationDesciption
    }
}
