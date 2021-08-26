//
//  PHAssetAndURL.swift
//  Pods
//
//  Created by Qiscus on 13/08/21.
//

import Foundation
import Photos
import UIKit

extension PHAsset {
    func getURL(completionHandler: @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                DispatchQueue.main.async {
                    completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
                }
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    DispatchQueue.main.async {
                        completionHandler(localVideoUrl)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                }
            })
        }
    }
    
    func getPreviewImage(completion: @escaping (UIImage?) -> Void) {
        var option = PHImageRequestOptions()
        option.resizeMode = .exact
        option.isSynchronous = true
        PHImageManager.default().requestImageData(for: self, options: option) { (data, _, _, _) in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
            
        }
    }
    
    func getPreviewImage() -> UIImage? {
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var image: UIImage?
        PHImageManager.default().requestImageData(for: self, options: option) { (data, _, _, _) in
            guard let data = data else {
                return
            }
            image = UIImage(data: data)
        }
        
        return image
    }
    
    func getThumbnailData(completion: @escaping (UIImage?) -> Void) {
        let option = PHImageRequestOptions()
        PHImageManager.default().requestImage(for: self, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: option) { (image, _) in
            completion(image)
        }
    }
}
