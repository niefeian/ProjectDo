//
//  BaseViewController.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/4/15.
//

import UIKit
import NFAToolkit

open class BaseViewController: UIViewController , IDataPost {
    
    open var callBack: CBWithParam?
    open var postData : AnyObject?
    open var loding = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
        print("当前类:\(self.classForCoder)")
        #endif
        // Do any additional setup after loading the view.
    }
    

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -500, vertical: 0), for: UIBarMetrics.default)
    }
    
    open func postData(_ postData : AnyObject?) {
       self.postData = postData
    }

    open func regCallBack(_ cb : @escaping CBWithParam) {
       self.callBack = cb
    }

    deinit {
       #if DEBUG
       print("\(self.classForCoder)销毁")
       #endif
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
