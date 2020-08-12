//
//  CustTabBarVC.swift
//  cloudclass
//自定义的UITabBarController，主要是整个工程不允许随重力转屏，但是对于视频播放的界面，又需要能实现全屏的效果。所以目前对于整个工程的配置info中，设置为允许全屏Landscape_right。对于多页签的界面，需要直接采用当前的tabBarController
//  Created by jacty on 16/4/19.
//  Copyright © 2016年 accfun. All rights reserved.
//

import Foundation
import UIKit

open class CustTabBarVC: UITabBarController {
    
   
    override open var shouldAutorotate : Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        

    }
        
    
}

