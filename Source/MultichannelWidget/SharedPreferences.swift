//
//  SharedPreferences.swift
//  Pods
//
//  Created by qiscus on 26/04/20.
//

import Foundation

class SharedPreferences {
    
    static let defaults = UserDefaults.standard
    
    static func saveDeletedComment(uniqueId: String) {
        var deletedCommentUIDs = SharedPreferences.getDeletedCommentUniqueId() ?? []
        
        if deletedCommentUIDs.contains(uniqueId) {
            return
        }
        
        deletedCommentUIDs.append(uniqueId)
        defaults.setValue(deletedCommentUIDs, forKeyPath: "deleted_comment_uniqueid")
    }
    
    static func saveRoomId(id: String) {
        defaults.set(id, forKey: "multichannel_room_id")
    }
    
    static func getDeletedCommentUniqueId() -> [String]? {
        return defaults.array(forKey: "deleted_comment_uniqueid") as? [String]
    }
    
    static func getRoomId() -> String? {
        return defaults.string(forKey: "multichannel_room_id")
    }
    
    static func saveParam(param: [String:Any]) {
        defaults.set(param, forKey: "multichannel_param")
    }
    
    static func getParam() -> [String: Any]? {
        return defaults.dictionary(forKey: "multichannel_param")
    }
    
    static func removeRoomId() {
        defaults.set(nil, forKey: "multichannel_room_id")
    }
}
