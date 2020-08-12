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
    open var disappear : CB?
    
    override open func viewDidLoad() {
       super.viewDidLoad()
        viewType = .弹框
       // Do any additional setup after loading the view.
    }
   
    open func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return popSize
    }
    
   open func regisPopSize(_ popSize : CGSize) {
       self.popSize = popSize
   }
    
    @objc open func closeView() {
        disappear?()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if ResidentManager.curPopViewController ==  self
        {
             ResidentManager.curPopViewController =  nil
        }
    }
   
}
