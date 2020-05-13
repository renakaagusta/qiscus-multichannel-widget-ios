//
//  QismoManager.swift
//  BBChat
//
//  Created by asharijuang on 17/12/19.
//

import Foundation
import QiscusCoreApi
import SwiftyJSON
import UserNotifications

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
    
    // MARK : Push Notifications
    func handleNotification(userInfo: [AnyHashable : Any]) {
        let json = JSON(userInfo)
        print(json)

        guard let qiscusEvent = json["qiscus_sdk"].string else { return }
        if qiscusEvent == "post_comment" {
            let roomId = json["qiscus_room_id"].intValue
            self.removeNotification(withRoom: roomId)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
               self.redirectToChat(roomID: roomId)
            }
        }
        // mybe for another notif
    }
    
    private func redirectToChat(roomID id: Int) {
        let current = UIApplication.currentViewController()
        let target = UIChatViewController()
        // MARK: TODO get qiscus room from local db
        target.roomId = String(id)
        current?.navigationController?.pushViewController(target, animated: true)
    }
    
    private func removeNotification(withRoom id: Int) {
        // remove all notification in room
        let notif = UNUserNotificationCenter.current()
        notif.getDeliveredNotifications { (n) in
            n.forEach { (notification) in
                let info = notification.request.content.userInfo
                let _json = JSON(info)
                let _roomId = _json["qiscus_room_id"].intValue
                if _roomId == id {
                    // remove notification with identifier for samem room id
                    notif.removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
                }
            }
        }
    }
    
    
}
