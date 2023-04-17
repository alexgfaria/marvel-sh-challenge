//
//  CustomCollectionViewCell.swift
//  Marvel Near Sea Challenge
//
//  Created by Alex Faria on 17/04/2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    enum Constants {
        
        static let cellIdentifier = "CustomCollectionViewCell"
        static let personFill = "person.fill"
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let identifier = Constants.cellIdentifier
    }
        
    let heroImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.personFill)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true //prevents overflow
        
        return imageView
    }()
    
    private let heroNameLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .black.withAlphaComponent(0.6)
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 10.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius:contentView.layer.cornerRadius).cgPath
        contentView.backgroundColor = .systemGray5
        contentView.addSubview(heroImageView)
        contentView.addSubview(heroNameLabel)
        
        contentView.clipsToBounds = true //prevents overflow
        self.heroImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.heroImageView.frame = CGRect(x: 0,
                                          y: 0,
                                          width: contentView.frame.size.width,
                                          height: contentView.frame.size.height)
        
        self.heroNameLabel.frame = CGRect(x: 0,
                                          y: contentView.frame.size.height - 50,
                                          width: contentView.frame.size.width,
                                          height: 50)
    }
    
    public func configure(label: String) {
        
        self.heroNameLabel.text = label
    }
    
    override func prepareForReuse() { //reset each cell when is dequeued
        
        super.prepareForReuse()
        
        self.heroNameLabel.text = nil
        self.heroImageView.image = nil
    }
}
