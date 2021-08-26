//
//  UploadImageCell.swift
//  Alamofire
//
//  Created by Qiscus on 13/08/21.
//

import UIKit

class UploadImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.layer.borderColor = UIColor.blue.cgColor
                imageView.layer.borderWidth = 2
            } else {
                imageView.layer.borderWidth = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.imageView.clipsToBounds = true
        // Initialization code
    }

}
