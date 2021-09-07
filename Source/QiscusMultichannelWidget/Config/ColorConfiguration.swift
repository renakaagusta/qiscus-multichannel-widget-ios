//
//  QiscusColorConfiguration.swift
//  QiscusSDK
//
//  Created by Ahmad Athaullah on 9/7/16.
//  Copyright © 2016 Ahmad Athaullah. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

class ColorConfiguration: NSObject {
    
    /// Your left bubble color, using UIColor class
    static var leftBubbleColor: UIColor = #colorLiteral(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
    
    /// Your right bubble color, using UIColor class
    static var rightBubbleColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.6, alpha: 1)
    
    /// Your navigation color, using UIColor class
    static var navigationColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.6, alpha: 1)
    
    static var sendContainerColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.6, alpha: 1)
    
    static var fieldChatBorderColor: UIColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9137254902, alpha: 1)
    
    static var sendContainerBackgroundColor: UIColor = #colorLiteral(red: 0.9844431281, green: 0.9844661355, blue: 0.9844536185, alpha: 1)
    
    static var navigationTitleColor: UIColor = .white
    
    /// Your right bubble color, using UIColor class
    static var systemBubbleColor: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    
    /// Your right bubble color, using UIColor class
    static var systemBubbleTextColor: UIColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    /// Your left bubble text color, using UIColor class
    static var leftBubbleTextColor: UIColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    /// Your right bubble text color, using UIColor class
    static var rightBubbleTextColor: UIColor = .white
    
    /// Your text color of time label, using UIColor class
    static var timeLabelTextColor: UIColor = #colorLiteral(red: 133/255.0, green: 133/255.0, blue: 133/255.0, alpha: 1)
    
    static var timeBackgroundColor : UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    
    /// Your failed text color if the message fail to send, using UIColor class
    static var failToSendColor: UIColor = UIColor(red: 1, green: 19/255.0, blue: 0, alpha: 1)
    
    static var readMessageColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.6, alpha: 1)
    
    static var sentOrDeliveredColor: UIColor = #colorLiteral(red: 133/255.0, green: 133/255.0, blue: 133/255.0, alpha: 1)
    
    /// Your link color of left bubble chat, using UIColor class, Default value : UIColor.whiteColor()
    static var leftBubbleLinkColor: UIColor = UIColor.white
    
    /// Your link color of right bubble chat, using UIColor class
    static var rightBubbleLinkColor: UIColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    static var topColor: UIColor = UIColor(red: 0, green: 0.443, blue: 0.733, alpha: 1)
    
    static var baseColor: UIColor = #colorLiteral(red: 0.9782221503, green: 0.9782221503, blue: 0.9782221503, alpha: 1)
    
    static var emptyChatBackgroundColor: UIColor = #colorLiteral(red: 0.9782221503, green: 0.9782221503, blue: 0.9782221503, alpha: 1)
    
    static var emptyChatTextColor: UIColor = .lightGray
    
    static var bottomColor: UIColor = UIColor(red: 23/255.0, green: 177/255.0, blue: 149/255.0, alpha: 1)
    
    static var tintColor: UIColor = UIColor.white
    
    static var alertPopUpConfirmationColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.6, alpha: 1)
    
    static var buttonStartNewChat: UIColor = UIColor.white
    
    fileprivate override init(){}
}
