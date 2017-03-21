//
//  NewsViewCell.swift
//  bingNews
//
//  Created by Alex on 3/18/17.
//  Copyright © 2017 alex. All rights reserved.
//

import UIKit
import Kingfisher

class NewsFlowCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    
    @IBOutlet weak var imageRatioConstraint: NSLayoutConstraint!

    
    var article: Article? {
        didSet {
            if let article = article {
                if let image = article.image {
                    imageRatioConstraint.constant = image.size.width / image.size.height
                    imageView.image = image
                    
                } else {
                    
                    imageView.kf.setImage(with: article.thumbnail, completionHandler: { (image, error, cache, url) in
                        self.imageRatioConstraint.constant = (image?.size.width)! / (image?.size.height)!
                    })
                }
                
                
                TitleLabel.text = article.name
                descriptionLabel.text = article.descriptionField
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 12.0
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(red: 0.5, green: 0.47, blue: 0.25, alpha: 1.0).cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        TitleLabel.text = ""
        descriptionLabel.text = ""
    }
 
}

