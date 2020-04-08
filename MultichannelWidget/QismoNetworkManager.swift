//
//  QismoNetworkManager.swift
//  Pods
//
//  Created by qiscus on 04/02/20.
//

import Foundation
import QiscusCoreApi
import Alamofire

class QismoNetworkManager {
    
    var qiscus: QiscusCoreAPI
    let urlInitiateChat = "https://multichannel.qiscus.com/api/v1/qiscus/initiate_chat"
    
    public init(qiscusCoreApi : QiscusCoreAPI) {
        self.qiscus = qiscusCoreApi
    }
    
    public func initiateChat(param: [String:Any], onSuccess: @escaping(String) -> Void, onError: @escaping() -> Void) {
        var mParam = param
        
        self.qiscus.getJWTNonce(onSuccess: { nonce in
//            mParam = ["nonce" : nonce.nonce]
            mParam.updateValue(nonce.nonce, forKey: "nonce")
            //self.callInitiateChat(param: mParam, onSuccess: onSuccess, onError: onError)
            Alamofire.request(URL(string: self.urlInitiateChat)!, method: .post, parameters: mParam, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                guard let value = response.result.value as? [String: Any],
                let chat = value["data"] as? [String: Any] else {
                  return
                }
                //get identityToken
                guard let identityToken = chat["identity_token"] as? String else {
                    onError()
                    return
                }
                
                guard let roomId = chat["room_id"] as? String else {
                    onError()
                    return
                }
                //login sdk
                self.setQismoSdkUser(identityToken: identityToken, onSuccess: { user in
                    //success login sdk
                    onSuccess(roomId)
                }, onError: { qError in
                    debugPrint(qError.message)
                })
                
                debugPrint(chat)
            }
            
        }, onError: { onError in
            print(onError.message)
        })
    }
    
    private func callInitiateChat(param: [String:Any], onSuccess: @escaping() -> Void, onError: @escaping() -> Void) {
        let url = "https://multichannel.qiscus.com/api/v1/qiscus/initiate_chat"
        Alamofire.request(URL(string: url)!, method: .post, parameters: param)
            .responseJSON { json in
                
            }
    }
    
    public func setQismoSdkUser(identityToken: String, onSuccess: @escaping(UserModel) -> Void, onError: @escaping(QError) -> Void) {
        self.qiscus.setUserWithIdentityToken(token: identityToken, onSuccess: { user in
            onSuccess(user)
        }, onError: { qError in
            onError(qError)
        })
    }
    
    public func getQismoRoom(roomId: String, onSuccess: @escaping(RoomModel) -> Void, onError: @escaping(QError) -> Void) {
        
        self.qiscus.getChatRoom(id: roomId, onSuccess: { room, comments in
            
        }, onError: { qError in
            
        })
        
    }
    
}
