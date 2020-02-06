//
//  QismoNetworkManager.swift
//  Pods
//
//  Created by qiscus on 04/02/20.
//

import Foundation
import QiscusCoreAPI
import Alamofire

class QismoNetworkManager {
    
    var qiscus: QiscusCoreAPI
    let urlInitiateChat = "https://multichannel.qiscus.com/api/v1/qiscus/initiate_chat"
    
    public init(qiscusCoreApi : QiscusCoreAPI) {
        self.qiscus = qiscusCoreApi
    }
    
    public func initiateChat(param: [String:Any], onSuccess: @escaping() -> Void, onError: @escaping() -> Void) {
        var mParam = param
        
        self.qiscus.getJWTNonce(onSuccess: { nonce in
            mParam = ["nonce" : nonce.nonce]
//            self.callInitiateChat(param: mParam, onSuccess: onSuccess, onError: onError)
            
            Alamofire.request(URL(string: self.urlInitiateChat)!, method: .post, parameters: mParam)
            .responseJSON { json in
                
            }
            
        }, onError: { onError in
            
        })
    }
    
    private func callInitiateChat(param: [String:Any], onSuccess: @escaping() -> Void, onError: @escaping() -> Void) {
        let url = "https://multichannel.qiscus.com/api/v1/qiscus/initiate_chat"
        Alamofire.request(URL(string: url)!, method: .post, parameters: param)
            .responseJSON { json in
                
            }
    }
    
}
