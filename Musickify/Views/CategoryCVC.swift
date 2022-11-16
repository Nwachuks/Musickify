//
//  CategoryCVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 16/11/2022.
//

import UIKit
import SDWebImage

class CategoryCVC: UICollectionViewCell {
    static let identifier = "CategoryCVC"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    private let genreNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemPurple,
        .systemGreen,
        .systemBrown,
        .systemRed,
        .systemBlue,
        .systemPink,
        .systemYellow,
        .systemOrange,
        .systemGray,
        .systemTeal
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(genreNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreNameLabel.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        genreNameLabel.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width - 20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2 + 10, y: 10, width: contentView.width/2 - 10, height: contentView.height/2 - 10)
    }
    
    func configure(using viewModel: CategoryViewModel) {
        genreNameLabel.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
