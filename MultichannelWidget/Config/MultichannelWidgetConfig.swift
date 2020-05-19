//
//  MultichannelWidgetConfig.swift
//  MultichannelWidget
//
//  Created by Rahardyan Bisma on 19/05/20.
//

import Foundation

open class MultichannelWidgetConfig {
    private var avatar: String = ""
    private var extras: String = ""
    private var userProperties: [[String : String]] = []
    private var rightBubleColor: UIColor = ColorConfiguration.rightBaloonColor
    private var leftBubleColor: UIColor = ColorConfiguration.leftBaloonColor
    private var navigationColor: UIColor? = ColorConfiguration.navigationColor
    
    public func setExtras(extras: String) -> MultichannelWidgetConfig {
        self.extras = extras
        return self
    }
    
    public func setUserProperties(properties: [[String : String]]) -> MultichannelWidgetConfig {
        self.userProperties = properties
        return self
    }
    
    public func setRightBubleColor(color: UIColor) -> MultichannelWidgetConfig {
        self.rightBubleColor = color
        return self
    }
    
    public func setLeftBubleColor(color: UIColor) -> MultichannelWidgetConfig {
        self.leftBubleColor = color
        return self
    }
    
    public func setNavigationColor(color: UIColor) -> MultichannelWidgetConfig {
        self.navigationColor = color
        return self
    }
    
    public func setAvatar(avatarUrl: String) -> MultichannelWidgetConfig {
        self.avatar = avatarUrl
        return self
    }
    
    public func startChat(callback: @escaping (UIViewController) -> Void) {
        ColorConfiguration.navigationColor = self.navigationColor
        QismoManager.shared.initiateChat(extras: self.extras, userProperties: self.userProperties, callback: callback)
    }
}
