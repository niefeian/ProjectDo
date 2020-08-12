//
//  AppPopDelegate.swift
//  FBSnapshotTestCase
//
//  Created by 聂飞安 on 2020/4/21.
//

import UIKit
import SwiftProjects
import NFAToolkit
import NFATipsUI

public enum LodingType {
      case 罗盘 , 菊花
}


open class AppPopDelegate: NSObject {
    
    static public let sharedInstance = AppPopDelegate()
    public var lodingImage : UIImage!
    public var lodingRunImage : UIImage!
    private var lodingType : LodingType! = .罗盘

    public override init() {
        super.init()
        self.regisNotificationCenter()
    }
    
    private func regisNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.disappearPop(_:)), name: NSNotification.Name(rawValue: PopConstants.Disappear), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.asyncDisappearPop(_:)), name: NSNotification.Name(rawValue: PopConstants.AsyncDisappear), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.floatTips(_:)), name: NSNotification.Name(rawValue: PopConstants.FloatTips), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.asyncFloatTips(_:)), name: NSNotification.Name(rawValue: PopConstants.AsyncFloatTips), object: nil)
    }
    
    public func regisLodingPop(_ image : UIImage , runImage : UIImage){
        lodingImage = image
        lodingRunImage = runImage
        lodingType = .罗盘
        regisNotificationCenterTips()
    }
    
  
    public func regisLodingPopType(_ lodingType : LodingType ){
        self.lodingType = lodingType
        regisNotificationCenterTips()
    }
    
    
    private func regisNotificationCenterTips(){
          
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PopConstants.AsyncShowLoding), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.showMainLoding(_:)), name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.showAsyncLoding(_:)), name: NSNotification.Name(rawValue: PopConstants.AsyncShowLoding), object: nil)
      }
      
    
    @objc func floatTips(_ obj : Notification){
        if let msg = obj.object as? String , msg.count > 0{
            showTipsWindow(msg)
        }
    }
    
    @objc func asyncFloatTips(_ obj : Notification){
       DispatchQueue.main.async(execute: {
           self.floatTips(obj)
       })
    }
    
    @objc func disappearPop(_ obj : Notification){
        ResidentManager.curPopViewController?.disappear?()
        asyncFloatTips(obj)
    }
    
    @objc func asyncDisappearPop(_ obj : Notification){
       DispatchQueue.main.async(execute: {
           self.disappearPop(obj)
       })
    }
    
    @objc func showAsyncLoding(_ obj : Notification){
        DispatchQueue.main.async(execute: {
            self.showMainLoding(obj)
        })
    }
    
    @objc func showMainLoding(_ obj : Notification){
       if let msg = obj.object as? String {
           updateLoding(msg)
       }
    }
    
}

extension AppPopDelegate{
    
    private func showLoding(_ text : String){
        if ResidentManager.curPopViewController is PayLoding || ResidentManager.curPopViewController is LodingView || ResidentManager.curViewController == nil{
           return
        }
        ResidentManager.curPopViewController?.disappear?()
        if lodingType == .罗盘{
            let vc = PayLoding()
            let pop = PopupController.create(ResidentManager.curViewController)?.customize([ .animation(.none), .scrollable(false), .backgroundStyle(.blackFilter(alpha: 0.5)) ])
            vc.setLoding(text)
            pop?.show(vc)
        }else if lodingType == .菊花{
            let vc = LodingView()
            let pop = PopupController.create(ResidentManager.curViewController)?.customize([ .animation(.none), .scrollable(false), .backgroundStyle(.blackFilter(alpha: 0.5)) ])
            vc.setLoding(text)
            pop?.show(vc)
        }
    }

    private func updateLoding(_ text : String){
        if let vc = ResidentManager.curPopViewController as? PayLoding{
           vc.setLoding(text)
        }else if let vc = ResidentManager.curPopViewController as? LodingView{
           vc.setLoding(text)
        }else{
           showLoding(text)
        }
    }
}
