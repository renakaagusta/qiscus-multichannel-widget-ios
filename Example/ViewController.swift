//
//  ViewController.swift
//  Example
//
//  Created by asharijuang on 28/02/20.
//  Copyright © 2020 qiscus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtUserId: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openMultichannel(_ sender: Any) {
        
        guard let userId = self.txtUserId.text, userId.count > 0 else {
            showError(message: "userId can't empty")
            return // or throw
        }
        
        guard let username = self.txtUsername.text, username.count > 0 else {
            showError(message: "username can't empty")
            return
        }
        
        ChatManager.shared.client.initiateChat(userId: userId, username: username, callback: { target in
            self.navigationController?.pushViewController(target, animated: true)
        })
    }
    
    func showError(message : String) {
        let alert = UIAlertController(title: "warning", message: String(describing: message), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

