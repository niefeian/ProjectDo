//
//  PayUtils.swift
//  FBSnapshotTestCase
//
//  Created by 聂飞安 on 2020/4/22.
//

import UIKit
import STRIAPManagerUtils
import AutoData
import NFAToolkit
import NFASubprojects
import NFANetwork

public protocol PayManagerDelegate : NSObjectProtocol {
    func paySuccess(_ payResult : PayResult , payConfig : PayConfig)
    func payError(_ error : Error)
}


public  enum PayStatusType {
    case  生成订单 , 正在向苹果发起支付 , 用户取消支付 , 请求支付时网络连接异常正在恢复购买  , 请求支付时网络连接异常重新购买 , 用户支付成功准备发往服务端  ,订单恢复中 , 服务端校验失败 , 重试连接服务器失败 , 订单完成 , 网络异常导致失败
}

public enum PayType {
    case  内购 , 微信
}

public class PayConfig: NSObject {
    
    @objc public var openWeb   = true //是否打开网页
    @objc public var closeSelf  = true //是否关闭自己
    @objc public var isRecovery  = false //是否是恢复
    @objc public var showLoding  = true //是否弹框
    
    @objc var maxCount = 2 // 最大重试次数
    @objc var tmpid  = "" //服务器返回的订单id
    @objc var purchID : String!//商品id
    @objc var mobile : String!//手机号码
    @objc var para : [String:String]!//携带的参数
    @objc var nowCount = 0 //目前重试次数
    @objc var ohash  = ""
    
    var payStatus : PayStatusType! = .生成订单
    
    required  public init(_ purchID:String , openWeb : Bool , closeSelf : Bool , para : [String:String] ) {
        self.purchID = purchID
        self.openWeb = openWeb
        self.closeSelf = closeSelf
        self.para = para
    }
}


open class PayUtils: NSObject {
    
    static public let sharedInstance = PayUtils()
    private var payQueue = [String:PayConfig]()
    public weak var delegate : PayManagerDelegate!
    public var payType : PayType = PayType.内购
    private var subscribeId = ""
    public var subscribType = "subscrib"
    
    class public func startPurch(_ purchID : String , para : [String:String] , openWeb : Bool = false , closeSelf : Bool = true , mobile : String = "" , isGetorder : Bool = true){
        sharedInstance.startPurch(purchID, para: para, openWeb: openWeb, closeSelf: closeSelf , mobile: mobile,isGetorder: isGetorder)
    }
    
    class public func restoreCompletedTransactions(_ para : [String:String]){
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: "正在恢复购买")
        STRIAPManager.shareSIAP().restoreCompletedTransactionsPara(para.dicValueString() ?? "")
    }
    
    class public func setSubscribeId(_ subscribeId : String){
        self.sharedInstance.subscribeId = subscribeId
        STRIAPManager.shareSIAP().subscribeId = subscribeId
    }
    
     //设置支付结果回调
    class public func setCompleteHandle(){
        STRIAPManager.shareSIAP().setCompleteHandle { (type, data, para, tmpid, key , orderId,info) in
            if type == SIAPPurchSuccess || type == SIAPPurchRestored {
                if  self.sharedInstance.payQueue[orderId] == nil {
                    if let map = (para as? String)?.stringToDic() as? [String : String] {
                        let model = PayConfig(orderId,openWeb: true,closeSelf: false,para: map )
                        model.payStatus = .订单恢复中
                        model.showLoding = orderId != self.sharedInstance.subscribeId
                        self.sharedInstance.payQueue[orderId] = model
                    }
                }else if self.sharedInstance.payQueue[orderId]?.payStatus == .网络异常导致失败  {
                    self.sharedInstance.payQueue[orderId]?.payStatus = .请求支付时网络连接异常正在恢复购买
                }
                queueMainAsync(work: {
                    sharedInstance.setresult(payfrom:"iap",ext:data.base64EncodedString(), orderId: orderId, para: para as! String, orderstatus: "\(type.rawValue)", tmpid: tmpid ,mobile: (para as! String).stringToDic()?["mobile"] as? String ?? "", ohash:"")
                })
            }
        }
        
        //自动续订的恢复购买走这边的流程
        STRIAPManager.shareSIAP().verifySubscribe { (arr) in
            if arr.count > 0 {
                let dataStr = STRIAPManager.shareSIAP().verifyPurchase().base64EncodedString()
                if dataStr.count > 0 , sharedInstance.subscribeId.count > 0 {
                    if  self.sharedInstance.payQueue[sharedInstance.subscribeId] == nil {
                        let model = PayConfig(sharedInstance.subscribeId,openWeb: false,closeSelf: false,para: ["type":sharedInstance.subscribType] )
                        model.isRecovery = true
                        model.showLoding = false
                        self.sharedInstance.payQueue[sharedInstance.subscribeId] = model
                    }
                    self.sharedInstance.payQueue[sharedInstance.subscribeId]?.payStatus = .订单恢复中
                    queueMainAsync(work: {
                        sharedInstance.setresult(payfrom:"iap",ext:dataStr, orderId: sharedInstance.subscribeId, para: ["type":sharedInstance.subscribType].dicValueString() ?? "" , orderstatus: "0", tmpid: "", ohash:"")
                    })
                }else{
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.AsyncDisappear), object: "恢复失败")
                }
            }else{
                if  sharedInstance.subscribeId.count > 0 {
                      let dataStr = STRIAPManager.shareSIAP().verifyPurchase().base64EncodedString()
                    if  self.sharedInstance.payQueue[sharedInstance.subscribeId] == nil {
                      let model = PayConfig(sharedInstance.subscribeId,openWeb: false,closeSelf: false,para: ["type":sharedInstance.subscribType] )
                      model.isRecovery = true
                      model.showLoding = false
                      self.sharedInstance.payQueue[sharedInstance.subscribeId] = model
                    }
                    self.sharedInstance.payQueue[sharedInstance.subscribeId]?.payStatus = .订单恢复中
                    queueMainAsync(work: {
                        sharedInstance.setresult(payfrom:"iap",ext:dataStr, orderId: sharedInstance.subscribeId, para: ["type":sharedInstance.subscribType].dicValueString() ?? "" , orderstatus: "0", tmpid: "", ohash:"")
                    })
                }
            }
       }
        
        STRIAPManager.shareSIAP().binAppLog { (log) in
            printLogInsatll(log)
        }
        //兼容旧版本，对通知进行转意
