//
//  ImagePickerPresenter.swift
//  QiscusMultichannelWidget
//
//  Created by Qiscus on 13/08/21.
//

import Foundation
import Photos
import UIKit

protocol ImagePickerView {
    func onLoadMediaComplete()
    func updateTitle()
}

class ImagePickerPresenter {
    var viewDelegate: ImagePickerView?
    var selectedAsset: [(PHAsset?, UIImage?)] = []
    var assets: PHFetchResult<PHAsset>?
    
    func fetchMedia() {
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            guard let self = self else {
                return
            }
            
            if status == .authorized {
                let fetchOption = PHFetchOptions()
                fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOption.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
                
                self.assets = PHAsset.fetchAssets(with: fetchOption)
                
                DispatchQueue.main.async {
                    self.viewDelegate?.onLoadMediaComplete()
                }
            }
        }
    }
    
    func selectImage(at index: Int) {
        let asset = assets?[index]
        asset?.getPreviewImage(completion: { [weak self](image) in
            self?.selectedAsset.append((asset, image))
            self?.viewDelegate?.updateTitle()
        })

    }
    
    func deselectImage(at index: Int) {
        let deletedAsset = self.assets?[index]
        selectedAsset.removeAll { (asset) -> Bool in
            return asset.0 == deletedAsset
        }
        
        viewDelegate?.updateTitle()
    }
}
