//
//  DisableInput.swift
//  Pods
//
//  Created by qiscus on 24/04/20.
//

#if os(iOS)
import UIKit
import SwiftyJSON
#endif

protocol DisableChatInputDelegate {
    func finishVC()
    func startNewChat(vc: UIChatViewController)
}

class DisableInput: UIView {

    @IBOutlet weak var btStartNewChat: UIButton!
    var contentsView: UIView!
    var disableInputDelegate: DisableChatInputDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let nib = UINib(nibName: "DisableInput", bundle: QiscusMultichannelWidget.bundle)
        commonInit(nib: nib)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let nib = UINib(nibName: "DisableInput", bundle: QiscusMultichannelWidget.bundle)
        commonInit(nib: nib)
    }
    
    @IBAction func onNewChatClick(_ sender: Any) {
        guard let param = SharedPreferences.getParam() else {
            self.disableInputDelegate?.finishVC()
            return
        }
        
        let title = SharedPreferences.getTitle()
        let subtitle = SharedPreferences.getSubtitle()
        
        let data = JSON(param)
        let userId = data["user_id"].string ?? ""
        let username = data["name"].string ?? ""
        let avatar = data["avatar"].string ?? "https://"
        

        var userProp: [[String: Any]]? = nil
        if let userProperties = param["user_properties"] as? [[String: Any]] {
            userProp = userProperties
        }
        
        let extras = SharedPreferences.getExtrasMultichannelConfig()
        debugPrint(userId)

        SharedPreferences.removeRoomId()

        QismoManager.shared.initiateChat(withTitle: title, andSubtitle: subtitle, userId: userId, username: username, avatar: avatar, extras: extras, userProperties: userProp, callback: { roomId in
            self.disableInputDelegate?.startNewChat(vc: roomId as! UIChatViewController)
        })
       
        return
        
    }
    
    func commonInit(nib: UINib) {
        self.contentsView = nib.instantiate(withOwner: self, options: nil).first as! UIView
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
        self.contentsView.backgroundColor = ColorConfiguration.navigationColor
        self.btStartNewChat.setTitleColor(ColorConfiguration.buttonStartNewChat, for: .normal)
    }

}
