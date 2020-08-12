//
//  BasePopVC.swift
//  SwiftProjects
//
//  Created by 聂飞安 on 2020/4/2.
//

import UIKit
import NFAToolkit

open class BasePopVC: BaseViewController , PopupContentViewController {
    
    private var popSize = CGSize.zero
    
    override open func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
    }
   
    open func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return popSize
    }
    
   open func regisPopSize(_ popSize : CGSize) {
       self.popSize = popSize
   }
    
   
    
   
}
