//
//  File.swift
//  Example
//
//  Created by qiscus on 21/03/20.
//  Copyright © 2020 qiscus. All rights reserved.
//

import Foundation
import MultichannelWidget

class ChatManager {
    
    static let shared: ChatManager = ChatManager()
    
    lazy var client: Qismo  = {
        return Qismo.init(appID: "karm-gzu41e4e4dv9fu3f")
    }()
}