//        sharedInstance.regisNotificationCenter()
        
        setErrorderHandle()
    }
          
    
    class private func setErrorderHandle(){
          
           STRIAPManager.shareSIAP().version = 1
           STRIAPManager.shareSIAP().autoRestoreCompletedTransactions(false)
           STRIAPManager.shareSIAP().binLog { (transactionIdentifier, desc, error , applicationUsername , purchID ) in
              let es = error as NSError
            
            if !([7,-1001,-1003].contains(es.code)) {
                  //用户取消购买
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.AsyncDisappear), object: es.code == 2 ? "用户取消购买" : "购买失败,请稍后重试~")
                self.sharedInstance.payQueue.removeValue(forKey: purchID)
              }else{
                
                  if let model = self.sharedInstance.payQueue[purchID] ,  model.payStatus == .正在向苹果发起支付{
                        Tools.delay(3) {
                            DispatchQueue.main.async(execute: {
                            self.sharedInstance.payQueue[purchID]?.payStatus = .请求支付时网络连接异常重新购买
                            if let paras =  model.para?.dicValueString() {
                                STRIAPManager.shareSIAP().startPurch(withID:purchID,para:paras, tmpid: model.tmpid , info: "")
                            }
                                 })
                        }
                }else  if let model = self.sharedInstance.payQueue[purchID] ,  model.payStatus == .请求支付时网络连接异常正在恢复购买{
                    Tools.delay(3) {
                          DispatchQueue.main.async(execute: {
                            self.sharedInstance.payQueue[purchID]?.payStatus = .请求支付时网络连接异常重新购买
                            sharedInstance.startPurch(purchID, para: model.para , mobile: model.mobile , isGetorder: false)
                        })
                    }
                }else{
                      let err = NSError(domain: "\(es.domain) cod:\(es.code) applicationUsername:\(applicationUsername)" , code: es.code, userInfo: es.userInfo)
                      self.sharedInstance.delegate?.payError(err)
                      self.sharedInstance.payQueue.removeValue(forKey: purchID)
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.AsyncDisappear), object: "购买失败，请稍后重试~")
                  }
              }
          }
      }

    public func startPurch(_ purchID : String , para : [String:String] , openWeb : Bool = true , closeSelf : Bool = true  , mobile : String = "" , isGetorder : Bool = true){
//        if let queue = payQueue[purchID] ,  queue.payStatus == . 正在向苹果发起支付 ||  queue.payStatus == . 用户支付成功准备发往服务端 {
//           NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: "当前有进行中订单，请稍后重试~")
//        }else if let queue = payQueue[purchID] ,  queue.payStatus == . 重试连接服务器失败 ||  queue.payStatus == . 服务端校验失败{
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: "正在恢复您的订单信息~")
//            payQueue[purchID]?.payStatus = .生成订单
//            setresult("", orderId: purchID, para: queue.para?.dicValueString() ?? "", orderstatus: "0", tmpid: "")
//        }else{
            //当前有一单正在处理中、 不允许再次下同一个商品
            var paras = [String:String]()
            paras.addAll(para)
            if mobile.count > 0
            {
                  paras["mobile"] = mobile
            }
            print(paras)
            let model = PayConfig(purchID,openWeb: openWeb,closeSelf: closeSelf,para: paras)
            payQueue[purchID] = model
            startPurch(purchID, para: paras , mobile: mobile , isGetorder : isGetorder)
