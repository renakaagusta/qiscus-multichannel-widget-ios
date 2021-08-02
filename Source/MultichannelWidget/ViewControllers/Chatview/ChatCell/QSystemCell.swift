//
//  QSystemCell.swift
//  Qiscus
//
//  Created by asharijuang on 05/09/18.
//

#if os(iOS)
import UIKit
#endif

import QiscusCore
import SwiftyJSON

class QSystemCell:  UIBaseChatCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lbComment: UILabel!
    var message: QMessage? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viewBackground.layer.cornerRadius = 8
        self.viewBackground.clipsToBounds = true
        self.viewBackground.layer.borderWidth = 1
        self.viewBackground.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        
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
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func present(message: QMessage) {
        // parsing payload
        self.bindData(message: message)
        
    }
    
    override func update(message: QMessage) {
        self.bindData(message: message)
    }
    
    func bindData(message: QMessage){
        self.message = message
        lbComment.text = "\(self.hour(date: message.date())) - \(message.message)"
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
