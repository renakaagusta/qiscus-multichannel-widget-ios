//
//  QReplyImageRightCell.swift
//  QiscusMultichannelWidget
//
//  Created by Qiscus on 24/07/21.
//

import UIKit
import SDWebImage
import AlamofireImage
import Alamofire
import SwiftyJSON
import QiscusCore

class QReplyImageRightCell: UIBaseChatCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tvContent: UILabel!
    @IBOutlet weak var ivBaloonLeft: UIImageView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var ivStatus: UIImageView!
    @IBOutlet weak var ivComment: UIImageView!
    
    @IBOutlet weak var lbNameHeight: NSLayoutConstraint!
    @IBOutlet weak var lbNameTrailing: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    var menuConfig = enableMenuConfig()
    @IBOutlet weak var ivLoading: UIImageView!
    @IBOutlet weak var lbLoading: UILabel!
    @IBOutlet weak var lbReplySender: UILabel!
    var message: QMessage? = nil
    var actionBlock: ((QMessage) -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setMenu()
        self.ivComment.contentMode = .scaleAspectFill
        self.ivComment.clipsToBounds = true
        self.ivComment.backgroundColor = UIColor.black
        self.ivComment.layer.cornerRadius = 8
        self.ivComment.isUserInteractionEnabled = true
        let imgTouchEvent = UITapGestureRecognizer(target: self, action: #selector(QReplyImageRightCell.imageDidTap))
        self.ivComment.addGestureRecognizer(imgTouchEvent)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMassage(_:)),
                                               name: Notification.Name("selectedCell"),
                                               object: nil)
    }
    
    @objc func handleMassage(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let json = JSON(userInfo)
            let commentId = json["commentId"].string ?? "0"
            if let message = self.message {
                if message.id == commentId {
                    self.contentView.backgroundColor = UIColor(red:39/255, green:177/255, blue:153/255, alpha: 0.1)
                }else{
                    self.contentView.backgroundColor = UIColor.clear
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setMenu()
    }
    
    override func present(message: QMessage) {
        self.bindData(message: message)
    }
    
    override func update(message: QMessage) {
        self.bindData(message: message)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ivComment.image = nil // or place holder image
    }
    
    func bindData(message: QMessage){
        self.message = message
        self.contentView.backgroundColor = UIColor.clear
        self.setupBalon(message : message)
        self.status(message: message)
        // get image
        self.lbTime.text = self.hour(date: message.date())
        guard let payload = message.payload else { return }
        if let caption = payload["text"] as? String {
            self.tvContent.text = caption
        }
        
        if let replied_comment_type = payload ["replied_comment_sender_username"] as? String {
             self.lbReplySender.text = replied_comment_type
        }
       
        
        self.tvContent.textColor = ColorConfiguration.rightBubbleTextColor
        if let url = payload["replied_comment_payload"] as? [String:Any] {
            if let url = url["url"] as? String {
                var fileImage = url
                if fileImage.isEmpty == true {
                    fileImage = "https://"
                }
                self.ivComment.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
                // self.ivComment.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                DispatchQueue.global(qos: .background).sync {
                    self.ivComment.sd_setImage(with: URL(string: fileImage) ?? URL(string: "https://"), placeholderImage: nil, options: .highPriority) { (uiImage, error, cache, urlPath) in
                        if urlPath != nil && uiImage != nil{
                            self.ivComment.af_setImage(withURL: urlPath!)
                        }
                    }
                }
                
            }
        }else{
            var fileImage = message.getAttachmentURL(message: message.message)
            if fileImage.isEmpty == true {
                fileImage = "https://"
            }
            self.ivComment.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
            
            // self.ivComment.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            DispatchQueue.global(qos: .background).sync {
                self.ivComment.sd_setImage(with: URL(string: fileImage) ?? URL(string: "https://"), placeholderImage: nil, options: .highPriority) { (uiImage, error, cache, urlPath) in
                    if urlPath != nil && uiImage != nil{
                        self.ivComment.af_setImage(withURL: urlPath!)
                    }
                }
            }
            
        }
        
    }
    
    func hideLoading(){
        self.lbLoading.isHidden = true
        self.ivLoading.isHidden = true
    }
    
    func showLoading(){
        self.lbLoading.isHidden = false
        self.ivLoading.isHidden = false
    }
    
    @objc func imageDidTap() {
        guard let selectedImage = self.ivComment.image else {
            print("Image not found!")
            return
        }
        
        if self.comment != nil && self.actionBlock != nil {
            self.actionBlock!(comment!)
        }
        
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.currentViewController()?.navigationController?.present(ac, animated: true, completion: {
            //success
        })
        
    }
    
    func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return currentViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return currentViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        
        return base
    }
    
    func setupBalon(message : QMessage){
        //self.ivBaloonLeft.applyShadow()
        self.ivBaloonLeft.image = self.getBallon()
        self.lbNameHeight.constant = 0
        self.ivBaloonLeft.tintColor = ColorConfiguration.rightBubbleColor
        self.ivBaloonLeft.backgroundColor = ColorConfiguration.rightBubbleColor
        self.ivBaloonLeft.layer.cornerRadius = 5
    }
    
    func status(message: QMessage){
        
        switch message.status {
        case .deleted:
            ivStatus.image = UIImage(named: "ic_deleted", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .sending, .pending:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
            ivStatus.tintColor = ColorConfiguration.sentOrDeliveredColor
            lbTime.text = TextConfiguration.sharedInstance.sendingText
            ivStatus.image = UIImage(named: "ic_info_time", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .sent:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
            ivStatus.tintColor = ColorConfiguration.sentOrDeliveredColor
            ivStatus.image = UIImage(named: "ic_sending", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .delivered:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
            ivStatus.tintColor = ColorConfiguration.sentOrDeliveredColor
            ivStatus.image = UIImage(named: "ic_read", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .read:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
            ivStatus.tintColor = ColorConfiguration.readMessageColor
            ivStatus.image = UIImage(named: "ic_read", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case . failed:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
            lbTime.text = TextConfiguration.sharedInstance.failedText
            ivStatus.image = UIImage(named: "ic_warning", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            ivStatus.tintColor = ColorConfiguration.failToSendColor
            break
        case .deleting:
            ivStatus.image = UIImage(named: "ic_deleted", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        }
    }
    
    func hour(date: Date?) -> String {
        guard let date = date else {
            return "-"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone      = TimeZone.current
        let defaultTimeZoneStr = formatter.string(from: date);
        return defaultTimeZoneStr
    }
    
}

