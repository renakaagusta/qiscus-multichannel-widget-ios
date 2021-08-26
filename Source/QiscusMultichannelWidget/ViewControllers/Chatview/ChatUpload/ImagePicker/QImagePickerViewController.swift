//
//  QImagePickerViewController.swift
//  QiscusMultichannelWidget
//
//  Created by Qiscus on 13/08/21.
//

import UIKit
import Photos

class QImagePickerViewController: UIViewController {

    init() {
        super.init(nibName: "QImagePickerViewController", bundle: QiscusMultichannelWidget.bundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var customNavigationItem: UINavigationItem!
    var existingImageCount = 0
    var onFinishPickImage: (([PHAsset?]) -> Void)?
    
    var maxSelectedImage = 10
    
    private let presenter = ImagePickerPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDelegate = self
        presenter.fetchMedia()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func donePickImage(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.onFinishPickImage?(self.presenter.selectedAsset.map({ (assetImagePair) -> PHAsset? in
                return assetImagePair.0
            }))
        }
    }
    
    @IBAction func cancelPickImage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        setupCollectionView()
        customNavigationItem.title = "\(existingImageCount)/\(maxSelectedImage)"
    }
    
    func setupCollectionView() {
        self.mediaCollectionView.delegate = self
        self.mediaCollectionView.dataSource = self
        self.mediaCollectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        self.mediaCollectionView.allowsMultipleSelection = true
        let flowLayout = UICollectionViewFlowLayout()
        self.mediaCollectionView.collectionViewLayout = flowLayout
        self.mediaCollectionView.register(UINib(nibName: "ImagePickerCell", bundle: QiscusMultichannelWidget.bundle), forCellWithReuseIdentifier: "ImagePickerCell")
    }
    
}

extension QImagePickerViewController : ImagePickerView {
    func onLoadMediaComplete() {
        
        mediaCollectionView.reloadData()
    }
    
    func updateTitle() {
        customNavigationItem.title = "\(presenter.selectedAsset.count + existingImageCount)/\(maxSelectedImage)"
    }
}

extension QImagePickerViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize(width: screenSize.width/4.3, height: screenSize.width/4.3)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = self.presenter.assets?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) as! ImagePickerCell
        cell.setData(image: asset)
        
        return cell
    }
}

extension QImagePickerViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.presenter.selectedAsset.count + existingImageCount) == self.maxSelectedImage {
            self.showError(withText: "You can only upload 10 files at a time")
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        self.presenter.selectImage(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.presenter.deselectImage(at: indexPath.row)
    }
}
