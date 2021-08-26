//
//  ChatManager.swift
//  Example
//
//  Created by Rahardyan Bisma on 19/05/20.
//  Copyright © 2020 qiscus. All rights reserved.
//

import Foundation
import UIKit
import QiscusMultichannelWidget
import QiscusCore
import Localize_Swift

enum ChatTransitionType {
    case push(animated: Bool)
    case present(animated: Bool, completion: (() -> Void)? = nil)
}

final class ChatManager {
    static let shared: ChatManager = ChatManager()
    lazy var qiscusWidget: QiscusMultichannelWidget = {
       return QiscusMultichannelWidget(appID: "hat-ppxmocchbbcbhopzk")
    }()
    
    func setUser(id: String, displayName: String, avatarUrl: String = "") {
        qiscusWidget.setUser(id: id, displayName: displayName, avatarUrl: avatarUrl)
    }
    
    func getUser() ->QAccount?{
        return qiscusWidget.getUser()
    }
    
    func signOut() {
        qiscusWidget.clearUser()
    }
    
    func isLoggedIn() -> Bool {
        return qiscusWidget.isLoggedIn()
    }
    
    func startChat(from viewController: UIViewController, extras: String = "", userProperties: [[String: String]], transition: ChatTransitionType = .push(animated: true)) {
        
        qiscusWidget.initiateChat()
            .setRoomTitle(title: "TITLE".localized())
            .setRoomSubTitle(enableSubtitle: RoomSubtitle.enable, subTitle: "SUBTITLE".localized())
            .setNavigationColor(color: #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.6, alpha: 1))
            .setNavigationTitleColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            .setRightBubbleColor(color: #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.6, alpha: 1))
            .setLeftBubbleColor(color: #colorLiteral(red: 0.957, green: 0.957, blue: 0.957, alpha: 1))
            .setRightBubbleTextColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            .setLeftBubbleTextColor(color: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1))
            .setTimeLabelTextColor(color: #colorLiteral(red: 133/255.0, green: 133/255.0, blue: 133/255.0, alpha: 1))
            .setTimeBackgroundColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            .setBaseColor(color: #colorLiteral(red: 0.9782221503, green: 0.9782221503, blue: 0.9782221503, alpha: 1))
            .setEmptyTextColor(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            .setEmptyBackgroundColor(color: #colorLiteral(red: 0.9782221503, green: 0.9782221503, blue: 0.9782221503, alpha: 1))
            .setHideUIEvent(showSystemEvent: true)
            .setSystemEventTextColor(color: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1))
            .setShowAvatarSender(isShowing: false)
            .setShowUsernameSender(isShowing: false)
            .setSendContainerColor(color: #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.6, alpha: 1))
            .setFieldChatBorderColor(color: #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9137254902, alpha: 1))
            .setSendContainerBackgroundColor(color: #colorLiteral(red: 0.89, green: 0.89, blue: 0.89, alpha: 1))
            .startChat { (chatViewController) in
                viewController.navigationController?.setViewControllers([viewController, chatViewController], animated: true)
        }
        
    }
    
    func register(deviceToken: Data?) {
        if let deviceToken = deviceToken {
            var tokenString: String = ""
            for i in 0..<deviceToken.count {
                tokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
            }
            print("token = \(tokenString)")
            self.qiscusWidget.register(deviceToken: tokenString, onSuccess: { (response) in
                print("Multichannel widget success to register device token")
            }) { (error) in
                print("Multichannel widget failed to register device token")
            }
        }
    }
    
    
    func userTapNotification(userInfo : [AnyHashable : Any]) {
        self.qiscusWidget.handleNotification(userInfo: userInfo, removePreviousNotif: true)
//        .startChat(withRoomId: <#T##String#>, callback: <#T##(UIViewController) -> Void#>)
    }
}
