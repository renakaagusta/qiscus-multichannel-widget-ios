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
    
    let qiscusServer = QiscusServer(url: URL(string: "https://api.qiscus.com")!, realtimeURL: "", realtimePort: 80)
    
    func setUSer(id: String, username: String) {
        self.userID = id
        self.username = username
    }
    
    func setup(appID: String) {
        self.qiscus = QiscusCoreAPI.init(withAppId: appID, server: qiscusServer)
        self.network = QismoNetworkManager(QiscusCoreAPI: self.qiscus)
    }
    
    func openChat() -> UIViewController {
//        let baseURL = "https://a70c02a1.ngrok.io"
        let baseURL = "https://mybb-webview.herokuapp.com/"
        let hide = "#hide-header"
        let url = "\(baseURL)?appid=\(self.appID)&email=\(self.userID)&username=\(self.username)"
        
        let target = QismoViewController()
        target.url = URL(string: url)
        return target
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
        }, onError: {
            debugPrint("failed initiate chat")
        })
        
    }
}
