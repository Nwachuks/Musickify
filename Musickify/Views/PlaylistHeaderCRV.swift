//
//  PlaylistHeaderCRV.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 15/11/2022.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCRVDelegate: AnyObject {
    func playlistHeaderCRVPlayAllBtnTapped(_ header: PlaylistHeaderCRV)
}

final class PlaylistHeaderCRV: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCRV"
    
    weak var playlistHeaderCRVDelegate: PlaylistHeaderCRVDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllBtn)
        playAllBtn.addTarget(self, action: #selector(playAllTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height / 1.8
        playlistImageView.frame = CGRect(x: (width - imageSize)/2, y: 20, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: playlistImageView.bottom + 10, width: width - 20, height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width - 90, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: width - 90, height: 44)
        playAllBtn.frame = CGRect(x: width - 80, y: height - 80, width: 60, height: 60)
    }
    
    func configure(using model: PlaylistHeaderViewModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        ownerLabel.text = model.ownerName
        playlistImageView.sd_setImage(with: model.artworkURL, completed: nil)
    }
    
    @objc private func playAllTapped() {
        playlistHeaderCRVDelegate?.playlistHeaderCRVPlayAllBtnTapped(self)
    }
}
