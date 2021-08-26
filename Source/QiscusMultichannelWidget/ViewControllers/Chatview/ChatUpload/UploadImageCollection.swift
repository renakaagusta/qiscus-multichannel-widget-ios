//
//  UploadImageCollection.swift
//  QiscusMultichannelWidget
//
//  Created by Qiscus on 13/08/21.
//

import UIKit
import Foundation
import Photos

class UploadImageCollection: UIView {
    var images: [UIImage?] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    var contentsView            : UIView!
    private var onSelectAddImage : (() -> Void)? = nil
    private var onSelectImage : ((UIImage?) -> Void)? = nil
    private var onMessages : ((String) -> Void)? = nil
    var selectedIndex: Int = 0
    var selectedImage: UIImage? {
        get {
            return self.images[selectedIndex]
        }
    }
    
    override init(frame: CGRect) {
        // For use in code
        super.init(frame: frame)
        let nib = UINib(nibName: "UploadImageCollection", bundle: QiscusMultichannelWidget.bundle)
        commonInit(nib: nib)
    }
    
    // If someone is to initalize a UIChatInput in Storyboard setting the Custom Class of a UIView
    required init?(coder aDecoder: NSCoder) {
        // For use in Interface Builder
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "UploadImageCollection", bundle: QiscusMultichannelWidget.bundle)
        commonInit(nib: nib)
    }
    
    func updateSelectedImage(asset: UIImage) {
        self.images[selectedIndex] = asset
        
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [IndexPath(row: self.selectedIndex, section: 0)])
        }
    }
    
    func setOnTapImage(completion: @escaping ((UIImage?) -> Void)) {
        self.onSelectImage = completion
    }
    
    func setOnTapAdd(completion: @escaping (() -> Void)) {
        self.onSelectAddImage = completion
    }
    
    func setOnMessages(completion: @escaping ((String) -> Void)) {
        self.onMessages = completion
    }
    
    func addImage(image: UIImage?) {
        self.images.append(image)
        
        self.collectionView.reloadData()
        self.selectedIndex = self.images.count - 1
        self.onSelectImage?(image)
                
        scrollToEnd()
    }
    
    func deleteSelectedImage() {
        self.images.remove(at: self.selectedIndex)
        self.collectionView.deleteItems(at: [IndexPath(row: self.selectedIndex, section: 0)])
        
        if self.selectedIndex > 0 {
            self.selectedIndex -= 1
        }
        
        self.collectionView.selectItem(at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
    }
    
    func scrollToEnd() {
        //scroll to button add image
        let lastItemIndex = IndexPath(item: 0, section: 1)
        self.collectionView.scrollToItem(at: lastItemIndex, at: .right, animated: true)
    }
    
    private func commonInit(nib: UINib) {
        self.contentsView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        // 2. Adding the 'contentView' to self (self represents the instance of a WeatherView which is a 'UIView').
        addSubview(contentsView)
        
        // 3. Setting this false allows us to set our constraints on the contentView programtically
        contentsView.translatesAutoresizingMaskIntoConstraints = false

        // 4. Setting the constraints programatically
        contentsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentsView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentsView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        self.autoresizingMask  = (UIView.AutoresizingMask.flexibleWidth)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.register(UINib(nibName: "UploadImageCell", bundle: QiscusMultichannelWidget.bundle), forCellWithReuseIdentifier: "UploadImageCell")
    }
    
}

extension UploadImageCollection: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? images.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: 16, height: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell
        
        if indexPath.section == 1 {
            cell.imageView.image = UIImage(named: "ic_add", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)
            cell.imageView.tintColor = ColorConfiguration.topColor
            cell.backgroundColor = UIColor.clear
            cell.imageView.contentMode = .scaleAspectFit
            
            return cell
        }
        
        let image = self.images[indexPath.row]
        cell.imageView.image = image
        cell.imageView.contentMode = .scaleAspectFill
        
        if indexPath.row == selectedIndex {
            cell.imageView.layer.borderColor = UIColor.blue.cgColor
            cell.imageView.layer.borderWidth = 2
        } else {
            cell.imageView.layer.borderWidth = 0
        }
        
        return cell
    }
}

extension UploadImageCollection: UIScrollViewDelegate, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            collectionView.selectItem(at: IndexPath(row: self.selectedIndex, section: 0), animated: false, scrollPosition: .centeredVertically)
            self.onSelectAddImage?()
        } else {
            let previousSelectedIndex = self.selectedIndex
            self.selectedIndex = indexPath.row
            self.onSelectImage?(self.images[indexPath.row])
            collectionView.reloadItems(at: [IndexPath(row: previousSelectedIndex, section: 0)])
        }
    }
}
