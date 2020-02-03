//
//  Qismo.swift
//  Alamofire
//
//  Created by asharijuang on 08/01/20.
//

import Foundation
import UIKit

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
    }
    
    public func setUser(id: String, displayName: String) {
        self.manager.setUSer(id: id, username: displayName)
    }
    
    public func openChat() -> UIViewController {
        return manager.openChat()
    }
    
}
