//
//  BaseProVC.swift
//  SwiftProjects
//
//  Created by 聂飞安 on 2020/4/2.
//

import UIKit
import NFAToolkit

open class BaseProVC : BaseViewController {
   
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        viewType = .正常
        // Do any additional setup after loading the view.
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let count = self.navigationController?.viewControllers.count ?? 0
        if count > 1 &&  !(self.tabBarController?.tabBar.isHidden ?? false) {
            self.tabBarController?.tabBar.isHidden = true
        }else if count <= 1 && (self.tabBarController?.tabBar.isHidden ?? false){
            self.tabBarController?.tabBar.isHidden = false
        }
       
    }
    
  
    
    
}

