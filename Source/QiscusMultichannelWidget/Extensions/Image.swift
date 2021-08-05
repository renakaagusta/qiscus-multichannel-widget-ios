//
//  Image.swift
//  Pods
//
//  Created by asharijuang on 20/12/19.
//

#if os(iOS)
import UIKit
#endif
import Foundation

extension UIImageView {
    
    func applyShadow() {
        let layer           = self.layer
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius  = 1
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}
