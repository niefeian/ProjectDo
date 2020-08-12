//
//  CustNavigationVC.swift
//  cloudclass
//  自定义的UINavigationController，主要是整个工程不允许随重力转屏，但是对于视频播放的界面，又需要能实现全屏的效果。所以目前对于整个工程的配置info中，设置为允许全屏Landscape_right。而所有的界面都采用当前nvc作为rootViewController
//  Created by jacty on 16/4/19.
//  Copyright © 2016年 accfun. All rights reserved.
//

import Foundation
import UIKit


open class CustNavigationVC: UINavigationController {
    
    override open var shouldAutorotate : Bool {
        return false
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
