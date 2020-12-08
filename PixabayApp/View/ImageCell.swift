//
//  ImageCell.swift
//  PixabayApp
//
//  Created by Клим on 07.12.2020.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with image: UIImage?){
        imageView.image = image
        
    }
}
