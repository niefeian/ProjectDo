//
//  AppStatistics.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/7/3.
//

import UIKit

public class AppUseTime : NSObject
{
   public var totalUseTime : Double! = 0 //使用时长
   public var totalDormancyTime : Double = 0 //休眠时长
   public var dormancyNum : Int = 0 //休眠次数
   public var currentUseTime : Double = 0 //本次使用时长
   public var currentDormancyTime : Double = 0 //本次休眠时长
   public var startTime : Double = Date().timeIntervalSince1970
   public var restartTime : Double = Date().timeIntervalSince1970
    {
        didSet
        {
            currentDormancyTime = restartTime - closeTime
            totalDormancyTime += currentDormancyTime
            
        }
    }
    
   public var closeTime : Double = Date().timeIntervalSince1970
    {
        didSet
        {
            currentUseTime = closeTime - restartTime
            totalUseTime += currentUseTime
            dormancyNum += 1
        }
    }
   
}

//应用统计
public class AppStatistics: NSObject {
    
    public var appUseTime : AppUseTime!
    public var timeBlock : (() -> Void)!
    public var runTimerSpeed : Double = 1
    public var openRunTimer : Bool!
    {
        didSet{
            if oldValue != openRunTimer
            {
                runTime()
            }
        }
    }
    
    static public let sharedInstance = AppStatistics()
    
    public func regisAppUseTime(){
         
        appUseTime = AppUseTime()
        NotificationCenter.default.addObserver(self, selector:#selector(self.willEnterForegroundNotification) , name: UIApplication.willEnterForegroundNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector:#selector(self.didEnterBackgroundNotification) , name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    
    @objc func runTime(){
        if   runTimerSpeed > 0 && openRunTimer
        {
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + Double(Int64(runTimerSpeed * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.runTime()
            })
        }
        if openRunTimer
        {
           timeBlock?()
        }
       
    }
    
    @objc func  willEnterForegroundNotification(){
        appUseTime?.restartTime = Date().timeIntervalSince1970
        NotificationCenter.default.post(name: AppNotification.Statistics.EnterForeground, object: appUseTime)
    }
    
    @objc func  didEnterBackgroundNotification(){
        appUseTime?.closeTime = Date().timeIntervalSince1970
    }
}
