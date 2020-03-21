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

public class Qismo {
    
    static var bundle:Bundle{
        get{
            let podBundle = Bundle(for: Qismo.self)
            
            if let bundleURL = podBundle.url(forResource: "BBChat", withExtension: "bundle") {
                return Bundle(url: bundleURL)!
            }else{
                return podBundle
            }
        }
    }
    public static var qiscus : QiscusCoreAPI!
    var network : QismoNetworkManager!
    
    let manager : QismoManager = QismoManager.shared
    let qiscusServer = QiscusServer(url: URL(string: "https://api.qiscus.com")!, realtimeURL: "", realtimePort: 80)
    
    public init(appID: String) {
        self.manager.appID = appID
        Qismo.self.qiscus = QiscusCoreAPI.init(withAppId: appID, server: self.qiscusServer)
        self.network = QismoNetworkManager(qiscusCoreApi: Qismo.qiscus)
        
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
        
        self.network.initiateChat(param: param, onSuccess: { roomId in
            debugPrint("sukses initiate chat")
            let ui = UIChatViewController()
            ui.roomId = roomId
            callback(ui)
        }, onError: {
            debugPrint("failed initiate chat")
        })
        
//        let ui = UIChatViewController()
//        callback(ui)
        
        
    }
    
}
