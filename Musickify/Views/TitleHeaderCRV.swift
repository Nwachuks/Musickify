//
//  TitleHeaderCRV.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 15/11/2022.
//

import UIKit

class TitleHeaderCRV: UICollectionReusableView {
    static let identifier = "TitleHeaderCRV"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    func configure(using title: String) {
        titleLabel.text = title
    }
}
