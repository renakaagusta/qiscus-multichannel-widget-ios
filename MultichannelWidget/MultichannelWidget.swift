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
    
    let manager : QismoManager = QismoManager.shared
    
    public init(appID: String, server : QiscusServer? = nil) {
        self.manager.setup(appID: appID, server: server)
    }
    
    public func setUser(id: String, displayName: String) {
        self.manager.setUSer(id: id, username: displayName)
    }
    
    /// Clear all user data or logout
    public func clearUser() {
        self.manager.clear()
    }

    public func initiateChat(userId: String, username: String,avatar: String = "", extras: String? = nil, userProperties: [[String:Any]]? = nil, callback: @escaping (UIViewController) -> Void)  {
        
        manager.initiateChat(userId: userId, username: username, avatar: avatar, extras: extras, userProperties: userProperties, callback: callback)
        
    }
    
    public func register(deviceToken token: String, isDevelopment: Bool, onSuccess: @escaping (Bool) -> Void, onError: @escaping (String) -> Void){
        self.manager.deviceToken = token
        manager.qiscus.register(deviceToken: token, isDevelopment: isDevelopment, onSuccess: { (response) in
            if response { self.manager.deviceToken = "" }
            onSuccess(response)
        }) { (error) in
            onError(error.message)
        }
    }
    
    public func isMultichannelNotification(userInfo: [String:Any]) -> Bool {
        // check app id
        return false
    }
    
    public func tapNotification(userInfo : [AnyHashable : Any]) {
        manager.handleNotification(userInfo: userInfo)
    }
    
}
