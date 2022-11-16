//
//  GenreCVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 16/11/2022.
//

import UIKit

class GenreCVC: UICollectionViewCell {
    static let identifier = "GenreCVC"
    
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        genreNameLabel.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width - 20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2, y: 0, width: contentView.width/2, height: contentView.height/2)
    }
    
    func configure(using title: String) {
        genreNameLabel.text = title
        contentView.backgroundColor = colors.randomElement()
    }
}
