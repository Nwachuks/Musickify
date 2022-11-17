//
//  SearchResultSubtitleTVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 17/11/2022.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTVC: UITableViewCell {
    
    static let identifier = "SearchResultSubtitleTVC"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        
        let labelHeight: CGFloat = contentView.height/2
        titleLabel.frame = CGRect(x: iconImageView.right + 5, y: 0, width: contentView.width - imageSize - 5, height: labelHeight)
        subtitleLabel.frame = CGRect(x:  iconImageView.right + 5, y: titleLabel.bottom, width: contentView.width - imageSize - 5, height: labelHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    func configure(using viewModel: SearchResultSubtitleViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
    
}
