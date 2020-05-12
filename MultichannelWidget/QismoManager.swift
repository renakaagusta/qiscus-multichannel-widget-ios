//
//  QismoManager.swift
//  BBChat
//
//  Created by asharijuang on 17/12/19.
//

import Foundation
import QiscusCoreApi

class QismoManager {
    
    static let shared : QismoManager = QismoManager()
    
    var appID: String = ""
    private var userID : String = ""
    private var username : String = ""
    var network : QismoNetworkManager!
    var qiscus : QiscusCoreAPI!
    var qiscusServer = QiscusServer(url: URL(string: "https://api.qiscus.com")!, realtimeURL: "", realtimePort: 80)
    
    func setUSer(id: String, username: String) {
        self.userID = id
        self.username = username
    }
    
    func setup(appID: String, server : QiscusServer? = nil) {
        self.appID = appID
        self.qiscus = QiscusCoreAPI.init(withAppId: appID, server: qiscusServer)
        self.network = QismoNetworkManager(QiscusCoreAPI: self.qiscus)
        if let _server = server {
            self.qiscusServer = _server
        }
    }
    
    func initiateChat(userId: String, username: String,avatar: String = "", extras: String? = nil, userProperties: [[String:Any]]? = nil, callback: @escaping (UIViewController) -> Void)  {
        let savedRoomId = SharedPreferences.getRoomId()
        
        if savedRoomId != nil {
            let ui = UIChatViewController()
            ui.roomId = savedRoomId!
            callback(ui)
            return
        }
        
        let param = [
            "app_id"            : appID,
            "user_id"           : userId,
            "name"              : username,
            "avatar"            : avatar,
            "extras"            : extras ?? "{}",
            "user_properties"   : userProperties != nil ? userProperties ?? [] : [],
            "nonce"             : ""
            ] as [String : Any]
        
        self.network.initiateChat(param: param as [String : Any], onSuccess: { roomId in
            
            SharedPreferences.saveParam(param: param)
            SharedPreferences.saveRoomId(id: roomId)
            let ui = UIChatViewController()
            ui.roomId = roomId
            callback(ui)
        }, onError: { error in
            debugPrint("failed initiate chat, \(error)")
        })
        
    }
}
