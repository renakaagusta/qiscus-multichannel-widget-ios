//
//  ChatManager.swift
//  Example
//
//  Created by Rahardyan Bisma on 19/05/20.
//  Copyright © 2020 qiscus. All rights reserved.
//

import Foundation
import MultichannelWidget

enum ChatTransitionType {
    case push(animated: Bool)
    case present(animated: Bool, completion: (() -> Void)? = nil)
}

final class ChatManager {
    static let shared: ChatManager = ChatManager()
    
    lazy var widget: MultichannelWidget = {
       return MultichannelWidget(appID: "bul-3c5iczzj7aiefltec")
    }()
    
    func setUser(id: String, displayName: String, avatarUrl: String = "") {
        widget.setUser(id: id, displayName: displayName, avatarUrl: avatarUrl)
    }
    
    func signOut() {
        widget.clearUser()
    }
    
    func isLoggedIn() -> Bool {
        return widget.isLoggedIn()
    }
    
    func startChat(from sourceViewController: UIViewController, extras: String = "", userProperties: [[String: String]] = [], transition: ChatTransitionType = .push(animated: true)) {
        widget.prepareChat()
            .setNavigationColor(color: .blue)
            .setExtras(extras: extras)
            .setUserProperties(properties: userProperties)
            .startChat { (chatViewController) in
                switch transition {
                case .present(let animated, let completion):
                    let chatNavigationController = UINavigationController(rootViewController: chatViewController)
                    sourceViewController.navigationController?.present(chatNavigationController, animated: animated, completion: completion)
                case .push(let animated):
                    sourceViewController.navigationController?.pushViewController(chatViewController, animated: animated)
                }
        }
        
        //        widget.initiateChat(extras: extras, userProperties: userProperties, callback: { (chatViewController) in
        //
        //        })
    }
    
    func register(deviceToken: Data?) {
        if let deviceToken = deviceToken {
            var tokenString: String = ""
            for i in 0..<deviceToken.count {
                tokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
            }
            print("token = \(tokenString)")
            self.widget.register(deviceToken: tokenString, isDevelopment: false, onSuccess: { (response) in
                print("Multichannel widget success to register device token")
            }) { (error) in
                print("Multichannel widget failed to register device token")
            }
        }
    }
    
    
    func userTapNotification(userInfo : [AnyHashable : Any]) {
        self.widget.tapNotification(userInfo: userInfo)
    }
}
