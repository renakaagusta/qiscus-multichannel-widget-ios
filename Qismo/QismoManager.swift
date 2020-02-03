//
//  QismoManager.swift
//  BBChat
//
//  Created by asharijuang on 17/12/19.
//

import Foundation

class QismoManager {
    
    static let shared : QismoManager = QismoManager()
    var appID: String = ""
    private var userID : String = ""
    private var username : String = ""
    
    func setUSer(id: String, username: String) {
        self.userID = id
        self.username = username
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
    
}
