//
//  Qismo.swift
//  Alamofire
//
//  Created by asharijuang on 08/01/20.
//

import Foundation
import UIKit
import Alamofire
import QiscusCoreApi

public class MultichannelWidget {
    
    static var bundle:Bundle{
        get{
            let podBundle = Bundle(for: MultichannelWidget.self)
            
            if let bundleURL = podBundle.url(forResource: "BBChat", withExtension: "bundle") {
                return Bundle(url: bundleURL)!
            }else{
                return podBundle
            }
        }
    }
    public static var qiscus : QiscusCoreAPI!
    private static var network : QismoNetworkManager!
    
    let manager : QismoManager = QismoManager.shared
    private static let qiscusServer = QiscusServer(url: URL(string: "https://api.qiscus.com")!, realtimeURL: "", realtimePort: 80)
    
    public static let shared: MultichannelWidget = MultichannelWidget()
    
    public class func setup(appID: String) {
        QismoManager.shared.appID = appID
        MultichannelWidget.qiscus = QiscusCoreAPI.init(withAppId: appID, server: qiscusServer)
        network = QismoNetworkManager(qiscusCoreApi: MultichannelWidget.qiscus)
    }
    
    public func setUser(id: String, displayName: String) {
        self.manager.setUSer(id: id, username: displayName)
    }
    
    public func openChat() -> UIViewController {
        
        
        return manager.openChat()
    }
    
    public func initiateChat(userId: String, username: String, callback: @escaping (UIViewController) -> Void)  {
        
        let param = [
            "app_id"    : manager.appID,
            "user_id"   : userId,
            "name"  : username,
            "nonce"     : ""
        ]
        
        MultichannelWidget.network.initiateChat(param: param, onSuccess: { roomId in
            debugPrint("sukses initiate chat")
            let ui = UIChatViewController()
            ui.roomId = roomId
            callback(ui)
        }, onError: {
            debugPrint("failed initiate chat")
        })
        
    }
    
}
