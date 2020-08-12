//
//  NotificationConstant.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/6/12.
//

import UIKit

public let UserChangedNotification = NSNotification.Name("UserChangedNotification")
public let MessageNotification = NSNotification.Name("MessageNotification")
public let ReloadWebNotification = NSNotification.Name("ReloadWebNotification")

//绑定信息
public let UserBinNotification = NSNotification.Name("UserBinNotification")


public let ShowLoding = NSNotification.Name("ShowLoding")
public let UpdateLoding = NSNotification.Name("UpdateLoding")
public let Disappear = NSNotification.Name("Disappear")
public let FloatTips = NSNotification.Name("FloatTips")
public let AsyncShowLoding = NSNotification.Name("AsyncShowLoding")
public let AsyncUpdateLoding = NSNotification.Name("AsyncUpdateLoding")
public let AsyncDisappear = NSNotification.Name("AsyncDisappear")
public let AsyncFloatTips = NSNotification.Name("AsyncFloatTips")


public class AppNotification {
    
    public class Statistics
    {
        static public let EnterForeground = NSNotification.Name("EnterForeground")
    }
    
    public class Keyboard
    {
        static public let AllHide = NSNotification.Name("AllHide")
    }
    
    public class  STATUS_BAR
    {
        static public let Hidden = NSNotification.Name("Hidden")
        static public let Show = NSNotification.Name("Show")
    }
    
    public class  ADLoad
    {
        static public let LoadAD = NSNotification.Name("LoadAD")
    }
}
