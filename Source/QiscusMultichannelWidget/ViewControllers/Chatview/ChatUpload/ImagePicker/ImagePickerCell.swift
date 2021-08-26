//
//  ImagePickerCell.swift
//  QiscusMultichannelWidget
//
//  Created by Qiscus on 13/08/21.
//

import UIKit
import Photos

class ImagePickerCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var icVideo: UIImageView!
    @IBOutlet weak var viewSelectedOverlay: UIView!
    
    override var isSelected: Bool {
        didSet {
            viewSelectedOverlay.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.clipsToBounds = true
        thumbnail.contentMode = .scaleAspectFill
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
        viewSelectedOverlay.isHidden = !isSelected
    }
    
    func setData(image: PHAsset?) {
        icVideo.isHidden = image?.mediaType == .image
        thumbnail.backgroundColor = .gray
        
        image?.getThumbnailData(completion: { [weak self] (image) in
            DispatchQueue.main.async {
                self?.thumbnail.image = image
            }
        })
    }
}
