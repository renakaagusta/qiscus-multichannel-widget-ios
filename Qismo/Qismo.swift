//
//  Qismo.swift
//  Alamofire
//
//  Created by asharijuang on 08/01/20.
//

import Foundation
import UIKit
import Alamofire
import QiscusCoreAPI

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
    
    let manager : QismoManager = QismoManager.shared
    
    public init(appID: String) {
        self.manager.appID = appID
        QiscusCoreAPI.init(withAppId: appID)
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
            "username"  : username,
            "nonce"     : ""
        ]
        
        let url = "https://multichannel.qiscus.com/api/v1/qiscus/initiate_chat"
        let req = Alamofire.request(URL(string: url)!, method: .post, parameters: param)
            .responseJSON { json in
                
            }
        callback(UIChatViewController())
    }
    
}
