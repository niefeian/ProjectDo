//
//  LogManager.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/4/15.
//

import UIKit
import NFAFile
import NFAToolkit


public protocol LogManagerDelegate : NSObjectProtocol {
    func sendHttpLog(_ content : String , type : String)
}

open class LogManager: NSObject {
    
    private static var sharedInstance  = LogManager()
    weak public var delegate : LogManagerDelegate!
    
    public class func uploadLog() {
        sharedInstance.uploadLog()
    }
    
    public class func writeLog(_ e : NSException  , param : [String:String] = [String:String]()) {
        sharedInstance.writeLog(e,param:param )
    }
    
    private func uploadLog(){
        if let logsPath = FileUtil.getPath(.log, isDir: true) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: logsPath +  "error.log")) {
                let logs = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                 // 1. 上传日志到服务器
                 if logs != nil {
                    delegate?.sendHttpLog(logs as String? ?? "", type: "client")
                 }
                 // 2. 删除日志
                 let fileMan = FileManager.default
                 do {
                     try fileMan.removeItem(atPath: logsPath)
                 } catch  {
                 }
            }
        }
    }
    
    // 写日志
    private func writeLog(_ e : NSException , param : [String:String]) {

      let infoDictionary = Bundle.main.infoDictionary!
      let appVer = infoDictionary["CFBundleShortVersionString"]! as! String
        
        var params = [String:Any]()
        params.addAll(param)
        params["appVer"] = infoDictionary["CFBundleShortVersionString"]! as! String
        params["version"] = UIDevice.current.systemVersion + ": appVersion:\(appVer)"
        params["now"] = DateUtil.dateTimeToStr(DateUtil.curDate())
        params["errorName"] = e.name.rawValue
        params["reason"] = e.reason ?? ""
        params["stack"] =  e.callStackSymbols
        params["curViewController"] =  "\(String(describing: ResidentManager.curViewController))"
        
        if let  error = params.dicValueString() {
            if let logsPath = FileUtil.getPath(.log, isDir: true) {
                let logPath = logsPath + "error.log"
                do {
                    try error.write(to: URL(fileURLWithPath: logPath), atomically: true, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                 } catch  {
     
                 }
            }
        }
    }
}
