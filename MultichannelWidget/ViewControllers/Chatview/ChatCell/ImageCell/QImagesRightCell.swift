//
//  QImagesRightCell.swift
//  BBChat
//
//  Created by qiscus on 14/01/20.
//

import UIKit
import QiscusCoreApi

class QImagesRightCell: UIBaseChatCell {

    @IBOutlet weak var ivRightBubble: UIImageView!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var ivComment: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    
    var actionBlock: ((CommentModel) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setMenu()
        self.ivComment.isUserInteractionEnabled = true
        let imgTouchEvent = UITapGestureRecognizer(target: self, action: #selector(QImagesRightCell.imageDidTap))
        self.ivComment.addGestureRecognizer(imgTouchEvent)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func present(message: CommentModel) {
        self.bindData(message: message)
    }
    
    override func update(message: CommentModel) {
        self.bindData(message: message)
    }
    
    func setupBalon(){
        
        self.ivRightBubble.image = self.getBallon()
        self.ivRightBubble.tintColor = ColorConfiguration.rightBaloonColor
        self.ivRightBubble.backgroundColor = ColorConfiguration.rightBaloonColor
        
        self.lblCaption.textColor = ColorConfiguration.rightBaloonTextColor
        self.lblDate.textColor = ColorConfiguration.timeLabelTextColor
        
        self.ivRightBubble.layer.cornerRadius = 5.0
        self.ivRightBubble.clipsToBounds = true
        
        self.ivComment.layer.cornerRadius = 5.0
        self.ivComment.clipsToBounds = true
        
    }
    
    func bindData(message: CommentModel) {
        
        setupBalon()
        self.lblCaption.isHidden = false
        guard let payload = message.payload else { return }

        self.lblCaption.text = payload["caption"] as? String

        if let url = payload["url"] as? String {
            if self.ivComment.image == nil {
                self.ivComment.af_setImage(withURL: URL(string: url)!)
            }
        }
        
        self.lblDate.text = AppUtil.dateToHour(date: message.date())
    }
    
    @objc func imageDidTap() {
        if self.comment != nil && self.actionBlock != nil {
            self.actionBlock!(comment!)
        }
    }
    
}

extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