//        }
    }
    
    //直接获结果
    public func setresult(payfrom : String = "iap",orderId : String , ext : String = "" , para : [String:String] , showLoding : Bool =  true , openWeb : Bool = true , closeSelf : Bool = true , mobile : String = "", ohash : String = "" , tmpid : String = "" ){
            if let queue = payQueue[orderId] ,  queue.payStatus == . 用户支付成功准备发往服务端 {
//                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: "当前有未完结订单，请稍后重试~")
                //当前有一单正在处理中、 不允许再次下同一个商品
            }else{
                let model = payQueue[orderId] ?? PayConfig(orderId,openWeb: openWeb,closeSelf: closeSelf,para: para)
                model.closeSelf = closeSelf
                model.para = para
                payQueue[orderId] = model
                payQueue[orderId]?.payStatus = .生成订单
                setresult(payfrom:payfrom,ext: ext, orderId: orderId, para: para.dicValueString() ?? "", orderstatus: "0", tmpid: tmpid , ohash:ohash)
            }
       }
    
    //支付成功后，上传订单信息
    private func setresult(payfrom : String , ext : String , orderId : String , para : String , orderstatus : String, key : String = "" , tmpid : String , showLoding : Bool =  true , mobile : String = "" , ohash : String ){
        if  payQueue[orderId]?.payStatus == .用户支付成功准备发往服务端 || payQueue[orderId]?.payStatus == .订单完成 ||  payQueue[orderId]?.payStatus == .重试连接服务器失败  ||  payQueue[orderId]?.payStatus == .服务端校验失败{
            return
        }
        
        payQueue[orderId]?.payStatus = .用户支付成功准备发往服务端
        setresultHttp(payfrom: payfrom, ext: ext,orderId: orderId,para: para,orderstatus: orderstatus,key: key,tmpid: tmpid,showLoding: showLoding,mobile: mobile, ohash:ohash)
    }
    
 
    private func setresultHttp(payfrom : String , ext : String , orderId : String , para : String , orderstatus : String , key : String = "" , tmpid : String , showLoding : Bool =  true , mobile : String = "" , ohash : String ){
        if UIApplication.shared.applicationState == .background
        {
            Tools.delay(3) {
                self.setresultHttp(payfrom: payfrom, ext: ext,orderId: orderId,para: para,orderstatus: orderstatus,key: key,tmpid: tmpid,showLoding: showLoding,mobile: mobile, ohash:ohash)
            }
            
            return
        }
        
        
        if  payQueue[orderId]?.showLoding != false && payfrom != "wx"  {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: payQueue[orderId]?.payStatus == .服务端校验失败 ?  "网络异常，正在重新请求" : "正在获取结果")
        }
      
        printLogInsatll("正在获取结果")
        setresult(payfrom, result: orderstatus == "0" ? "1":"-1" , ext: ext ,para : para, mobile:  mobile, orderstatus: orderstatus, orderId: orderId, transactionIdentifier: key, tmpid: tmpid, ohash:ohash , callback: { (d) in
            printLogInsatll("得到结果")
            sleep(2)
            if let map = d as? [String:PayResult] , let model = map["data"] ,let queue = self.payQueue[orderId]{
                self.delegate?.paySuccess(model, payConfig: queue)
                self.payQueue[orderId]?.payStatus  = .订单完成
                self.payQueue[orderId]?.nowCount = 0
            }else if let map = d as? [String:PayResult] , let model = map["data"] {
                let queue = PayConfig(orderId, openWeb: true,closeSelf: false, para: [String:String]())
                queue.isRecovery = true
                self.delegate?.paySuccess(model, payConfig: queue)
            }
            STRIAPManager.shareSIAP().finishTransaction(byPurchID: orderId)
        },errorCB: { (d) in
            if payfrom == "wx"{
                return
            }
            printLogInsatll("报错")
            if let model = self.payQueue[orderId] {
                if let map = d as? NSDictionary ,  map.string(forKey: "debug") == "会员已过期"
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: map.string(forKey: "debug"))
                    model.payStatus = .订单完成
                    self.payQueue[orderId]  = model
                }
                else if model.isRecovery
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: "恢复失败")
                    model.payStatus = .重试连接服务器失败
                    self.payQueue[orderId]  = model
                    STRIAPManager.shareSIAP().finishTransaction(byPurchID: orderId)
                }
                else
                {
                    model.payStatus = .服务端校验失败
                    model.nowCount += 1
                    if model.nowCount < model.maxCount
                    {
                        //判断当前应用是不是在后台
                         self.setresultHttp(payfrom: payfrom, ext: ext,orderId: orderId,para: para,orderstatus: orderstatus,key: key,tmpid: tmpid,showLoding: showLoding,mobile: mobile, ohash:ohash)
                        self.payQueue[orderId]  = model
                      
                    }else{
                        if !ReachabilityNotificationView.getIsReachable()
                        {
                            model.payStatus = .网络异常导致失败
                        }
                        else
                        {
                            model.payStatus = .重试连接服务器失败
                        }
                        model.nowCount = 0
                        self.payQueue[orderId]  = model
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: "网络异常，请联系客服")
                       
                    }
                }
            }
        })
    }
    
    
    
    private func setresult(_ payfrom : String , result  : String , ext : String  , para : String,mobile:String , orderstatus : String ,orderId : String , transactionIdentifier : String , tmpid : String , ohash : String , callback : @escaping CBWithParam , errorCB : CBWithParam? = nil){
        HttpUtil.POST("apicurrency::setresult", params:["payfrom" : payfrom , "result" : result , "ext" : ext , "para" : para , "mobile":mobile, "orderid":orderId , "orderstatus" : orderstatus , "transactionIdentifier":transactionIdentifier,"tmpid" :tmpid , "ohash":ohash] , keys: ["data"] , models: [PayResult.classForCoder()], errorCB: errorCB, callback: callback)
    }
        
    private func startPurch(_ purchID : String , para : [String:String] , mobile : String = "" , isGetorder : Bool){
        if let paras = para.dicValueString() {
               
            if isGetorder {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: "正在发起购买")
                getorder(para: paras, mobile: mobile, orderId: purchID, callback: { (data) in
                  if let tmpid = (data as? NSDictionary)?.object(forKey: "tmpid") as? String
                  {
                        self.payQueue[purchID]?.tmpid = tmpid
                        self.payQueue[purchID]?.payStatus = .正在向苹果发起支付
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: "正在支付")
                        STRIAPManager.shareSIAP().startPurch(withID:purchID,para:paras, tmpid: tmpid, info: "")
                  }
                  else if let tmpid = ((data as? NSDictionary)?.object(forKey: "data") as? NSDictionary)?.object(forKey: "tmpid") as? String
                  {
                        self.payQueue[purchID]?.tmpid = tmpid
                        self.payQueue[purchID]?.payStatus = .正在向苹果发起支付
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: "正在支付")
                        STRIAPManager.shareSIAP().startPurch(withID:purchID,para:paras, tmpid: tmpid, info: "")
                    }
                })
                
            }else{
                self.payQueue[purchID]?.tmpid = "0"
                self.payQueue[purchID]?.payStatus = .正在向苹果发起支付
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: "正在支付")
                 STRIAPManager.shareSIAP().startPurch(withID:purchID,para:paras, tmpid: "0", info: "")
            }
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.FloatTips), object: "测算信息异常，请重新填写")
        }
    }

   private func getorder( para : String , mobile:String , orderId : String , callback : @escaping CBWithParam ){
        HttpUtil.POST("apicurrency::getorder", params:["payfrom" : "iap" ,"para" : para , "mobile":mobile, "orderid":orderId ], errorCB: { error in
            if let e = error as? NSError {
                self.delegate?.payError(e)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: "网络异常，请稍后重试~")
            }else if let map = error as? NSDictionary{
                self.delegate?.payError(NSError(domain: map["debug"] as? String ?? "", code: 100, userInfo: map as? [String : Any]))
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: map["debug"] as? String ?? "网络异常，请稍后重试~")
            }else if let err = error as? String{
                self.delegate?.payError(NSError(domain: err, code: 100, userInfo: nil))
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: "网络异常，请稍后重试~")
            }
        }, callback: callback)
    }
    
      
      @objc func showLondTip(_ obj : Notification){
          if let msg = obj.object as? String {
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.AsyncDisappear), object: msg)
          }
      }
      
      @objc func showLonding(_ obj : Notification){
         if let msg = obj.object as? String {
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.ShowLoding), object: msg)
         }
      }
      
      @objc func showLondTips(_ obj : Notification){
         if let msg = obj.object as? String {
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: msg)
         }
      }


     @objc func hideLondTip(){
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopConstants.Disappear), object: nil)
     }
         
}
