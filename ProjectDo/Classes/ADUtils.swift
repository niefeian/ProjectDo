//
//  ADUtils.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/4/22.
//

import UIKit
import AutoData
import NFAToolkit
import NFASubprojects
import SwiftProjects

@objc  public protocol ADManagerDelegate : NSObjectProtocol {
    @objc optional  func canHomeADShow() -> Bool
    @objc optional  func canUserADShow() -> Bool
    @objc optional  func canMemberADShow() -> Bool
    @objc optional  func openADUrl(_ model : AD)
}

public class ADUtils: NSObject {
    
    static public let sharedInstance = ADUtils()
    private var userAD : AD!
    private var homeAD : AD!
    private var memberAD : AD!
    private var allInit : Bool! = false
    public weak var delegate : ADManagerDelegate!
    var show : Bool = false
   public func regisNotificationCenter(){
        if allInit {
            return
        }
        allInit = true
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(self.reloadHomeOrUserAD) , name: NSNotification.Name(rawValue: ADConstants.Home), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.reloadHomeOrUserAD) , name: NSNotification.Name(rawValue: ADConstants.User), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.reloadAD) , name: UIApplication.willEnterForegroundNotification, object: nil)
    
        NotificationCenter.default.addObserver(self, selector:#selector(self.reloadAD) , name: AppNotification.ADLoad.LoadAD, object: nil)
//        Tools.delay(3) {
//            self.reloadAD()
//        }
    }
    
    @objc func reloadAD(){
        getad(gettype: "") { (dic) in
            if let map = dic as? [String:[AD]] , let list =  map["data->ad"]{
                self.reloadAllAD(list)
            }
        }
    }
    

    @objc func reloadAllAD(_ ads : [AD]){
        if ResidentManager.curPopViewController != nil || ResidentManager.curViewController ==  nil{
            return
        }
        memberAD = nil
        homeAD = nil
        userAD = nil
        for ad in ads {
            if ad.pos == "rand" {
                memberAD = ad
            }else if ad.pos == "index"{
                homeAD = ad
            }else if ad.pos == "profile"{
                userAD = ad
            }
        }
        if memberAD != nil && delegate?.canMemberADShow?() ?? false{
            showPop(memberAD)
            Tools.delay(0.3) {[weak self] in
                self?.memberAD = nil
            }
        }else {
           reloadHomeOrUserAD()
        }
    }
    
   @objc func reloadHomeOrUserAD(){
        if ResidentManager.curPopViewController != nil || ResidentManager.curViewController ==  nil{
           return
        }
        if self.homeAD != nil && self.delegate?.canHomeADShow?() ?? false{
            self.showPop(self.homeAD)
               Tools.delay(0.3) {
                   self.homeAD = nil
               }
            }else if self.userAD != nil && self.delegate?.canUserADShow?() ?? false{
               self.showPop(self.userAD)
               Tools.delay(0.3) {
                   self.userAD = nil
            }
        }
       
    }
    
    func showPop(_ admodel : AD?){
        if show {
            return
        }
        if let ad =  admodel {
            show = true
//            if ResidentManager.curViewController?.tabBarController?.selectedIndex == 3 {
//                ResidentManager.curViewController = AppViewController()
//            }
            if ad.full == "1"{
                delegate?.openADUrl?( ad)
                show = false
                return
            }
            
            let pop = PopupController.create( ResidentManager.curViewController)?.customize([ .animation(.none), .scrollable(false), .backgroundStyle(.blackFilter(alpha: 0.3)) ])
             let vw = ImagePopVC()
//            vw.imageSize =  CGSize(width: 270.pd6sW, height: 320.pd6sW + 50.pd6sW)
            vw.imageURL = ad.img
             vw.regCallBack {[weak self] (data) in
                self?.show = false
                if let i = data as? Int{
                    if i == 1 {
                        self?.delegate?.openADUrl?(ad)
                    }
                }
                pop?.dismiss()
             }
             vw.missBlock = {[weak self]  in
                self?.show = false
                Tools.delay(0.5) {
                    self?.reloadHomeOrUserAD()
                }
             }
             pop?.show(vw)
        }
    }
         
         
       
    
    func getad(gettype : String ,  callback : @escaping CBWithParam){
        HttpUtil.POST("apiconfig::getad", params:["latestpop":"\(DateUtil.curDate())" , "gettype" : gettype],keys: ["data->ad"],models: [AD.classForCoder()], errorCB: nil, callback: callback)
    }
}
