//
//  ResultCollectionViewCell.swift
//  Jelajah
//
//  Created by Indra Permana on 04/07/22.
//

import UIKit
import SDWebImage

class ResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setItem(with item: Business) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: item.imageURL ?? ""))
        imageView.contentMode = .scaleAspectFill
        
        nameLabel.text = item.name ?? ""
        nameLabel.numberOfLines = 2
        
        ratingLabel.text = String(item.rating ?? 0)
        ratingLabel.layer.masksToBounds = true
        ratingLabel.layer.cornerRadius = 5
        
        addressLabel.text = item.location?.address1 ?? "" + "|" + (item.displayPhone ?? "")
        
        openLabel.text = String(format: "%.1f km", (item.distance ?? 0) / 1000)
        
        let categories = item.categories?.compactMap { category  in
            category.title
        }.joined(separator: ", ")
        
        categoriesLabel.text = categories
    }

}
